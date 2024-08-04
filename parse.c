#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "code.h"
#include "parse.h"
#include "movie.h"

#define HEAD \
"<!doctype html>" \
"\n<html lang=\"en\">" \
"\n<head>" \
"\n  <meta charset=\"UTF-8\">" \
"\n  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" \
"\n  <title>%s - aqueduct1</title>" \
"\n</head>" \
"\n<body>\n"

#define END "</body>\n</html>"

int pfprintf(void *data, char const *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    int code = vfprintf((FILE *)data, fmt, ap);
    va_end(ap);
    return code;
}

// XXX We want to change THIS!
// hmmmmmm state machines
enum code vomit(struct printer p, struct movies *movies)
{
    if (NULL == movies->title)
        return CODE_ERROR_NO_TITLE;

    p.pprintf(p.data, HEAD, movies->title);

    bool is_archive = false;
    bool is_mention = false;
    // XXX This is becoming unwieldy!
    bool is_mov = false;
    bool is_pp = false;
    bool is_note = false;
    bool is_footnote = false; // XXX Implicit paragraph, but should not be!!!
    for (struct element *curr = movies->elements; curr != NULL; curr = curr->next)
    {
        if (is_footnote && curr->type != FOOTNOTE_END)
        {
            if (curr->type != TEXT)
                return CODE_ERROR_UNEXPECTED_IN_FOOTNOTE;
            continue;
        }

        switch (curr->type)
        {
            case NOTE:
            break;
            case FOOTNOTE_START:
                is_footnote = true;
            break;
            case FOOTNOTE_END:
                if (!is_footnote)
                    return CODE_ERROR_NO_FOOTNOTE_TO_CLOSE;
                is_footnote = false;
            break;
            case GAME:
            break;
            case LOC:
            break;
            case MENTION:
#if 0
                if (is_mention)
                    return CODE_ERROR_REPEATED_MENTION;
                is_mention = true;
#endif
            break;
            case ARCHIVE:
#if 0
                if (is_archive)
                    return CODE_ERROR_REPEATED_ARCHIVE;
                is_archive = true;
#endif
            break;
            case LABEL:
            break;
            case PP:
                if (is_pp)
                    return CODE_ERROR_REPEATED_PP;
                is_pp = true;
                if (is_mov)
                {
                    p.pprintf(p.data, "</ul>\n");
                    is_mov = false;
                }
                p.pprintf(p.data, "<p>\n");
            break;
            case TEXT:
                if (!is_pp || is_mov)
                    return CODE_ERROR_HANGING_TEXT;
                else
                    p.pprintf(p.data, "  %s\n", curr->text);
            break;
            case HEADING:
                if (is_pp)
                {
                    is_pp = false;
                    p.pprintf(p.data, "</p>\n");
                }
                if (is_mov)
                {
                    p.pprintf(p.data, "</ul>\n");
                    is_mov = false;
                }
                p.pprintf(p.data, "<h%d>%s</h%d>\n", curr->heading.level, curr->heading.text, curr->heading.level);
            break;
            case MOV:
                if (is_pp)
                {
                    p.pprintf(p.data, "</p>\n");
                    is_pp = false;
                }
                if (!is_mov)
                {
                    p.pprintf(p.data, "<ul>\n");
                    is_mov = true;
                }
                if (!curr->movie->defined)
                    return CODE_ERROR_MOVIE_UNDEFINED;
                else
                {
                    // https://developer.imdb.com/documentation/key-concepts
                    p.pprintf(p.data, "  <li><a href=\"https://imdb.com/title/tt%07d/\">%s</a> (%d)</li>\n", curr->movie->aut, curr->movie->name, curr->movie->year);
                }
            break;

            default: assert(!"dunno"); break;
        }
    }

    if (is_mov)
        p.pprintf(p.data, "</ul>\n");

    p.pprintf(p.data, "%s\n", END);

    return CODE_OKAY;
}
