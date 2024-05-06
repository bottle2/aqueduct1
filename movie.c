#include <string.h>

#include "movie.h"

struct movie ** movie_find(struct movie **match, char *symbol, int len)
{
    while (*match != NULL && strncmp((*match)->symbol, symbol, len))
        match = &(*match)->next;

    return match;
}
