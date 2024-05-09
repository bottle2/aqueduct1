#include <assert.h>
#include <stdlib.h>

#include "doc.h"

struct doc
{
    int reference_count;
    char *html5;
    struct doc *prev;
    struct doc *next;
};

enum code doc_add(struct doc **previous, char const *html5)
{
    struct doc *latest = malloc(sizeof (*latest));

    if (NULL == latest)
        return CODE_ENOMEM;

    latest->refcnt = 0;
    latest->html5  = html5;
    latest->prev   = *previous;
    latest->next   = NULL;

    *previous = latest;

    return CODE_OKAY;
}

struct doc * doc_get(struct doc *latest)
{
    latest->refcnt++;
    return latest;
}

void doc_free(struct doc *it)
{
    it->refcnt--;

    assert(it->refcnt >= 0);

    for (struct doc *curr = it; curr != NULL && !curr->refcnt; )
    {
        struct doc *prev = curr->prev;

        curr->next.previous = curr->previous;
        curr->previous.next = curr->next;

        free(curr);

        curr = prev;
    }
}

// We should unit test.
