#ifndef CODE_XS
#define CODE_XS(X) \
X(CODE_OKAY                 , ""                     ) \
X(CODE_ERROR_BUILDER_REALLOC, "error builder realloc") \
X(CODE_ERROR_NO_TITLE       , "error no title"       ) \
X(CODE_ERROR_REPEATED_PP    , "error repeated pp"    ) \
X(CODE_ERROR_HANGING_TEXT   , "error hanging text"   ) \
X(CODE_ERROR_MOVIE_UNDEFINED, "error movie undefined") \
X(CODE_ERRO_TITLE_HEAD      , "erro title head"      ) \
X(CODE_ERRO_LEVEL           , "erro level"           ) \
X(CODE_ERRO_TITLE           , "erro title"           ) \
X(CODE_ERROR_NO_SYMBOL_MOVIE, "error no symbol movie") \
X(CODE_ERROR_NO_TAG_MOVIE   , "error no tag movie"   ) \
X(CODE_ERROR_NO_YEAR        , "error no year"        ) \
X(CODE_ERROR_NO_MOVIE_NAME  , "error no movie_name"  ) \
X(CODE_ERROR_MOVIE_ALREADY_DEFINED, "error movie already defined")

#include "expand.h"

enum code { CODE_XS(AS_COMMA_FIRST) };

char const * code_msg(enum code code);

#endif
