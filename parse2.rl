#include <assert.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "code.h"
#include "movie.h"

%% machine movies;

struct parser
{
    int cs;
    int nl;

    char *buf;
    int len;
    int cap;

    char *title;

    struct element e;
};

struct parser parser_init(void);
void parser_del(struct parser *parser);
enum code parse(struct parser *parser, unsigned char *buffer, int len);

int main(int argc, char *argv[])
{
    char *category = setlocale(LC_ALL, ".UTF8");
    assert(category != NULL);

    FILE *f = argc >= 2 ? fopen(argv[1], "rb") : stdin;

    struct parser parser = parser_init();

    int c;

    enum code code = CODE_OKAY;

    while (CODE_OKAY == code && (c = fgetc(f)) != EOF)
        if ((code = parse(&parser, &(unsigned char){c}, 1)) != CODE_OKAY)
            puts(code_msg(code));
    if ((code = parse(&parser, NULL, 0)) != CODE_OKAY)
        puts(code_msg(code));

    printf("line count = %d\n", parser.nl);

    parser_del(&parser);

    return 0;
}

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

enum code parse(struct parser *parser, unsigned char *p, int len)
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

        action type_text      { parser->e.type = TEXT;    }
        action type_heading   { parser->e.type = HEADING; }
        action type_paragraph { parser->e.type = PP;      }
        action type_movie     { parser->e.type = MOV;     }
        action type_invalid   { parser->e.type = INVALID; puts("achei inválido"); }

        action add {
            switch (parser->e.type)
            {
                case TEXT:
                    printf("%d achei texto %s\n", parser->nl, parser->buf);
                break;
                case HEADING:
                    printf("%d achei heading %d: %s\n", parser->nl, parser->e.heading.level, parser->buf);
                break;
                case PP:
                    printf("%d achei parágrafo\n", parser->nl);
                break;
                case MOV:
                    printf("%d achei filme\n", parser->nl);
                break;
                default:
                    assert(!"Não sei");
                break;
            }
            if (parser->len > 0)
                parser->buf[0] = '\0';
            parser->len = 0;
        }

        action add_title {
            assert(parser->len > 0);

            printf("%d achei title: %s\n", parser->nl, parser->buf);

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

        comment = "\\\"" @!type_invalid [^\n]* %{ puts("achei comentário"); };

        title = "TITLE" $!type_invalid (RWS quoted) OWS $!error_trailing %add_title;

        action error_level { code = CODE_ERRO_LEVEL; }

        heading = "HEADING" @type_heading @!type_invalid (RWS [1-6] @level) $!error_level (RWS quoted) OWS $!error_trailing %add;

        paragraph = "PP" @!type_invalid 
                    OWS  $!error_trailing %{ puts("achei parágrafo"); };

        movie     = "MOV" @!type_invalid ((space - '\n') [^\n]*)? %{ puts("achei filme");      };

        command = '.' (comment | title | heading | paragraph | movie);
        text    = ([^.\n][^\n]*) $buf %type_text %add;

        line = command | text;
        main :=
        start: (null -> final | '\n' @cntline -> start | line >cntline -> keep),
        keep:  (null -> final | '\n'          -> start);
    }%%

    return code;
}

#include "code.c"
