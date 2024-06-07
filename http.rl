%%{
# TODO document why are we not using llhttp or picohttpparser or BEAST
# TODO merge definitions from movie parser
# TODO reference paragraphs of RFCs
# TODO test, copy from nginx or apache or something
# let's keep an eye at whatever is Barracuda
    machine http;

    OWS = (space -- '\n')*;
    CRLF = "\r\n"; # MAY be a bare a \n, but MUST NOT a bare \r
                   # if bare \r received, consider invalid or replace with SP
    SP = ' ';

    absolute_path = '/' | # TODO

    origin_form    = absolute_path ('?' query)?;
    absolute_form  = # hurrrrrrrrrr MUST ignore Host: 
    authority_form = # ignored, we ain't proxy
    asterisk_form  = # ignored, I don't know OPTIONS
# I don't really understand the whole URI ordeal! :(

    action error_not_implemented { } # answer 501 

    method         = ("GET" | "HEAD") !$error_not_implemented; # TODO PRI * from http2
    request_target = origin_form | absolute_form | authority_form | asterisk_form;
    HTTP_version   = "HTTP/1.1";

    action error_invalid_request_line { } # SHOULD reject with 400 or redirect with 301

    request_line = (method SP request_target SP HTTP_version) !$error_invalid_request_line;

# prohibit userinfo subcomponent and its '@' delimiter.
# answer with 400 when no Host: header field or two or more or "invalid" value.

    field_line = field_name ":" OWS field_value OWS;
    # MUST reject with 400 when space between field_name and colon :
    # greedy parse, exclude trailing and ending white
    # prohibit obs-fold

    message_body = any+; # but we don't expect any, we also don't chunk
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
    # but we will always send uncompressed raw HTML hahahaha

    # why do we need to parse everything, header section or body, before closing??
    # probably because of trailing headers?
    # wow closing is very fatal... misbehaving client...

    # we MAY send response before closing
    # do not answer unless empty line
    # no conent-length neither chunked transfer, then complete upon closure, unless TLS incomplete close!!

    # Let's default to no keep-alive, that is CLOSE, because we'd need to parse Connect: until
    # We will suffer with DoS...

    action error_bad_request { } # SHOULD answer 400 and close connection.

    HTTP_message = CRLF? request_line CRLF (field_line CRLF)* CRLF message_body?;
%%}
