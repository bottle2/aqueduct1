#ifndef DOC_H
#define DOC_H

#include <code.h>

// Thread-unsafe.
// XXX Explain moar.
// Good old DESIGN.

struct doc;

// I don't like the choice of names.

enum   code   doc_add (struct doc **latest, char const *html5);
struct doc  * doc_get (struct doc  *latest);
void          doc_free(struct doc  *it);

#endif
