#include <assert.h>
#include <stddef.h>

#include "code.h"
#include "expand.h"

#define AS_CASE(C, S) case C: return S; break;

char const * code_msg(enum code code)
{
    switch (code)
    {
        CODE_XS(AS_CASE)
        default: assert(!"Unknown code"); break;
    }

    return NULL;
}
