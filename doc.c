#include <assert.h>
#include <stdlib.h>

#include <uv.h>

#include "code.h"
#include "doc.h"

struct doc
{
    int refcnt;

    uv_buf_t html5[4];

    struct doc *prev;
    struct doc *next;

    char internal[30];

    int gen;
};

#define HEADERS \
  "HTTP/1.1 200 OK\r\n" \
  "Connection: close\r\n" \
  "Content-Type: text/html\r\n" \
  "Content-Length: "

enum code doc_add(struct doc **previous, char const *html5, size_t len, int gen)
{
    if (*previous != NULL && (*previous)->gen > gen)
        return CODE_OLD;

    struct doc *latest = malloc(sizeof (*latest));

    if (NULL == latest)
        return CODE_ENOMEM;

    *latest = (struct doc)
    {
        .refcnt = 0,
        .html5 = {
            [0] = {.base = HEADERS      , .len = sizeof (HEADERS) - 1},
            [2] = {.base = "\r\n\r\n"   , .len = 4                   },
            [3] = {.base = (char *)html5, .len = len                 },
        },
        .prev = *previous,
        .next = NULL,
    };

    int ndigit = snprintf(latest->internal, sizeof (latest->internal), "%zu", len);
    latest->html5[1].base = latest->internal;
    latest->html5[1].len  = ndigit;

    *previous = latest;

    return CODE_OKAY;
}

uv_buf_t * doc_get(struct doc *latest)
{
    latest->refcnt++;
    return latest->html5;
}

void doc_free(struct doc *it)
{
    it->refcnt--;

    assert(it->refcnt >= 0);

    if (it->next != NULL) for (struct doc *curr = it; curr != NULL && !curr->refcnt; )
    {
        struct doc *prev = curr->prev;

        curr->next->prev = curr->prev;
        curr->prev->next = curr->next;

	free(curr->html5);
        free(curr);

        curr = prev;
    }
}

// We should unit test.
