#ifndef MOVIE_H
#define MOVIE_H

#include <stdbool.h>

struct movie
{
    char *symbol;
    int acode;
    int year;
    char *name;
};

struct tag
{
    char *symbol;
    int n_child;
    struct tag *children;
    bool is_inline;
};

struct obligatory
{
    bool is_exclusive;
    int n;
    struct tag *them;
};

struct text
{
};

#endif
