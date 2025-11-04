#include <assert.h>
#include <uv.h>

#include "doc.h"
#include "http.h"

// CURRENT STATE OF IMPLEMENTATION
// - We do not have persistent connections, i.e. not keep-alive.
//   - Thus, we currently ignore Content-Length and Transfer-Encoding
//     - This means our implementation DOES NOT comply with bare minimum HTTP 1.1
// - We do not have graceful HTTP close
// - We recognize and answer methods GET and HEAD
// - We recognize and deny presumed HTTP2

void on_close(uv_handle_t *handle); // HACK HACK HACK HACK HACK HACK HACK

#include "response.c"

#define RESPONSE_MAIN \
  "HTTP/1.1 200 OK\r\n" \
  "Connection: close\r\n" \
  "Content-Type: text/html\r\n" \
  "Content-Length: 714\r\n" \
  "\r\n" RESPONSE_MAIN_MAIN

#define RESPONSE_C \
  "HTTP/1.1 200 OK\r\n" \
  "Connection: close\r\n" \
  "Content-Type: text/html\r\n" \
  "Content-Length: 260\r\n" \
  "\r\n" RESPONSE_MAIN_C

#define RESPONSE_MAIN_MAIN \
  "<!DOCTYPE html>\n" \
  "<html lang=\"en\">\n" \
  "<head>\n" \
  "  <meta charset=\"UTF-8\">\n" \
  "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n" \
  "  <title>Home - aqueduct1</title>\n" \
  "</head>\n" \
  "<body>\n" \
  "  <h1>Home</h1>\n" \
  "  <p>Hi.</p>\n" \
  "  <ul>\n" \
  "    <li><a href=\"./movies\">A list of movies</a></li>\n" \
  "  </ul>\n" \
  "  <p>This website is written in C, Ragel and libuv.</p>\n" \
  "  <p>Future directions:</p>\n" \
  "  <ul>\n" \
  "    <li>A domain name</li>\n" \
  "    <li>TLS</li>\n" \
  "    <li>Brotli compression</li>\n" \
  "    <li>Bookmarks</li>\n" \
  "    <li>List of vehicle building games</li>\n" \
  "    <li>Translation of sacred GH texts</li>\n" \
  "    <li>C stronghold</li>\n" \
  "    <li>Tables</li>\n" \
  "    <li>Unity and C# hacks</li>\n" \
  "    <li>Introduction to C# for C programmers</li>\n" \
  "  </ul>\n" \
  "</body>\n" \
  "</html>\n"

#define RESPONSE_MAIN_C \
  "<!DOCTYPE html>\n" \
  "<html lang=\"en\">\n" \
  "<head>\n" \
  "  <meta charset=\"UTF-8\">\n" \
  "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n" \
  "  <title>C - aqueduct1</title>\n" \
  "</head>\n" \
  "<body>\n" \
  "  <h1>All about C</h1>\n" \
  "  <p>C is da best language ever!</p>\n" \
  "</body>\n" \
  "</html>\n"

#if IS_MAIN
int main(void)
{
    printf("main %zu\n", sizeof (RESPONSE_MAIN_MAIN));
    printf("c %zu\n", sizeof (RESPONSE_MAIN_C));
    return 0;
}
#endif

static uv_buf_t response_main = {.base = RESPONSE_MAIN, .len = sizeof (RESPONSE_MAIN) - 1};
static uv_buf_t response_c = {.base = RESPONSE_C, .len = sizeof (RESPONSE_C) - 1};

static void on_write_doc(uv_write_t *req, int status)
{
    struct write_doc_req *doc_req = (struct write_doc_req *)req;

    if (status < 0)
        fprintf(stderr, "Error writing doc: %s\n", uv_strerror(status));

    assert((void *)req->handle == (void *)doc_req->outer);

    doc_free(doc_req->doc_used);
    uv_close((uv_handle_t *)req->handle, on_close);
}

static void on_write(uv_write_t *req, int status)
{
    if (status < 0)
        fprintf(stderr, "Error writing default: %s\n", uv_strerror(status));
    uv_close((uv_handle_t *)req->handle, on_close);
}

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

    include "response.rl";

    action set_movie { http->routed = ROUTED_MOVIES; }
    action set_c { http->routed = ROUTED_C; }
    action set_hash { http->routed = ROUTED_HASH; }

    action answer
    {
        uv_buf_t *bufs = NULL;
        void (*on_write_cb)(uv_write_t *, int) = on_write;
        int n_buf = 1;

        extern struct doc *latest; // HACK HACK HACK HACK HACK HACK HACK HACK

        if (HTTP_HOST_NONE == http->host || HTTP_HOST_ABSOLUTE == http->host)
            bufs = &response_400;
        if (NULL == latest)
            bufs = &response_503;
        else switch (http->routed)
        {
            case ROUTED_HOME:
                bufs = &response_main;
            break;

            case ROUTED_MOVIES:
                bufs = doc_get(http->write_doc_req.doc_used = latest);
                on_write_cb = on_write_doc;

                switch (http->method)
                {
                    case HTTP_METHOD_GET:  n_buf = 4; break;
                    case HTTP_METHOD_HEAD: n_buf = 3; break;
                    case HTTP_METHOD_NONE: // Fall through.
                    default:
                        assert(!"Should have a known method at this point!");
                    break;
                }
            break;

            case ROUTED_C:
                bufs = &response_c;
            break;

            case ROUTED_HASH:
                extern uv_buf_t response_hash[2];
                bufs = response_hash;

                switch (http->method)
                {
                    case HTTP_METHOD_GET:  n_buf = 2; break;
                    case HTTP_METHOD_HEAD: n_buf = 1; break;
                    case HTTP_METHOD_NONE: // Fall through.
                    default:
                        assert(!"Should have a known method at this point!");
                    break;
                }
            break;

            default: assert(!"Invalid route"); break;
        }

        // XXX how about checking return value??
        uv_write(
            &http->write_doc_req.write,
            (uv_stream_t *)http,
            bufs, n_buf, on_write_cb
        );

        fhold; fbreak;
    }

    CRLF = "\r\n"; # MAY be a bare a \n, but MUST NOT a bare \r
                   # if bare \r received, consider invalid or replace with SP
                   # Let's just error ffs
    SP = ' ';
    HTAB = '\t';
    OWS = (SP | HTAB)*;
    RWS = (SP | HTAB)+;

    scheme = "http"i;

    action host_absolute { assert(HTTP_HOST_NONE == http->host); http->host = HTTP_HOST_ABSOLUTE; }

    host = zlen | "127.0.0.1" | "localhost"i | "191.252.220.165";

    port = (":" "80"?)?;

    authority = scheme ':' host port;

    # index.html is common, but no RFC specifies it.
    # we will not normalize /../ when a hierarchy exists, fuck smartasses
    include "route.rl";

    # Comprises both origin-form and absolute-form, we don't use authority and asterisk form.
    request_target = (authority %host_absolute)? path;

    HTTP_version = "HTTP/1.1";

    action method_get  { assert(HTTP_METHOD_NONE == http->method); http->method = HTTP_METHOD_GET;  }
    action method_head { assert(HTTP_METHOD_NONE == http->method); http->method = HTTP_METHOD_HEAD; }

    method = ("GET" %method_get | "HEAD" %method_head) $!error_not_implemented;

    # could accept other whitespace but WHY would client do it?? at all. so NO.
    request_line = method
                SP request_target $!error_not_found
                SP HTTP_version;

    # answer with 400 when no Host: header field or two or more or "invalid" value.

    tchar = [!#$%&'*+-.^_`|~] | digit | alpha;
    token = tchar+;
    # See https://www.rfc-editor.org/rfc/rfc9110#section-5.6.2-2

    VCHAR = graph;

    field_name = token; # See https://www.rfc-editor.org/rfc/rfc9110#section-5.1-2
    obs_text = 0x80..0xFF;
    field_vchar = VCHAR | obs_text;
    field_content = field_vchar (SP | HTAB | field_vchar)*;
    field_value = field_content*; # See https://www.rfc-editor.org/rfc/rfc9110#section-5.5-2

    action host_field
    {
        if (http->host & HTTP_HOST_FIELD)
        {
            // Go Horse copied from above
            uv_write(&http->write_doc_req.write, (uv_stream_t *)&http->tcp, &response_400, 1, on_write);

            fhold; fbreak;
        }
        http->host |= HTTP_HOST_FIELD;
    }

    action host_is_absolute { (http->host & HTTP_HOST_ABSOLUTE) }

    host_field = 'host:'i %host_field OWS (field_value when host_is_absolute | host);
    any_field = field_name ":" OWS field_value;

    field_line = (host_field | any_field) OWS; #("content-length"i | "transfer-encoding"i)

    # We should parse content-length and transfer-encoding... but is very
    # complex and we close immediately upon receiving request-line. we will
    # properly parse when we implement keep-alive.

    # wow closing is very fatal... misbehaving client...

    # we MAY send response before closing

    # do not answer unless empty line (where is this said in the RFC again?)
    # no content-length neither chunked transfer, then complete upon closure, unless TLS incomplete close!!

    # Let's default to no keep-alive, that is CLOSE, because we'd need to parse Connect: until
    # We will suffer with DoS...?

    # first shutdown, then wait for graceful close

    HTTP2_preface = "PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n" %error_no_upgrade;
    # https://datatracker.ietf.org/doc/html/rfc9113#section-3.4-4

    # https://datatracker.ietf.org/doc/html/rfc9112#section-2.1-2
    HTTP_message = CRLF* # https://datatracker.ietf.org/doc/html/rfc9112#section-2.2-6
                   request_line CRLF
                   (field_line CRLF)*
                   CRLF @answer; # We never expect a message-body.

    main := (HTTP2_preface | HTTP_message) $!error_bad_request any*;

    # NOTES FOR FUTURE (not relevant for now):
    # chunked transfer encoding in request must be final! simple!! otherwise 400 bad request and close
    # ignore when less
    # compression: compress (x-compress), deflate and gzip (x-gzip) https://www.iana.org/assignments/http-parameters/http-parameters.xhtml
    # efficient XML is very cool! also brotli
    # treat parameters for compression as errors

    # why do we need to parse everything, header section or body, before closing??
    # probably because of trailing headers?
}%%

%% write data noerror nofinal noentry;

void http_init(struct http *http)
{
    %% write init;
    http->method = HTTP_METHOD_NONE;
    http->host   = HTTP_HOST_NONE;
    http->routed = ROUTED_HOME;
}

void http_parse(struct http *http, unsigned char *buffer, int len)
{
    unsigned char *p = buffer;
    unsigned char *pe = buffer + len;
    unsigned char *eof = NULL;

    %% access http->;
    %% write exec;
}

// NOTES FOR THE FUTURE
// Regarding Persistent Connections
// - Next request is only after body of previous!
// - Recognize fields Content-Lenght and Transfer-Encoding
//   - Their rules are very complicated, check RFC
//   - Key takeaway: they are exclusive and optional, if both present error 400
//   - Key takeaway: Content-Length: 40, 40, 40 is valid
//   - Key takeaway: possibly additional fields in trailing section, that is
//     after chunked content, that can invalidate request!
//   - Probably interesting to use Ragel's semantic conditions
//   - Beware content-length overflow
//   - MUST Ignore unrecognized chunk extensions
//   - Reject when Transfer-Encoding for HTTP/1.0!!!

// OBSERVATIONS
// - Answering before closing on error is optional. MAY answer.
