#ifndef PARSE_H
#define PARSE_H

#include <stdbool.h>

#include "code.h"
#include "movie.h"

struct printer
{
    void *data;
    void (*print_str)(void *, char const *);
    void (*print_int)(void *, int value, bool lzero, int width);
};

enum code vomit(struct movies *movies);

struct line_builder
{
    char *line;
    int len;
    int capacity;
    bool found_newline;
};

enum code line_builder_add(struct movies *movies, struct line_builder *lb, char *buffer, int len);

#endif
