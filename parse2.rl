#include <assert.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "code.h"
#include "movie.h"
#include "parse.h"

#ifdef WIN32
#define STRNDUP_IMPL
// XXX piss piss piss piss cock piss piss piss piss piss piss fuck fuck
// why can't MSYS2 declare strndup?????????????????????????????????????
static char *strndup(const char *s, size_t len)
{
    char *copy = malloc(len + 1);
    if (NULL == copy)
        return NULL;
    size_t i = 0;
    for (; i < len && s[i] != '\0'; i++)
        copy[i] = s[i];
    copy[i] = '\0';
    return copy;
}
#endif

%% machine movies;

%% write data noerror nofinal noentry;

struct parser parser_init(void)
{
    struct parser it = {.buf = NULL, .title = NULL};
    struct parser *parser = &it;
    %% write init;
    return it;
}

void parser_del(struct parser *parser)
{
    free(parser->buf);
    *parser = (struct parser){0};
}

static enum code parse_buf(struct parser *parser, int c)
{
    if (0 == parser->cap)
    {
        assert(0    == parser->len);
        assert(NULL == parser->buf);

        if (NULL == (parser->buf = malloc(20)))
            return CODE_ENOMEM;
        else
        {
            parser->cap = 20;
        }
    }
    else if (parser->len == parser->cap - 1)
    {
        char *new = realloc(parser->buf, parser->cap += 20);
        if (new != NULL)
            parser->buf = new;
        else
        {
            free(parser->buf);
            parser->len = 0;
            parser->cap = 0;
            return CODE_ENOMEM;
        }
    }

    assert(parser->len < parser->cap - 1);

    parser->buf[parser->len++] = c;
    parser->buf[parser->len] = '\0';

    return CODE_OKAY;
}

enum code parse(struct parser *parser, unsigned char *p, int len, struct movies *movies)
{
    unsigned char *pe  = 0 == len ? p : p + len;
    unsigned char *eof = 0 == len ? p : NULL;

    enum code code = CODE_OKAY;

    %%{
        alphtype unsigned char;
        access parser->;
        write exec;

        action cntline { parser->nl++; }

        action buf {
            if ((code = parse_buf(parser, fc)) != CODE_OKAY)
                fbreak;
        }

        action buf_white {
            if ((code = parse_buf(parser, ' ')) != CODE_OKAY)
                fbreak;
        }

        action type_text {
            parser->e.type = TEXT;
            if (!(parser->e.text = strndup(parser->buf, parser->len)))
            {
                code = CODE_ENOMEM;
                fhold; fbreak;
            }
        }
        action type_heading   { parser->e.type = HEADING; }
        action type_paragraph { parser->e.type = PP;      }
        action type_movie     { parser->e.type = MOV;     }
        action type_invalid   { parser->e.type = INVALID; puts("achei inválido"); }

        action add {
            assert(0 == parser->len && '\0' == parser->buf[0]);

            struct element *novo = malloc(sizeof (*novo));

            if (NULL == novo)
            {
                code = CODE_ENOMEM;
                if (parser->len > 0)
                    parser->buf[0] = '\0';
                parser->len = 0;
                fhold; fbreak;
            }

            *novo = parser->e;
            memset(&parser->e, 0, sizeof (parser->e));

            *(movies->last) = novo;
            *(movies->last = &novo->next) = NULL;
        }

        action add_title {
            assert(parser->len > 0);
            if (movies->title)
            {
                code = CODE_ERROR_TITLE_REDEF;
                fhold; fbreak;
            }
            if (!(movies->title = strndup(parser->buf, parser->len)))
            {
                code = CODE_ENOMEM;
                fhold; fbreak;
            }
        }

        action zero {
            if (parser->len > 0)
                parser->buf[0] = '\0';
            parser->len = 0;
        }

        RWS = (space - '\n')+;
        OWS = (space - '\n')*;

        action error_no_quoted { code = CODE_ERROR_NO_QUOTED; }
        action ensure_single_title {
            if (parser->title)
            {
                code = CODE_ERROR_TITLE_REDEF;
                fhold;
                fbreak;
            }
        }

        action level { parser->e.heading.level = fc - '0'; }

        action error_trailing { code = CODE_ERROR_TRAILING; }

        quoted = ('"' ('\\\"' @buf | '\\\\' @buf | (any - [\\\"\n]) @buf)+ '"') @!error_no_quoted;

        comment = "\\\"" @!type_invalid [^\n]*;

        title = "TITLE"          $!type_invalid
                (RWS quoted) OWS $!error_trailing %add_title %zero;

        action error_level { code = CODE_ERRO_LEVEL; }

        action heading_text
        {
            if (!(parser->e.heading.text = strndup(parser->buf, parser->len)))
            {
                code = CODE_ENOMEM;
                fhold; fbreak;
            }
        }

        heading = "HEADING"  @type_heading @!type_invalid
                  (RWS [1-6] @level)       $!error_level
                  (RWS quoted) OWS         $!error_trailing %heading_text %zero %add;

        paragraph = "PP" @!type_invalid 
                    OWS  $!error_trailing %type_paragraph %add;

        symbol = ([_A-Z][_A-Z0-9]*) $buf;
        tok = ([^\n]+ -- RWS) @buf;
        rest = tok (RWS tok >buf_white)* OWS;

        action error_no_symbol    { code = CODE_ERROR_NO_SYMBOL_MOVIE; }
        action error_no_authority { code = CODE_ERROR_NO_AUT_MOVIE;    }
        action error_no_year      { code = CODE_ERROR_NO_YEAR;         }
        action error_no_name      { code = CODE_ERROR_NO_MOVIE_NAME;   }
        action movie_retrieve {
            if (NULL == (parser->e.movie = movie_find_or_create(&movies->mov_first, parser->buf, parser->len)))
            {
                code = CODE_ENOMEM;
                fhold; fbreak;
            }
        }

        action movie_aut {
            parser->e.movie->aut *= 10;
            parser->e.movie->aut += fc - '0';
        }

        action movie_year {
            parser->e.movie->year *= 10;
            parser->e.movie->year += fc - '0';
        }
        action movie_name {
            if (!(parser->e.movie->name = strndup(parser->buf, parser->len)))
            {
                code = CODE_ENOMEM;
                fhold; fbreak;
            }
        }
        action movie_ensure_undefined {
            if (parser->e.movie->defined)
            {
                code = CODE_ERROR_MOVIE_ALREADY_DEFINED;
                fhold; fbreak;
            }
        }
        action movie_define { parser->e.movie->defined = true; }
        # this looks similar
        movie = (
            "MOV" %type_movie @!type_invalid
            (RWS symbol) $!error_no_symbol %movie_retrieve %zero OWS
            (
                (
                    RWS "tt" >movie_ensure_undefined
                    [0-9]{7,} $movie_aut
                ) @!error_no_authority
                (RWS [0-9]{4}       $movie_year) @!error_no_year
                (RWS rest)          %movie_name %zero $!error_no_name %movie_define
            )?
        ) %add;
        # XXX review position of errors
        # XXX conflicting error between aut and year. what do???

        command = '.' (comment | title | heading | paragraph | movie);
        text    = ([^.\n][^\n]*) $buf %type_text %zero %add;
        line = command | text;

        main :=
        start: (null -> final | '\n' @cntline -> start | line >cntline -> keep),
        keep:  (null -> final | '\n'          -> start);
    }%%

    return code;
}
