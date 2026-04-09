#include <limits.h>
#include <stdbool.h>
#include <stddef.h>

enum
{
    HTTP_XGH_BODY_LENGTH_UNTIL_CLOSE = -1,
    HTTP_XGH_BODY_LENGTH_TOO_BIG = -2,
#if 0
    HTTP_XGH_BODY_LENGTH_TRANSFER_ENCODING = -3,
#endif
};

static int acme_xgh_http_client_cs;
static int http_xgh_client_status;

static int http_xgh_client_body_length;
static int http_xgh_client_body_length_i;

static unsigned char *http_xgh_client_body_start;
static unsigned char *http_xgh_client_body_end;

static inline bool http_xgh_client_body_is_buffering(void)
{
    assert(/* TODO */);
    return /* TODO */;
}

#define HTTP_XGH_CLIENT_BODY_IS_BUFFERING(EOF) do { \
    enum acme_xgh_error e = \
    acme_xgh_http_client_body_recv( \
        http_xgh_client_body_start, \
        http_xgh_client_body_end, \
        (EOF)); \
    if (e != ACME_XGH_NONE) \
        return e; \
} while (0)

#if 0
static enum http_xgh_encoding
{
    HTTP_XGH_ENCODING_IDENTITY,
    HTTP_XGH_ENCODING_GZIP,
    HTTP_XGH_ENCODING_ZLIB,
    HTTP_XGH_ENCODING_BROTLI,
    HTTP_XGH_ENCODING_ZSTD,
} acme_xgh_http_client_encoding;
#endif

static int http_xgh_client_num;

static unsigned char acme_xgh_replay_nonce[200];
static int acme_xgh_replay_nonce_length;

static bool http_xgh_client_is_head;

%%{
    machine acme_xgh_http_client;
    alphtype unsigned char;

    variable cs acme_xgh_http_client_cs;

    include http_base "http_base.rl";

    action acme_xgh_http_client_init
    {
        acme_xgh_http_client_body_length = ACME_XGH_HTTP_BODY_LENGTH_UNTIL_CLOSE;
#if 0
        acme_xgh_http_client_encoding = ACME_XGH_HTTP_ENCODING_IDENTITY;
#endif
    }

    # TODO Maintenance burden (requires m4 to solve).
    action acme_xgh_skill_issue { return ACME_XGH_SKILL_ISSUE; }
    action acme_xgh_http_error_some { return ACME_XGH_HTTP_ERROR_SOME; }
    action acme_xgh_http_error_unrecoverable { return ACME_XGH_HTTP_ERROR_UNRECOVERABLE; }

    action http_xgh_body_start
    {
        acme_xgh_http_client_body_init();
          http_xgh_client_body_start;
        = http_xgh_client_body_end
        = fpc;
    }
    action http_xgh_body_advance
    {
        acme_xgh_http_client_body_end++;
    }
    action http_xgh_body_end
    {
        acme_xgh_http_client_body_start = NULL;
        acme_xgh_http_client_body_end = NULL;
        HTTP_XGH_CLIENT_BODY_IS_BUFFERING(acme_xgh_http_client_body_end);
    }

    action acme_xgh_http_client_is_body_not_exhausted
    {
        !acme_xgh_http_client_is_head && (
            ACME_XGH_HTTP_BODY_LENGTH_UNTIL_CLOSE
            == acme_xgh_http_client_body_length
            || acme_xgh_http_client_body_length_i++
             < acme_xgh_http_client_body_length
        )
    }

    action http_xgh_set_body_length_0
    {
        acme_xgh_http_client_body_length = 0;
    }
    action http_xgh_zero
    {
        acme_xgh_http_client_num = 0;
    }
    action http_xgh_concat_digit
    {
        int const x = fc - '0';
        if (acme_xgh_http_client_num > (INT_MAX - x) / 10)
            return HTTP_CLIENT_SKILL_ISSUE;
        else
            acme_xgh_http_client_num = acme_xgh_http_client_num * 10 + x;
    }
    action http_xgh_client_as_status
    {
        acme_xgh_http_client_status = acme_xgh_http_client_num;
    }
    action http_xgh_body_length_copy
    {
        acme_xgh_http_client_body_length = acme_xgh_http_client_num;
    }
    action http_xgh_body_length_assert
    {
        if (acme_xgh_http_client_body_length != acme_xgh_http_client_num)
            return ACME_XGH_HTTP_CLIENT_REJECT;
    }

    content_length = "Content-Length:"i @(pri_http_field,1) OWS
                     digit+ >do_zero $do_dig %body_length_numbah
                     (OWS ',' OWS digit+ >do_zero $do_dig %assert_body_length)*
                     OWS;
    transfer_encoding = "Transfer-Encoding:"i @(pri_http_field,1) @skill_issue OWS field_value OWS;
    content_encoding = "Content-Encoding:"i @(pri_http_field,1) @acme_xgh_skill_issue OWS field_value OWS;

    base64url = alnum | '-' | '_';

    replay_nonce_value = base64url+ > $ @ $!some_error
    replay_nonce = "Replay-Nonce"i @(pri_http_field,1) OWS replay_nonce_value OWS;

    known_field = content_encoding
                | content_length
                | transfer_encoding
                | replay_nonce
                ;

    field_line = known_field | any_field;

    empty_body_status_code = ( "1" digit digit
                             | "204"
                             | "304"
                             ) %body_length_0;
    # https://www.rfc-editor.org/rfc/rfc9112.html#section-6.3-2.1

    known_status_code = empty_body_status_code | "200";

    status_code = known_status_code | digit{3};
    reason_phrase = ( HTAB | SP | VCHAR | obs_text ){1,};

    status_line = HTTP_version SP status_code >do_zero $do_dig %as_status SP (reason_phrase)?;

    HTTP_message = ( CRLF* # https://datatracker.ietf.org/doc/html/rfc9112#section-2.2-6
                     status_line CRLF
                     (field_line CRLF)*
                     CRLF
                     any* when is_body_not_exhausted $dump
                   ) >init;

    main := HTTP_message** $!error_some;

    write data noerror nofinal noentry;
}%%

void acme_xgh_init(void)
{
    %% write init;
}

enum acme_xgh_error acme_xgh_recv(unsigned char *p, size_t len)
{
    unsigned char *pe = p + len, *eof = NULL;

    if (http_xgh_client_body_is_buffering)
          http_xgh_client_body_start
        = http_xgh_client_body_end
        = p
        ;

    %% write exec;

    if (http_xgh_client_body_is_buffering)
        HTTP_XGH_CLIENT_BODY_IS_BUFFERING(NULL);

    return ACME_XGH_NONE;
}
