#include <limits.h>
#include <stddef.h>
#include <stdio.h>

enum body_length
{
    BODY_LENGTH_UNTIL_CLOSE = -1,
    BODY_LENGTH_TOO_BIG = -2,
#if 0
    BODY_LENGTH_TRANSFER_ENCODING = -3,
#endif
};

struct http_response_parser
{
    int cs;
    int len;
    int status;
    int body_length;
    int body_length_i;
#if 0
    unsigned char *body_start;
    unsigned char *body_end;
#endif
#if 0
    enum encoding { ENCODING_IDENTITY, ENCODING_NOT_IDENTITY } encoding;
#endif
    union
    {
        int num;
    };
};

%%{
    machine http_client;
    alphtype unsigned char;
    access hpp->;

    include http_base "http_base.rl";

    action init
    {
        hpp->body_length = BODY_LENGTH_UNTIL_CLOSE;
#if 0
        hpp->encoding = ENCODING_IDENTITY;
#endif
    }
    action unrecoverable_error { return HTTP_ERROR_UNRECOVERABLE; }
    action some_error { return HTTP_CLIENT_ERROR_SOME; }
    action dump { putchar(fc); } # TODO save range to process in batch
    action body_exhausted
    {
        BODY_LENGTH_UNTIL_CLOSE == hpp->body_length
        || hpp->body_length_i++ < hpp->body_length
    }
    action set_non_identity
    {
#if 0
        hpp->encoding = ENCODING_NOT_IDENTITY;
#else
        return HTTP_CLIENT_SKILL_ISSUE;
#endif
    }
    action set_body_length_0 { hpp->body_length = 0; }
    action do_zero { hpp->num = 0; }
    action do_dig
    {
        if (hpp->num > (INT_MAX-fc)/10)
            return HTTP_CLIENT_SKILL_ISSUE;
        else
            hpp->num = hpp->num * 10 + fc;
    }
    action as_status { hpp->status = hpp->num; }
    action body_length_0 { hpp->body_length = 0; }
    action body_length_numbah { hpp->body_length = hpp->num; }
    action assert_body_length
    {
        if (hpp->body_length != hpp->num)
            return HTTP_CLIENT_REJECT;
    }
    action skill_issue { return HTTP_CLIENT_SKILL_ISSUE; }

    content_length = "Content-Length:"i @(goat,1) OWS
                     digit+ >do_zero $do_dig %body_length_numbah
                     (OWS ',' OWS digit+ >do_zero $do_dig %assert_body_length)*
                     OWS;
    transfer_encoding = "Transfer-Encoding:"i @(goat,1) @skill_issue OWS field_value OWS;
    content_encoding = "Content-Encoding:"i @(goat,1) @set_non_identity OWS field_value OWS;

    known_field = content_encoding | content_length | transfer_encoding;

    field_line = (known_field | any_field);

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
                     any* when body_exhausted $dump
                   ) >init;

    main := HTTP_message** $!some_error;

    write data noerror nofinal noentry;
}%%

void http_client_init(struct http_response_parser *hpp)
{
    %% write init;
}

enum http_client_error
{
    HTTP_CLIENT_ERROR_NONE,
    HTTP_CLIENT_ERROR_SOME,
    HTTP_CLIENT_ERROR_UNRECOVERABLE,
    HTTP_CLIENT_SKILL_ISSUE,
    HTTP_CLIENT_REJECT,
} http_client(struct http_response_parser *hpp, unsigned char *p, size_t len)
{
    unsigned char *pe = p + len, *eof = NULL;
    %% write exec;
    return HTTP_CLIENT_ERROR_NONE;
}
