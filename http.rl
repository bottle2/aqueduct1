%%{
# some thoughts... I think we don't have to be lenient...
# e.g. if we don't expect a query in URL, just answer 40X
#      if we don't expect a body (Content-Length or Transfer-Encoding, just answer 40X
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

    OWS = (space -- '\n')*;
    CRLF = "\r\n"; # MAY be a bare a \n, but MUST NOT a bare \r
                   # if bare \r received, consider invalid or replace with SP
                   # Let's just error ffs
    SP = ' ';

    absolute_path = '/' | # TODO

    origin_form    = absolute_path ('?' query)?;
    absolute_form  = # hurrrrrrrrrr MUST ignore Host: 
    authority_form = # ignored, we ain't proxy
    asterisk_form  = # ignored, I don't know OPTIONS
# I don't really understand the whole URI ordeal! :(

    # what do with fragment???

    action error_not_implemented { } # answer 501 

    method         = ("GET" | "HEAD") !$error_not_implemented; # TODO PRI * from http2
    request_target = origin_form | absolute_form | authority_form | asterisk_form;
    HTTP_version   = "HTTP/1.1";

    action error_invalid_request_line { } # SHOULD reject with 400 or redirect with 301

    # could accept other whitespace but WHY would client do it?? at all. so NO.
    request_line = (presumed_HTTP2 | (method SP request_target SP HTTP_version)) !$error_invalid_request_line;

# prohibit userinfo subcomponent and its '@' delimiter.
# answer with 400 when no Host: header field or two or more or "invalid" value.

    action error_no_body_wanted { } # We don't expect body, so we answer 400.

    field_line = ("content-length"i | "transfer-encoding"i) ":" %error_no_body_wanted
               | field_name ":" OWS field_value OWS;
    # MUST reject with 400 when space between field_name and colon :
    # greedy parse, exclude trailing and ending white
    # prohibit obs-fold

    # wow closing is very fatal... misbehaving client...

    # we MAY send response before closing

    # do not answer unless empty line
    # no content-length neither chunked transfer, then complete upon closure, unless TLS incomplete close!!

    # Let's default to no keep-alive, that is CLOSE, because we'd need to parse Connect: until
    # We will suffer with DoS...

    # first shutdown, then wait for graceful close

    action error_bad_request { } # SHOULD answer 400 and close connection.

    action error_no_upgrade { } # also https://datatracker.ietf.org/doc/html/rfc9113#appendix-B-2.3
    HTTP2_preface = "PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n" %error_no_upgrade; # https://datatracker.ietf.org/doc/html/rfc9113#section-3.4-4

    # https://datatracker.ietf.org/doc/html/rfc9112#section-2.1-2
    HTTP_message = (CRLF* # https://datatracker.ietf.org/doc/html/rfc9112#section-2.2-6
                   request_line CRLF
                   (field_line CRLF)*
                   CRLF
                   ) $!error_bad_request | HTTP2_preface; # We never expect a message-body.


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

void http_del(struct http *http)
{
    *http = http_init(); // hehe B)
}

enum code http_parse(struct http *http, unsigned char *buffer, int len)
{
    %%{
    }%%
}
