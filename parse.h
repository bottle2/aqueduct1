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
enum code parse(struct parser *parser, unsigned char *buffer, int len, struct movies *movies);

#endif
