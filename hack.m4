divert(-1)

define(`FIL',`dnl
static char hack__$1[] = { syscmd(./marshal $2) };
#define RESPONSE__$1 \
 RESPONSE_GEN(syscmd(printf "%d" $`'(wc -c < $2)))
uv_buf_t response_$1[2] = {
 {.base = RESPONSE__$1, .len = sizeof (RESPONSE__$1)-1},
 {.base = hack__$1, .len = sizeof (hack__$1)}
};')

divert(0)dnl
#include <uv.h>

#define RESPONSE_GEN(LEN) \
  "HTTP/1.1 200 OK\r\n" \
  "Connection: close\r\n" \
  "Content-Type: text/html\r\n" \
  "Content-Length: " #LEN "\r\n" \
  "\r\n"

FIL(hash,hash.html)
