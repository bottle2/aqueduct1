#include <stdio.h>
#include <stdlib.h>

#include "code.h"
#include "parse.h"

#define NOMAIN
#include "parse2.c"

int main(int argc, char *argv[])
{
    char *category = setlocale(LC_ALL, ".UTF8");
    assert(category != NULL);

    FILE *f = argc >= 2 ? fopen(argv[1], "rb") : stdin;

    struct parser parser = parser_init();
    struct movies movies = {.last = &movies.elements};
    int c;
    enum code code;
    while ((c = fgetc(f)) != EOF)
        if ((code = parse(&parser, &(unsigned char){c}, 1, &movies)) != CODE_OKAY)
	{
            fprintf(stderr, "stdin: %s\n", code_msg(code));
            return EXIT_FAILURE;
	}
    if ((code = parse(&parser, NULL, 0, &movies)) != CODE_OKAY)
    {
        fprintf(stderr, "stdin: %s\n", code_msg(code));
        return EXIT_FAILURE;
    }

    if ((code = vomit((struct printer){stdout, pfprintf}, &movies)) != CODE_OKAY)
    {
        fprintf(stderr, "stdin: %s\n", code_msg(code));
        return EXIT_FAILURE;
    }

    parser_del(&parser);

    movies_free(&movies);

    return EXIT_SUCCESS;
}
