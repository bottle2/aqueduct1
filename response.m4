divert(-1)

define(`R',`RI($@)`'dnl')

define(`RESPONSE',`define(`RI',`$1($'`@)')`'dnl
R(503,`Service Unavailable',       `',               `document unavailable',     )
R(404,`Not Found',                 `not_found',      `resource does not exist',  )
R(400,`Bad Request',               `bad_request',    `your request is balls',    )
dnl SHOULD answer 400 and close connection. or 301 if line-request error, but idc
R(501,`Not Implemented',           `no_upgrade',     `bro I dont even have TLS', )
R(505,`HTTP Version Not Supported',`not_implemented',`I aint even got keep-alive')
dnl also https://datatracker.ietf.org/doc/html/rfc9113#appendix-B-2.3
')

define(`AS_DEFINE',`

#define RESPONSE_$1 \
  "HTTP/1.1 $1 $2\r\n" \
  "Connection: close\r\n" \
  "Content-Type: text/plain\r\n" \
  "Content-Length: eval(5+len($4))\r\n" \
  "\r\n" \
  "$1 $4\n"')

define(`AS_BUF',`
static uv_buf_t response_$1 = {.base = RESPONSE_$1, .len = sizeof (RESPONSE_$1) - 1};')

define(`AS_ACTION',`ifelse(len($3),0,,`

    action error_$3
    {
        uv_write(&http->write_doc_req.write, (uv_stream_t *)&http->tcp, &response_$1, 1, on_write);
	fhold; fbreak;
    }')')

divert(0)ifelse(gen,`ragel',`dnl
%%{
    machine http;
    substr(RESPONSE(`AS_ACTION'),1)
}%%
',gen,`c',`dnl
substr(RESPONSE(`AS_DEFINE'),2)`'dnl

RESPONSE(`AS_BUF')`'dnl
')
