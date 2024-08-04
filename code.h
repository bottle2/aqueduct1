#ifndef CODE_XS
#define CODE_XS(X) \
X(CODE_OKAY                 , ""                     ) \
X(CODE_ERROR_BUILDER_REALLOC, "error builder realloc") \
X(CODE_ERROR_NO_TITLE       , "error no title"       ) \
X(CODE_ERROR_TITLE_REDEF    , "error title twice"    ) \
X(CODE_ERROR_REPEATED_PP    , "error repeated pp"    ) \
X(CODE_ERROR_HANGING_TEXT   , "error hanging text"   ) \
X(CODE_ERROR_MOVIE_UNDEFINED, "error movie undefined") \
X(CODE_ERRO_TITLE_HEAD      , "erro title head"      ) \
X(CODE_ERRO_LEVEL           , "erro level"           ) \
X(CODE_ERRO_TITLE           , "erro title"           ) \
X(CODE_ERROR_NO_SYMBOL_MOVIE, "error no symbol movie") \
X(CODE_ERROR_NO_TAG_MOVIE   , "error no tag movie"   ) \
X(CODE_ERROR_NO_AUT_MOVIE   , "error no authority movie") \
X(CODE_ERROR_NO_YEAR        , "error no year"        ) \
X(CODE_ERROR_NO_MOVIE_NAME  , "error no movie_name"  ) \
X(CODE_ERROR_MOVIE_ALREADY_DEFINED, "error movie already defined") \
X(CODE_ENOMEM               , "error enomem"         ) \
X(CODE_ERROR_NO_QUOTED      , "error incomplete quot") \
X(CODE_EMPTY_STRING         , "string is empty"      ) \
X(CODE_OLD                  , "tried to add old file") \
X(CODE_ERROR_TRAILING       , "error trailing"       ) \
X(CODE_ERROR_INVALID_CMD    , "error unknown cmd"    ) \
\
X(CODE_NO_UPGRADE     , "bro I don't even have TLS"   ) \
X(CODE_BAD_REQUEST    , "bro..."                      ) \
X(CODE_NOT_IMPLEMENTED, "I don't know how to proceed.") \
X(CODE_NOT_FOUND      , "no such page (yet?)"         ) \
\
X(CODE_ERROR_REPEATED_MENTION      , "error mention twice"         ) \
X(CODE_ERROR_REPEATED_ARCHIVE      , "error archive twice"         ) \
X(CODE_ERROR_NO_FOOTNOTE_TO_CLOSE  , "error no footnote to close"  ) \
X(CODE_ERROR_UNEXPECTED_IN_FOOTNOTE, "error unexpected in footnote")

#include "expand.h"

enum code { CODE_XS(AS_COMMA_FIRST) };

char const * code_msg(enum code code);

#endif
