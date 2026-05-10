define(`m4_xgh_lower',`abcdefghijklmnopqrstuvwxyz')dnl
define(`m4_xgh_upper',`ABCDEFGHIJKLMNOPQRSTUVWXYZ')dnl
#ifndef ACME_XGH_H
#define ACME_XGH_H

#include <stddef.h>

// Only source-compatibility supported for now. Enum may change order.
// No test harness to detect enum changes.

// TODO Inside this ACME library, there is a HTTP client library that
//      wants to get out. Most likely prefixed "http_xgh_*"

// TODO I completely forgot about when the TLS tunnel breaks and needs
//      new reconnection.

// HTTP 1.1 only for now, nothing fancy.
// This library is currently singleton (lots of global variables).
// This library has several fixed-size internal buffers, so no dynamic
// memory allocation: it will crash (yeah, crash) the entire process
// if a limit is reached.

// TODO Differentiate "okay" from "finished"

define(`M4_HTTP_XGH_ERROR_XS',`define(`X',`$1`'dnl')dnl
X(`none',`         ')
X(`skill_issue',`  ',1)
X(`some',`         ',1)
X(`unrecoverable',`',1)
X(`reject',`       ')
undefine(`X')dnl
')dnl
#define HTTP_XGH_ERROR_XS \
substr(M4_HTTP_XGH_ERROR_XS(``,' \
HTTP_XGH_X(translit($1,m4_xgh_lower,m4_xgh_upper)$2)'),4)

enum acme_xgh_error
{
    #define HTTP_XGH_X(ID) ACME_XGH_ERROR_##ID
    HTTP_XGH_ERROR_XS,
    #undef HTTP_XGH_X
};

// TODO WIP Just thinking how it will look like.
//          This part will handle what the Web server must serve.
//          It returns an int to discern several challenges.
//          Something else that confirms, haven't got around this part
//          yet.
extern int (*acme_xgh_challenge)(unsigned char *);

void acme_xgh_init(void);
enum acme_xgh_error acme_xgh_recv(unsigned char *, size_t len);

// Call "acme_xgh_recv(NULL, 0)" when EOF reached.

// If connection closed abruply, eventually call this when you
// re-establish it, before send/receiving more data.
// TODO detail more
void acme_xgh_retry(void);

#endif // ACME_XGH_H

#ifdef ACME_XGH_IMPLEMENTATION

#include <assert.h>
#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <string.h>

#define ACME_XGH_ENDPOINT_MAX 200

static unsigned char acme_xgh_replay_nonce[200];

static unsigned char *acme_xgh_resource_buffed;
static unsigned char acme_xgh_resource_endpoint_account[ACME_XGH_ENDPOINT_MAX];
static unsigned char acme_xgh_resource_endpoint_nnonce[ACME_XGH_ENDPOINT_MAX];
static int acme_xgh_resource_prog;

static int acme_xgh_resource_cs;
static int_least32_t acme_xgh_resource_stack;

%%{
    machine acme_xgh_resource_directory;
    alphtype unsigned char;

    variable cs acme_xgh_resource_cs;

    `include' json_xgh "json_xgh.rl";

    action buf
    {
        if (acme_xgh_resource_prog > ACME_XGH_ENDPOINT_MAX-2)
            return ACME_XGH_ERROR_SKILL_ISSUE;
        acme_xgh_resource_buffed[acme_xgh_resource_prog++] = fc;
    }
    action buf_zero { acme_xgh_resource_prog = 0; }
    action buf_account
    {
        acme_xgh_resource_buffed = acme_xgh_resource_endpoint_account;
    }
    action buf_nnonce
    {
        acme_xgh_resource_buffed = acme_xgh_resource_endpoint_nnonce;
    }
    action buf_end
    {
        acme_xgh_resource_buffed[acme_xgh_resource_prog] = '\0';
    }

    action die { return ACME_XGH_ERROR_SOME; }

    domain = "pebble"i; # TODO configure using m4... or allow config

    url = "https://"i domain '/' alnum+ $buf %buf_end;

    meta_field = empty #'"caaIdentities"'           %2 gc '[' url (ws ',' ws url)* ws ']'
               | '"externalAccountRequired"' %2 json_xgh_gc "false" # ("false" | "true")
               #| '"profiles"'                %2 gc profile
               #| '"termsOfService"'          %2 gc url
	       | json_xgh_string %1 json_xgh_gc json_xgh_value6
               ;

    meta_fields = meta_field (json_xgh_ws ',' json_xgh_ws meta_field)*;

    resource_field = empty #'"keyChange"'   %2 gc url
                   | '"meta"'        %2 json_xgh_gc '{' json_xgh_ws meta_fields json_xgh_ws '}'
                   | '"newAccount"'  %2 json_xgh_gc url >buf_zero >buf_account
                   | '"newNonce"'    %2 json_xgh_gc url >buf_zero >buf_nnonce
                   #| '"newOrder"'    %2 gc url
                   #| '"renewalInfo"' %2 gc url
                   #| '"revokeCert"'  %2 gc url
                   | '"newAuthz"' @die
                   | json_xgh_string %1 json_xgh_gc json_xgh_value6
                   ;

    resource_fields = resource_field (json_xgh_ws ',' json_xgh_ws resource_field)*;

    main2 = json_xgh_ws '{' json_xgh_ws resource_fields json_xgh_ws '}' json_xgh_ws;
    main := main2 $!die;

    #main := (ws '{' ws field (ws ',' ws field)* ws '}' ws); #$!die;

    #profile_field = string gc string;

    #profile = '{' ws profile_field (ws ',' ws profile_field)* ws '}';

    write data noerror nofinal noentry; 
}%%

%%{
    machine acme_xgh_resource_account;
    alphtype unsigned char;

    variable cs acme_xgh_resource_cs;

    main := "TODO";

    write data noerror nofinal noentry;
}%%

#if 0
acme_xgh_resource_eof = acme_xgh_resource_##ID##_eof; \
acme_xgh_resource_recv = acme_xgh_resource_##ID##_recv;
#endif

#define UNICODE_XGH_EFFECT(...)
#define JSON_XGH_DEBUG(...)
#define JSON_XGH_STACK acme_xgh_resource_stack
#define JSON_XGH_DEPTH_MAX 30
#define JSON_XGH_DIE(C) return C

define(`X',`dnl

%% machine acme_xgh_resource_$1;

void acme_xgh_resource_$1_init(void)
{
    %% write init;
}

bool acme_xgh_resource_$1_eof(void)
{
    return acme_xgh_resource_cs >= %%{ write first_final; }%%;
}

enum acme_xgh_error acme_xgh_resource_$1_recv(unsigned char *p, unsigned char *pe, unsigned char *eof) {
    %% write exec;

    return ACME_XGH_ERROR_NONE;
}
')dnl
X(`directory')
X(`account')`'dnl
undefine(`X')dnl

#undef UNICODE_XGH_EFFECT

void acme_xgh_resource_null_init(void)
{
    // Do nothing.
}

bool _Noreturn acme_xgh_resource_null_eof(void)
{
    assert(!"Fuck you bitch");
    abort();
}

enum acme_xgh_error acme_xgh_resource_null_recv(unsigned char *p, unsigned char *pe, unsigned char *eof)
{
    (void)p;
    (void)pe;
    (void)eof;
    assert(!"I'll tear you apart");
    abort();
}

// Thanks Simon Tatham.
// 'https://www.chiark.greenend.org.uk/~sgtatham/coroutines.html

#define ACME_XGH_CHANNEL_CR_BEGIN switch(state) { case 0:
#define ACME_XGH_CHANNEL_CR_FINISH } (void)0
#define ACME_XGH_CHANNEL_CR_SAVE_SEND do { s_send=__LINE__; case __LINE__:; } while (0)
#define ACME_XGH_CHANNEL_CR_YIELD_SEND do { s_send=__LINE__; return; case __LINE__:; } while (0)

static unsigned char *acme_xgh_channel_send_current = NULL;
static size_t acme_xgh_channel_send_current_remnant;
static bool (*acme_xgh_resource_eof)(void);
static enum acme_xgh_error (*acme_xgh_resource_recv)(unsigned char *p, unsigned char *pe, unsigned char *eof);

#define ACME_XGH_CHANNEL_LITERAL_BASE(...) \
  static unsigned char fwded[] = __VA_ARGS__; \
  current = fwded; \
  remnant = sizeof fwded - 1; \

#define ACME_XGH_CHANNEL_LITERAL_SAVE(...) do { \
  assert(ev != ACME_SUM); \
  ACME_XGH_CHANNEL_LITERAL_BASE(__VA_ARGS__) \
  ACME_XGH_CHANNEL_CR_SAVE_SEND; \
  assert(!acme_xgh_channel_send_current_remnant); \
} while (0)

#define ACME_XGH_CHANNEL_LITERAL_YIELD(...) if (ACME_SEND == ev) { \
  ACME_XGH_CHANNEL_LITERAL_BASE(__VA_ARGS__) \
  ACME_XGH_CHANNEL_CR_SAVE_SEND; \
  assert(!acme_xgh_channel_send_current_remnant); \
} else if (ACME_XGH_CHANNEL_EVENT_SUM == ev && is_counting) { \
  length_numbah += sizeof (__VA_ARGS__); \
} else (void)0

#define ACME_XGH_CHANNEL_STRING_YIELD(...) if (ACME_SEND == ev) { \
  current = (__VA_ARGS__); \
  remnant = strlen(current); \
  crYieldSend; \
  assert(!remnant); \
} else if (ACME_XGH_CHANNEL_EVENT_SUM == ev && is_counting) { \
  length_numbah += strlen(__VA_ARGS__); \
} else (void)0

#define ACME_XGH_CHANNEL_PARSE(ID) do { \
  acme_xgh_resource_##ID##_init(); \
  acme_xgh_resource_eof = acme_xgh_resource_##ID##_eof; \
  acme_xgh_resource_recv = acme_xgh_resource_##ID##_recv; \
  s_recv=__LINE__; return; case __LINE__:; \
} while (0)

#define LENGTH_NOW \
do { s_sum = __LINE__; acme(ACME_XGH_CHANNEL_EVENT_SUM); case __LINE__:; } while (0)

#define SSUM // TODO
#define ESUM if (ACME_XGH_CHANNEL_EVENT_SUM == ev) { return; } else (void)0

#define ACME_CHANNEL_EVENT_XS(X) \
X(INIT , s_recv = s_send = state = 0) \
X(RECV , state = s_recv) \
X(SEND , state = s_send) \
X(SUM  , state = s_sum ) \
X(RETRY, /* TODO */ state = s_sum = s_sum_retry)

#define ACME_XGH_CHANNEL_EVENT_AS_ENUM(B, C) \
    ACME_XGH_CHANNEL_EVENT_##B,
#define ACME_XGH_CHANNEL_EVENT_AS_RESUME(B, C) \
    case ACME_XGH_CHANNEL_EVENT_##B: C; break;

enum acme_xgh_channel_event
{
    ACME_CHANNEL_EVENT_XS(ACME_XGH_CHANNEL_EVENT_AS_ENUM)
};

//ACME_CHANNEL_EVENT_XS(AS_DECO)

static void acme(enum acme_xgh_channel_event ev)
{
    unsigned char length[20];
    static int length_numbah;
    bool is_counting;

    // Not worth X macros.
    static int s_recv, s_send, s_sum;
    int state;

    switch (ev)
    {
        ACME_CHANNEL_EVENT_XS(ACME_XGH_CHANNEL_EVENT_AS_RESUME)
        default: assert(!"fuck"); abort(); break;
    }

    ACME_XGH_CHANNEL_CR_BEGIN;

    // Crypto startup.

    LITS(
        "GET /dir HTTP/1.1\r\n"
        ACME_SOME_FIELDS
        "Connection: keep-alive\r\n"
        "\r\n"
    );

    ACME_XGH_CHANNEL_PARSE(directory);

    if (acme_xgh_replay_nonce)
        printf("Already has nonce: %s\n", acme_xgh_replay_nonce);
    else
    {
        LITS("HEAD /");
        if (ACME_RECV == ev)
        {
            STR(nnonce_dir);
            LITY(
                " HTTP/1.1\r\n"
                ACME_SOME_FIELDS
                "Connection: keep-alive\r\n"
                "\r\n"
            );
        }

        ACME_XGH_CHANNEL_PARSE(null);

        printf("Got nonce: %s\n", acme_xgh_replay_nonce);
    }

    LITS("GET /");
    STR(account_dir);
    LIT(
        " HTTP/1.1\r\n"
        ACME_SOME_FIELDS
        "Connection: keep-live\r\n"
        "Content-Length: "
    );
    LENGTH_NOW;
    LIT("\r\n\r\n");
    SLIT(
        "{\"termsOfServiceAgreed\":true,\"contact\":\"" ACME_CONTACT "\"}"
    );
    ESUM;

    ACME_XGH_CHANNEL_PARSE(account);

    ACME_XGH_CHANNEL_CR_FINISH;
}

static unsigned char * acme_send_buf(size_t *len)
{
    if (!remnant)
        acme_send();

    if (current)
        *len = remnant;

    return remnant ? current : NULL;
}

static void acme_send_ack(size_t len)
{
    assert(len <= remnant);
    remnant -= len;
    current += len;
}

enum http_xgh_error
{
    #define HTTP_XGH_X(ID) HTTP_XGH_ERROR_##ID
    HTTP_XGH_ERROR_XS,
    HTTP_XGH_ERROR_USER_DEFINED,
    #undef HTTP_XGH_X
};

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

static int http_xgh_body_length;
static int http_xgh_body_length_i;

static unsigned char *http_xgh_body_start;
static unsigned char *http_xgh_body_end;

static inline bool http_xgh_body_is_buffering(void)
{
    assert(!http_xgh_body_start == !http_xgh_body_end);
    return http_xgh_body_start;
}

#define HTTP_XGH_CLIENT_BODY_BUFFER(EOF) do { \
    enum acme_xgh_error e = \
    acme_xgh_http_body_recv( \
        http_xgh_body_start, \
        http_xgh_body_end, \
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
} acme_xgh_http_encoding;
#endif

static int http_xgh_client_tmp_num;

static int acme_xgh_replay_nonce_length;

static bool http_xgh_client_is_head;

static int acme_xgh_http_client_num = 0
static int acme_xgh_http_client_num = 0

%%{
    machine acme_xgh_http_client;
    alphtype unsigned char;

    variable cs acme_xgh_http_client_cs;

    `include' http_xgh_base "http_xgh.rl";

    action acme_xgh_http_client_init
    {
        acme_xgh_http_client_body_length = HTTP_XGH_BODY_LENGTH_UNTIL_CLOSE;
#if 0
        acme_xgh_http_client_encoding = ACME_XGH_HTTP_ENCODING_IDENTITY;
#endif
    }

M4_HTTP_XGH_ERROR_XS(`ifelse($3,,,`    action http_xgh_error_$1 { return HTTP_XGH_ERROR_`'translit($1,m4_xgh_lower,m4_xgh_upper); }
')')`'dnl

    action http_xgh_body_start
    {
        acme_xgh_http_client_body_init();
          http_xgh_client_body_start;
        = http_xgh_client_body_end
        = fpc;
        http_xgh_body_length_i = 0;
    }
    action http_xgh_body_advance
    {
        http_xgh_client_body_end++;
    }
    action http_xgh_body_end
    {
        HTTP_XGH_CLIENT_BODY_IS_BUFFERING(http_xgh_client_body_end);
        acme_xgh_http_client_body_start = NULL;
        acme_xgh_http_client_body_end = NULL;
    }

    action acme_xgh_http_client_is_body_not_exhausted
    {
        !http_xgh_client_is_head && (
            ACME_XGH_HTTP_BODY_LENGTH_UNTIL_CLOSE
            == acme_xgh_http_body_length
            || acme_xgh_http_body_length_i++
             < acme_xgh_http_body_length
        )
    }

    # TODO body_length and _i ought be only one number which is
    # decremented until zero

    action http_xgh_set_body_length_0
    {
        http_xgh_body_length = 0;
    }
    action http_xgh_num_zero
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
                     digit+ >http_xgh_num_zero $http_xgh_concat_digit %http_xgh_body_length_copy
                     (OWS ',' OWS digit+ >http_xgh_num_zero $http_xgh_concat_digit %http_xgh_body_length_assert)*
                     OWS;
    transfer_encoding = "Transfer-Encoding:"i @(pri_http_field,1) @http_xgh_error_skill_issue OWS field_value OWS;
    content_encoding = "Content-Encoding:"i @(pri_http_field,1) @http_xgh_error_skill_issue OWS field_value OWS;

    base64url = alnum | '-' | '_';

    replay_nonce_value = base64url+; #> $ @ $!some_error
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
                             ) %http_xgh_set_body_length_0;
    # https://www.rfc-editor.org/rfc/rfc9112.html#section-6.3-2.1

    known_status_code = empty_body_status_code | "200";

    status_code = known_status_code | digit{3};
    reason_phrase = ( HTAB | SP | VCHAR | obs_text ){1,};

    status_line = HTTP_version SP status_code >http_xgh_num_zero $http_xgh_concat_digit %http_xgh_client_as_status SP (reason_phrase)?;

    message_body = any*
                   >http_xgh_body_start
                   $http_xgh_body_advance
                   %http_xgh_body_end
                   when acme_xgh_http_client_is_body_not_exhausted;

    HTTP_message = CRLF* # https://datatracker.ietf.org/doc/html/rfc9112#section-2.2-6
                   status_line CRLF
                   (field_line CRLF)*
                   CRLF
                   message_body
                   ;

    main := HTTP_message** >acme_xgh_http_client_init $!http_xgh_error_some;

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

#endif // ACME_XGH_IMPLEMENTATION

// vim: syntax=ragel
