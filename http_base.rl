%%{
    machine http_base;
    CRLF = "\r\n"; # MAY be a bare a \n, but MUST NOT a bare \r
                   # if bare \r received, consider invalid or replace with SP
                   # Let's just error ffs
    SP = ' ';
    HTAB = '\t';
    OWS = (SP | HTAB)*;
    RWS = (SP | HTAB)+;

    tchar = [!#$%&'*+-.^_`|~] | digit | alpha;
    token = tchar+;
    # See https://www.rfc-editor.org/rfc/rfc9110#section-5.6.2-2

    VCHAR = graph;

    field_name = token; # See https://www.rfc-editor.org/rfc/rfc9110#section-5.1-2
    obs_text = 0x80..0xFF;
    field_vchar = VCHAR | obs_text;
    field_content = field_vchar (SP | HTAB | field_vchar)*;
    field_value = field_content*; # See https://www.rfc-editor.org/rfc/rfc9110#section-5.5-2

    any_field = (field_name ":") @(goat,0) OWS field_value OWS;

    HTTP_version = "HTTP/1.1";
}%%
