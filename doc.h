#ifndef DOC_H
#define DOC_H

#include <uv.h>

#include "code.h"

// Thread-unsafe.
// XXX Explain moar. Lots to document.
// Good old DESIGN.

struct doc;
// I don't like the choice of names.

enum code  doc_add (struct doc **latest, char const *html5, size_t len, int gen);
uv_buf_t * doc_get (struct doc  *latest); // Always 4.
void       doc_free(struct doc  *it); // Tell to keep pointer after doc_get().

#endif
