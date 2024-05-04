#include <stdio.h>
#include <stdlib.h>

#include "code.h"
#include "parse.h"

int main(void)
{
    struct line_builder lb = {.line = malloc(1), .capacity = 1};
    struct movies movies = {.last = &movies.elements};
    int c;
    enum code code;
    while ((c = getchar()) != EOF)
        if ((code = line_builder_add(&movies, &lb, (char []){c}, 1)) != CODE_OKAY)
	{
            fprintf(stderr, "stdin: %s\n", code_msg(code));
            return EXIT_FAILURE;
	}
    if ((code = line_builder_add(&movies, &lb, NULL, 0)) != CODE_OKAY)
    {
        fprintf(stderr, "stdin: %s\n", code_msg(code));
        return EXIT_FAILURE;
    }

    if ((code = vomit(&movies)) != CODE_OKAY)
    {
        fprintf(stderr, "stdin: %s\n", code_msg(code));
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
