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

#ifdef WIN32
// XXX piss piss piss piss cock piss piss piss piss piss piss fuck fuck
// why can't MSYS2 declare strndup?????????????????????????????????????
char *strndup(const char *s, size_t len)
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

// I'm a three start programmer.
static void elemend_add(union element ***last, union element it, enum code *error)
{
    if (*error != CODE_OKAY)
        return;

    union element *novo = malloc(sizeof (*novo));

    if (NULL == novo)
    {
        *error = CODE_ENOMEM;
        return;
    }

    *(**last = novo) = it;
    *(*last = &novo->next) = NULL;
}

// XXX fucking ugly code but what the fuck re2c, Ragel or flex??

static bool shitty_quote(char const *line, char **start, int *len)
{
    char *left = strchr(line, '\"');

    if (NULL == left) return false;

    char *right = strrchr(left + 1, '\"');

    if (NULL == right ) return false;

    *start = left + 1;
    *len = right - left - 1;
    assert(*len >= 0);

    return true;
}

static char * try_get_some_quote(char const *line, enum code *error)
{
    if (*error != CODE_OKAY)
        return NULL;

    char *start;
    int len;

    if (!shitty_quote(line, &start, &len))
    {
        *error = CODE_ERROR_NO_QUOTED;
        return NULL;
    }

    if (0 == len)
    {
        *error = CODE_EMPTY_STRING;
        return NULL;
    }

    char *str = strndup(start, len);
    if (NULL == str)
    {
        *error = CODE_ENOMEM;
        return NULL;
    }

    return str;
}

static int get_some_level(char const *line, enum code *error)
{
    if (*error != CODE_OKAY)
        return 0;

    int level = 0;
    if (sscanf(line + 8, "%d", &level) != 1
            || level < 1 || level > 6)
        *error = CODE_ERRO_LEVEL;

    return level;
}

static enum code process_line(struct movies *movies, char const *line)
{
    enum code code = CODE_OKAY;

#if 0
    puts(line);
#endif

    if (!strncmp(".\\\"", line, 3))
        return CODE_OKAY;

    if (!strncmp(".TITLE", line, 6))
    {
        if (movies->title)
            code = CODE_ERROR_TITLE_REDEF;
        else
        {
            movies->title = try_get_some_quote(line, &code);

            if (code != CODE_OKAY && code != CODE_ENOMEM)
                code = CODE_ERROR_NO_TITLE;
        }
    }
    else if (!strncmp(".HEADING", line, 8))
    {
        union element e = { .heading = {
            .type = HEADING,
            .text = try_get_some_quote(line, &code),
            .level = get_some_level(line, &code)
        }};

        if (CODE_OKAY == code)
            elemend_add(&movies->last, e, &code);

        puts("achou heading");
    }
    else if (!strncmp(".PP", line, 3))
        elemend_add(&movies->last, (union element){.type = PP}, &code); 
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

        struct movie **last_mov = movie_find(&movies->mov_first, start_symbol, len_symbol);

	if (NULL == *last_mov)
        {
            struct movie *which = malloc(sizeof (*which));
            which->next = NULL;
            which->defined = false;
            which->symbol = strndup(start_symbol, len_symbol);
            *last_mov = which;
        }

        if (!lone)
        {
            if ((*last_mov)->defined)
                return CODE_ERROR_MOVIE_ALREADY_DEFINED;

            assert(len >= 1);
            struct movie *which = *last_mov;
            which->year = year;
            which->aut = aut_code;
            which->defined = true;
            which->name = strndup(offset + n_read, len);
            puts("filme novo");
        }
        else
            puts("filme solto");

        elemend_add(&movies->last, (union element){.type = MOV, .movie = *last_mov}, &code);
    }
    else
    {
        char *text = strdup(line);

        if (NULL == text)
            code = CODE_ENOMEM;

        elemend_add(&movies->last, (union element){.type = TEXT, .text = text}, &code);

        puts("texto solto");
    }

    return code;
}
