#ifndef MOVIE_H
#define MOVIE_H

#include <stdbool.h>

#include "expand.h"
#include "instr.h"

struct movie
{
    char *symbol;
    bool defined;
    int aut;
    int year;
    char *name;
    struct movie *next;
};

struct movie ** movie_find(struct movie **first, char *symbol, int len);

struct element
{
    enum type { TEXT, INSTR_XS(AS_1_OF_1_COMMA) } type;
    struct element *next;
    union
    {
        char *text;
        struct movie *movie;
        struct heading
        {
            int level;
            char *text;
        } heading;
    };
};

struct movies
{
    struct movie *mov_first;

    struct element *elements;
    struct element **last;

    char *title;
};

#endif
