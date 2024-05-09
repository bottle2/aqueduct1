#ifndef PARSE_H
#define PARSE_H

#include <stdbool.h>

#include "code.h"
#include "movie.h"

struct printer
{
    void *data;
    int (*pprintf)(void *data, char const *fmt, ...);
};

int pfprintf(void *data, char const *fmt, ...);

enum code vomit(struct printer p, struct movies *movies);

struct line_builder
{
    char *line;
    int len;
    int capacity;
    bool found_newline;
};

enum code line_builder_add(struct movies *movies, struct line_builder *lb, char *buffer, int len);

#endif
