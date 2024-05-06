#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

static size_t lenlasta(char const s[static 1], int (*accept)(int))
{
    size_t len = 0;

    for (size_t i = 0; s[i] != '\0'; i++)
        if (accept(s[i]))
            len = i + 1;

    return len;
}

static enum code process_line(struct movies *movies, char const *line);

enum code line_builder_add(struct movies *movies, struct line_builder *lb, char *buffer, int len)
{
    if (0 == len && lb->len > 0)
    {
        lb->line[lb->len] = '\0';
        process_line(movies, lb->line);
    }

    for (int i = 0; i < len && buffer[i] != '\0'; i++)
    {
        if ('\n' == buffer[i] || '\r' == buffer[i])
            lb->found_newline = true;
        else
        {
            if (lb->found_newline)
            {
                lb->found_newline = false;
                lb->line[lb->len] = '\0';
                enum code rc = process_line(movies, lb->line);
                lb->len = 0;
                if (rc != CODE_OKAY)
                    return rc;
            }

            if (lb->len == lb->capacity - 1)
            {
                char *new = realloc(lb->line, lb->capacity = lb->capacity + 20);
                if (NULL == new)
                    return CODE_ERROR_BUILDER_REALLOC;

                lb->line = new;
            }

            lb->line[lb->len++] = buffer[i];
        }
    }

    return CODE_OKAY;
}

enum code vomit(struct movies *movies)
{
    if (NULL == movies->title)
        return CODE_ERROR_NO_TITLE;

    printf(HEAD, movies->title);

    bool is_mov = false;
    bool is_pp = false;
    for (union element *curr = movies->elements; curr != NULL; curr = curr->next) switch (curr->type)
    {
        case PP:
            if (is_pp)
                return CODE_ERROR_REPEATED_PP;
            is_pp = true;
	    if (is_mov)
	    {
                puts("</ul>");
                is_mov = false;
            }
            puts("<p>");
        break;
        case TEXT:
            if (!is_pp || is_mov)
                return CODE_ERROR_HANGING_TEXT;
            else
                printf("  %s\n", curr->text);
        break;
        case HEADING:
            if (is_pp)
            {
                is_pp = false;
                puts("</p>");
            }
            if (is_mov)
	    {
                puts("</ul>");
                is_mov = false;
            }
            printf("<h%d>%s</h%d>\n", curr->heading.level, curr->heading.text, curr->heading.level);
        break;
        case MOV:
            if (is_pp)
            {
                puts("</p>");
                is_pp = false;
            }
            if (!is_mov)
            {
                puts("<ul>");
                is_mov = true;
            }
            if (!curr->movie->defined)
                return CODE_ERROR_MOVIE_UNDEFINED;
            else
            {
                // https://developer.imdb.com/documentation/key-concepts
                printf("  <li><a href=\"https://imdb.com/title/tt%07d/\">%s</a> (%d)</li>\n", curr->movie->aut, curr->movie->name, curr->movie->year);
            }
        break;

        default: assert(!"dunno"); break;
    }

    if (is_mov)
        puts("</ul>");

    puts(END);

    movies->elements = NULL;
    movies->last = &movies->elements;

    movies->title = NULL;

    return CODE_OKAY;
}

static union element * element_new(enum type type)
{
    union element *it = malloc(sizeof (*it));
    it->type = type;
    it->next = NULL;
    return it;
}

// XXX fucking ugly code but what the fuck re2c, Ragel or flex??

static enum code process_line(struct movies *movies, char const *line)
{
#if 1
    puts(line);
#endif
    if (!strncmp(".\\\"", line, 3))
        return CODE_OKAY;

    if (!strncmp(".TITLE", line, 6))
    {
        if (movies->title)
            return CODE_ERROR_TITLE_REDEF;
        char *quote_left = strchr(line, '\"');
        char *quote_right = strrchr(line, '\"');

        if (NULL == quote_right
                || NULL == quote_left
                || quote_right == quote_left)
            return CODE_ERRO_TITLE_HEAD;

        ptrdiff_t len = quote_right - quote_left - 1;
        assert(len >= 0);
        movies->title = strndup(quote_left + 1, len);
    }
    else if (!strncmp(".HEADING", line, 8))
    {
        int level;
        if (sscanf(line + 8, "%d", &level) != 1
                || level < 1 || level > 6)
            return CODE_ERRO_LEVEL;
        char *quote_left = strchr(line, '\"');
        char *quote_right = strrchr(line, '\"');

        if (NULL == quote_right
                || NULL == quote_left
                || quote_right == quote_left)
            return CODE_ERRO_TITLE;

        ptrdiff_t len = quote_right - quote_left - 1;
        assert(len >= 0);
        *(movies->last) = element_new(HEADING);
        if (NULL == movies->elements)
            movies->elements = *(movies->last);
        (*(movies->last))->heading.level = level;
        assert(len >= 1);
        (*(movies->last))->heading.text = strndup(quote_left + 1, len);
        movies->last = &(*(movies->last))->next;

        puts("achou heading");
    }
    else if (!strncmp(".PP", line, 3))
    {
        *(movies->last) = element_new(PP);
        if (NULL == movies->elements)
            movies->elements = *(movies->last);
        movies->last = &(*(movies->last))->next;
        puts("achou paragraph");
    }
    else if (!strncmp(".MOV", line, 4))
    {
        puts("achou filme");

        char *start_symbol = strpbrk(line + 4, "_ABCDEFGHIJKLMNOPQRSTUVWXYZ");
        if (NULL == start_symbol)
            return CODE_ERROR_NO_SYMBOL_MOVIE;
        int len_symbol = strspn(start_symbol, "_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");

        assert(len_symbol >= 1);

        char *offset = start_symbol + len_symbol;
        int aut_code;
        int n_read;
        int year;
        bool lone = false;

        switch (sscanf(offset, " tt%d %d %n", &aut_code, &year, &n_read))
        {
            case 0: // Fall through.
            case EOF:
                lone = true;
            break;

            case 1:
                return CODE_ERROR_NO_YEAR;
            break;
            
            case 2:
                // Nothing to do.
            break;

            default:
                assert(!"Impossible code");
            break;
        }

        // find or create block

        int len = lone ? 0 : lenlasta(offset + n_read, isgraph);
        if (!lone && len <= 0)
            return CODE_ERROR_NO_MOVIE_NAME;

        struct movie **last_mov = &movies->mov_first;
        struct movie *which = movies->mov_first;

        while (which != NULL && strncmp(which->symbol, start_symbol, len_symbol))
        {
            last_mov = &which->next;
            which = which->next;
        }

        if (NULL == which)
        {
            which = malloc(sizeof (*which));
            which->next = NULL;
            which->defined = false;
            which->symbol = strndup(start_symbol, len_symbol);
            *last_mov = which;
        }

        if (!lone)
        {
            if (which->defined)
                return CODE_ERROR_MOVIE_ALREADY_DEFINED;

            assert(len >= 1);
            which->year = year;
            which->aut = aut_code;
            which->defined = true;
            which->name = strndup(offset + n_read, len);
            puts("filme novo");
        }
        else
            puts("filme solto");

        *(movies->last) = element_new(MOV);
        if (NULL == movies->elements)
            movies->elements = *(movies->last);
        (*(movies->last))->movie = which;
        movies->last = &(*(movies->last))->next;
    }
    else
    {
        *(movies->last) = element_new(TEXT);
        if (NULL == movies->elements)
            movies->elements = *(movies->last);
        (*(movies->last))->text = malloc(strlen(line) + 1);
        strcpy((*(movies->last))->text, line);
        movies->last = &(*(movies->last))->next;
        puts("texto solto");
    }

    return CODE_OKAY;
}
