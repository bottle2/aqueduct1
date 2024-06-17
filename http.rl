#include <libuv.h>

%%{
# some thoughts... I think we don't have to be lenient...
# e.g. if we don't expect a body (Content-Length or Transfer-Encoding, just answer 40X
# in a way, we are being useful to client? since we error against user assumptions...
# why would you do things that have no effect? prohibit ban ban
# https://en.wikipedia.org/wiki/Robustness_principle hmmmmmmmmmmm

# TODO document why are we not using llhttp or picohttpparser or BEAST
# TODO merge definitions from movie parser
# TODO reference paragraphs of RFCs
# TODO test correctness/compliance/conformance, copy from nginx or apache or something
# TODO torture tests, fuzzers, benchmarking etc.
# let's keep an eye at whatever is Barracuda
    machine http;
    alphtype unsigned char;

    action shutdown { uv_shutdown(http->handle, &http->tcp, NULL); }

    CRLF = "\r\n"; # MAY be a bare a \n, but MUST NOT a bare \r
                   # if bare \r received, consider invalid or replace with SP
                   # Let's just error ffs
    SP = ' ';
    HTAB = '\t';
    OWS = (SP | HTAB)*;
    RWS = (SP | HTAB)+;

    action error_not_implemented { } # answer 501 

    scheme = "http"i;

    action host_loopback  { if (HTTP_HOST_NONE == parser->host) parser->host = HTTP_HOST_LOOPBACK;  }
    action host_localhost { if (HTTP_HOST_NONE == parser->host) parser->host = HTTP_HOST_LOCALHOST; }
    action host_public    { if (HTTP_HOST_NONE == parser->host) parser->host = HTTP_HOST_PUBLIC;    }
    action host_is_absolute { parser->is_absolute = true; }

    host = "127.0.0.1"        %host_loopback
         | "localhost"i       %host_localhost
         | "191.252.220.165"  %host_public;

    port = (":" "80"?)?;

    authority = scheme ':' host port;

    _m   = 'm' | "%6D"i;
    _n   = 'n' | "%6E"i;
    _o   = 'o' | "%6F"i;
    _v   = 'v' | "%76";
    _i   = 'i' | "%69";
    _e   = 'e' | "%65";
    _s   = 's' | "%73";
    _dot = '.' | "%2E"i;
    _h   = 'h' | "%68";
    _t   = 't' | "%74";
    _l   = 'l' | "%6C"i;
    _d   = 'd' | "%64";
    _x   = 'x' | "%78";

    _html = _dot _h _t _m _l;
    _index = _i _n _d _e _x _html;

    # index.html is common, but no RFC specifies it.
    # we will normalize /../ when a hierarchy exists, using fgoto probably
    pages = _m _o _v _i _e _s (_html | ('/' "./"* _index?))?;
    path = '/' "./"* pages;

    # Comprises both origin-form and absolute-form, we don't use authority and asterisk form.
    request_target = (authority %host_is_absolute)? path;

    HTTP_version = "HTTP/1.1";

    action method_get  { parser->method = HTTP_METHOD_GET;  }
    action method_head { parser->method = HTTP_METHOD_HEAD; }

    method = ("GET" %method_get | "HEAD" %method_head) $!error_not_implemented;

    # could accept other whitespace but WHY would client do it?? at all. so NO.
    request_line = method SP request_target SP HTTP_version;

# answer with 400 when no Host: header field or two or more or "invalid" value.

    action error_no_body_wanted { } # We don't expect body, so we answer 400.

    tchar = [!#$%&'*+-.^_`|~] | digit | alpha;
    token = tchar+;
    # See https://www.rfc-editor.org/rfc/rfc9110#section-5.6.2-2

    VCHAR = graph;

    field_name = token; # See https://www.rfc-editor.org/rfc/rfc9110#section-5.1-2
    obs_text = 0x80..0xFF;
    field_vchar = VCHAR | obs_text;
    field_content = field_vchar ((SP | HTAB | field_vchar)+)?;
    field_value = field_content*; # See https://www.rfc-editor.org/rfc/rfc9110#section-5.5-2

    action host_check {
        if (!parser->is_absolute && parser->host != HTTP_HOST_NONE)
        {
            fhold; fbreak;
            answer(BAD_REQUEST 400);
            uv_close(lala);
        }
    } 

    host_field = 'host:'i OWS host;
    any_field = field_name ":" OWS field_value;

    field_line = (host_field # TODO check absolute URI on request_line, duplicate host etc. 
               | any_field) OWS; #("content-length"i | "transfer-encoding"i)
    # MUST reject with 400 when space between field_name and colon :
    # greedy parse, exclude trailing and ending white
    # prohibit obs-fold
    # We should parse content-length and transfer-encoding... but is very
    # complex and we close immediately upon receiving request-line. we will
    # properly parse when we implement keep-alive.

    # wow closing is very fatal... misbehaving client...

    # we MAY send response before closing

    # do not answer unless empty line
    # no content-length neither chunked transfer, then complete upon closure, unless TLS incomplete close!!

    # Let's default to no keep-alive, that is CLOSE, because we'd need to parse Connect: until
    # We will suffer with DoS...?

    # first shutdown, then wait for graceful close

    action error_bad_request { } # SHOULD answer 400 and close connection. or 301 if line-request error, but idc
    action error_no_upgrade { } # also https://datatracker.ietf.org/doc/html/rfc9113#appendix-B-2.3

    HTTP2_preface = "PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n" %error_no_upgrade; # https://datatracker.ietf.org/doc/html/rfc9113#section-3.4-4

    # https://datatracker.ietf.org/doc/html/rfc9112#section-2.1-2
    HTTP_message = CRLF* # https://datatracker.ietf.org/doc/html/rfc9112#section-2.2-6
                   request_line CRLF
                   (field_line CRLF)*
                   CRLF; # We never expect a message-body.

    main := (HTTP2_preface | HTTP_message) $!error_bad_request any*;
    #action close    { uv_close(&http->handle2

    # NOTES FOR FUTURE (not relevant for now):
    # reject when both Content-Length: and Transfer-Encoding!!
    # reject when Transfer-Encoding defined for HTTP/1.0!!
    # chunked transfer encoding in request must be final! simple!! otherwise 400 bad request and close
    # Content-Length: 40,40,40 is valid (????) okay.
    # ignore when less
    # Request message ends without body if no length or chunked
    # we may reject when no Content-Length
    # chunked implies possibility of trailer section
    # beware overflow
    # we will need the semantic conditions of Ragel it seems
    # MUST ignore unrecognized chunk extensions
    # compression: compress (x-compress), deflate and gzip (x-gzip) https://www.iana.org/assignments/http-parameters/http-parameters.xhtml
    # efficient XML is very cool! also brotli
    # treat parameters for compression as errors

    # why do we need to parse everything, header section or body, before closing??
    # probably because of trailing headers?
}%%

%% write data noerror nofinal noentry;

struct http http_init(void)
{
    struct parser it = {0};
    struct parser *http = &it;
    %% write init;
    return it;
}

void http_parse(struct http *http, unsigned char *buffer, int len)
{
    unsigned char *p = buffer;
    unsigned char *pe = ???

    %% access http->;
    %% write exec;
}
