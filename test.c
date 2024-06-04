#include <assert.h>

#include "code.h"

// TODO how do we test OOM?
// test adjacent errors

#define PARSE_TEST_XS(X) \
X(CODE_ERROR_NO_TITLE   , ""                       ) \
X(CODE_ERROR_NO_QUOTED  , ".TITLE"                 ) \
X(CODE_ERROR_NO_QUOTED  , ".TITLE     "            ) \
X(CODE_ERROR_INVALID_CMD, ".TITLE\""               ) \
X(CODE_ERROR_NO_QUOTED  , ".TITLE \""              ) \
X(CODE_ERROR_NO_QUOTED  , ".TITLE \"\""            ) \
X(CODE_ERROR_NO_QUOTED  , ".TITLE \"Movies"        ) \
X(CODE_OKAY             , ".TITLE \"Movies\""      ) \
X(CODE_OKAY             , ".TITLE \"Movies\"     " ) \
X(CODE_OKAY             , ".TITLE \"Movies\"\t\r\n") \
X(CODE_ERROR_NO_QUOTED  , ".TITLE\n\"Movies\""     ) \
X(CODE_OKAY             , ".TITLE \"Movies\""      ) \
X(CODE_OKAY             , ".TITLE \"Çöœï🙂‍↔ã™®©\"") \
X(CODE_OKAY             , ".TITLE \"\\\\\\\"\""    ) \
X(CODE_ERROR_TRAILING   , ".TITLE \"Movies\"     a") \
\
X(CODE_OKAY             , ".PP"                 ) \
X(CODE_OKAY             , ".PP   \t\f\v\r\n\r\n") \
X(CODE_OKAY             , ".PP\n"               ) \
X(CODE_ERROR_INVALID_CMD, ".PP\a"               ) \
X(CODE_ERROR_INVALID_CMD, ".PP\""               ) \
X(CODE_ERROR_TRAILING   , ".PP    a"            ) \
\

#if 0
#endif
