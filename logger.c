#include <assert.h>
#include <time.h>
#include <inttypes.h>
#include <stdint.h>

#include <uv.h>

#include "logger.h"

// Suggestions:
// https://stackoverflow.com/a/36974402
// https://stackoverflow.com/a/37898383
// https://barrgroup.com/blog/how-define-your-own-assert-macro-embedded-systems

static uv_timespec64_t start;
static char timestamp[] = "YYYY-MM-DDTHH:MM:SS-ZZ:00"; // ISO 8601.

void logger_init(void)
{
    int code = uv_clock_gettime(UV_CLOCK_MONOTONIC, &start);
    assert(!code);
    code = strftime(timestamp, sizeof (timestamp), "%FT%TZ", gmtime(time()));
    assert(code > 0);
}

void logger(char *file, int line, enum code, int inner)
{
    uv_timespec64_t current;
    int code = uv_clock_gettime(UV_CLOCK_MONOTONIC, &current);
    assert(!code);

    int64_t diff = (current.tv_sec  - start.tv_sec ) * 1000
                 + (current.tv_nsec - start.tv_nsec) / 1000000;

    (void)fprintf(stderr, "%s %+" PRId64 " ms %s:%d: %d %d\n", timestamp, offset, file, line, code, inner);
}
