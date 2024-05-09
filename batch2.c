#include <assert.h>
#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include "code.h"
#include "parse.h"

static size_t length = 0;
static int cprintf(void *data, char const *fmt, ...)
{
    size_t *len = data;

    va_list ap;
    va_start(ap, fmt);

    int code = vsnprintf(NULL, 0, fmt, ap);

    assert(code >= 0);

    if (code >= 0)
        *len += code;

    va_end(ap);

    return code;
}

struct virt_file
{
    char *buffer;
    int pos;
    int cap;
};

static int dprintf(void *data, char const *fmt, ...)
{
    struct virt_file *vf = data;

    va_list ap;
    va_start(ap, fmt);

    int code = vsnprintf(vf->buffer + vf->pos, vf->cap, fmt, ap);

    assert(code >= 0);

    vf->pos += code;

    assert(vf->pos < vf->cap);
    assert(code < vf->cap);

    va_end(ap);

    return code;
}

struct printer cprinter = {.data = &length, .pprintf = cprintf};

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

    if ((code = vomit(cprinter, &movies)) != CODE_OKAY)
    {
        fprintf(stderr, "stdin: %s\n", code_msg(code));
        return EXIT_FAILURE;
    }

    printf("Would write %zu + 1 bytes!!!!\n", length);

    struct virt_file ffffff = {.buffer = malloc(length + 1), .pos = 0, .cap = length + 1};

    if (NULL == ffffff.buffer)
    {
        fprintf(stderr, "ENOMEM\n");
        return EXIT_FAILURE;
    }

    struct printer dprinter = {.data = &ffffff, .pprintf = dprintf};

    (code = vomit(dprinter, &movies));

    assert(CODE_OKAY == code);

    printf("%s", ffffff.buffer);

    printf("pos is %d\n", ffffff.pos);

    movies_free(&movies);

    return EXIT_SUCCESS;
}
