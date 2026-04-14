#ifndef ACME_XGH
#define ACME_XGH

#include <stddef.h>

// Only source-compatibility supported for now. Enum may change order.
// No test harness to detect enum changes.

// TODO Inside this ACME library, there is a HTTP client library that
//      wants to get out. Most likely prefixed `http_xgh_*`

// TODO I completely forgot about when the TLS tunnel breaks and needs
//      new reconnection.

// HTTP 1.1 only for now, nothing fancy.
// This library is currently singleton (lots of global variables).
// This library has several fixed-size internal buffers, so no dynamic
// memory allocation: it will crash (yeah, crash) the entire process
// if a limit is reached.

// TODO Differentiate "okay" from "finished"

// TODO It's already X macros, make it m4 to generate Ragel actions

#define HTTP_XGH_ERROR_XS \
HTTP_XGH_X(NONE         ), \
HTTP_XGH_X(SKILL_ISSUE  ), \
HTTP_XGH_X(SOME         ), \
HTTP_XGH_X(UNRECOVERABLE), \
HTTP_XGH_X(REJECT       )

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

// Call `acme_xgh_recv(NULL, 0)` when EOF reached.

#endif
