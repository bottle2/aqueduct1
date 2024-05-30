#include <assert.h>
#include <locale.h>
#include <stdio.h>

#include "code.h"

%% machine movies;

struct parser
{
    int cs;
    int nl;
};

struct parser parser_init(void);
enum code parse(struct parser *parser, unsigned char *buffer, int len);

int main(int argc, char *argv[])
{
    char *category = setlocale(LC_ALL, ".UTF8");
    assert(category != NULL);

    FILE *f = argc >= 2 ? fopen(argv[1], "rb") : stdin;

    struct parser parser = parser_init();

    int c;

    while ((c = fgetc(f)) != EOF)
        (void)parse(&parser, &(unsigned char){c}, 1);
    (void)parse(&parser, NULL, 0);

    printf("line count = %d\n", parser.nl);

    return 0;
}

%% write data noerror nofinal noentry;

struct parser parser_init(void)
{
    struct parser it = { .nl = 0 };
    struct parser *parser = &it;
    %% write init;
    return it;
}

enum code parse(struct parser *parser, unsigned char *p, int len)
{
    unsigned char *pe  = 0 == len ? p : p + len;
    unsigned char *eof = 0 == len ? p : NULL;

    %%{
        alphtype unsigned char;
        access parser->;
        write exec;

        action cntline { parser->nl++; }

        comment   = "\\\""    %{ puts("achei comentário"); };
        title     = "TITLE"   %{ puts("achei título");     };
        heading   = "HEADING" %{ puts("achei heading");    };
        paragraph = "PP"      %{ puts("achei parágrafo");  };
        movie     = "MOV"     %{ puts("achei filme");      };
        command_valid = comment [^\n]*
                      | (title | heading | paragraph | movie) ((space - '\n') [^\n]*)?;
        command_invalid = ([^\n]* -- command_valid) %{ puts("achei inválido"); };

        command = '.' (command_valid | command_invalid);
        text    = [^\n]* - command;

        line = command | text %{ puts("achei texto"); };
        main := ('\n' >cntline | line >cntline '\n')*;
    }%%

    return CODE_OKAY;
}
