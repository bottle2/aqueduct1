#ifndef MOVIE_H
#define MOVIE_H

#include <stdbool.h>

struct movie
{
    char *symbol;
    bool defined;
    int aut;
    int year;
    char *name;
    struct movie *next;
};

union element
{
    struct
    {
        enum type { NONE, HEADING, MOV, PP, TEXT, TITLE } type;
        union element *next;
        union
        {
            char *text;
            struct movie *movie;
        };
    };
    struct heading
    {
        enum type type;
        union element *next;
        int level;
        char *text;
    } heading;
};

static union element * element_new(enum type type)
{
    union element *it = malloc(sizeof (*it));
    it->type = type;
    it->next = NULL;
    return it;
}

struct movies
{
    struct movie *mov_first;

    union element *elements;
    union element **last;

    char *title;
};

#endif
