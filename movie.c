#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "movie.h"

#ifdef WIN32
// god why oh god why god why oh god why why why god oh why god why god why why god
static char *strndup(const char *s, size_t len)
{
    char *copy = malloc(len + 1);
    if (NULL == copy)
        return NULL;
    size_t i = 0;
    for (; i < len && s[i] != '\0'; i++)
        copy[i] = s[i];
    copy[i] = '\0';
    return copy;
}
#endif

struct movie * movie_find_or_create(struct movie **match, char *symbol, int len)
{
    struct movie **last = match;
    while (*last != NULL && strncmp((*last)->symbol, symbol, len))
        last = &(*last)->next;

    if (NULL == *last)
    {
        *last = malloc(sizeof (**last));

        if (NULL == *last)
            return NULL;

        if (NULL == ((*last)->symbol = strndup(symbol, len)))
        {
            free(*last);
            *last = NULL;
            return NULL;
        }

        (*last)->next    = NULL;
        (*last)->defined = false;
    }

    return *last;
}

void movies_free(struct movies *em)
{
    free(em->title);

    struct element *curr = em->elements;

    while (curr != NULL)
    {
        switch (curr->type)
        {
            case TEXT:    free(curr->text        ); break;
            case HEADING: free(curr->heading.text); break;
            case TITLE: assert(!"Impossible"); break;
            case PP:  /* Do nothing. */ break;
            case MOV: /* Do nothing. */ break;
            default:    assert(!"no no no n"); break;
        }
        struct element *next = curr->next;
        free(curr);
        curr = next;
    }

    // same drill
    struct movie *curr2 = em->mov_first;

    while (curr2 != NULL)
    {
        free(curr2->symbol);
        free(curr2->name);

        struct movie *next = curr2->next;
        free(curr2);
        curr2 = next;
    }

    em->last = &em->elements;
}
