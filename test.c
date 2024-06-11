#include <assert.h>

#include "code.h"

// TODO how do we test OOM?
// test adjacent errors

#define TEST_MOVIE_PARSE_XS(X) \
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
X(CODE_ERROR_NO_TITLE   , ".PP"                 ) \
X(CODE_ERROR_NO_TITLE   , ".PP   \t\f\v\r\n\r\n") \
X(CODE_ERROR_NO_TITLE   , ".PP\n"               ) \
X(CODE_ERROR_INVALID_CMD, ".PP\a"               ) \
X(CODE_ERROR_INVALID_CMD, ".PP\""               ) \
X(CODE_ERROR_TRAILING   , ".PP    a"            ) \
\

#define TEST_HOST "Host: XXX\r\n\r\n"
// Maybe we could use some evil Boost::Preprocessor to generate test cases LOL

#define TEST_HTTP_PARSE_XS(X) \
X(CODE_NO_UPGRADE      , "PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n") \
X(CODE_OKAY            , "GET /movies HTTP/1.1\r\n"       TEST_HOST) \
X(CODE_OKAY            , "GET /movies.html HTTP/1.1\r\n"  TEST_HOST) \
X(CODE_OKAY            , "GET /movies/ HTTP/1.1\r\n"      TEST_HOST) \
X(CODE_OKAY            , "HEAD /movies HTTP/1.1\r\n"      TEST_HOST) \
X(CODE_OKAY            , "HEAD /movies.html HTTP/1.1\r\n" TEST_HOST) \
X(CODE_OKAY            , "HEAD /movies/ HTTP/1.1\r\n"     TEST_HOST) \
X(CODE_NOT_FOUND       , "GET / HTTP/1.1\r\n" TEST_HOST) \
X(CODE_NOT_IMPLEMENTED , "OPTIONS * HTTP/1.1\r\n" TEST_HOST) \
X(CODE_NOT_IMPLEMENTED , "OPTIONS /movies.html HTTP/1.1\r\n" TEST_HOST) \
X(CODE_NOT_IMPLEMENTED , "POST /fakeform/ HTTP/1.1\r\n" TEST_HOST) \
X(CODE_NOT_IMPLEMENTED , "PUT  /fakeform/ HTTP/1.1\r\n" TEST_HOST) \
X(CODE_NOT_IMPLEMENTED , "DELETE  /movies.html HTTP/1.1\r\n" TEST_HOST) \
X(CODE_NOT_IMPLEMENTED , "TRACE  /movies.html HTTP/1.1\r\n" TEST_HOST) \

#if 0
".HEADING"
".HEADING   "
".HEADING   -7"
".HEADING 0"
".HEADING 1"
".HEADING 6"
".HEADING 7"
".HEADING 7"
".HEADING 19"
".HEADING 69"
".HEADING 0x4"
".HEADING 1    "
".HEADING 1 \""
".HEADING 1 \"\""
".HEADING 1 \"Movies\""
".HEADING 1 \"Movies\""
".HEADING 1 \"Movies\" \""
".HEADING \"Movies\""
#endif
