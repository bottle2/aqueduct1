#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if 1
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
#endif

size_t lenlasta(char const s[static 1], int (*accept)(int))
{
    size_t len = 0;

    for (size_t i = 0; s[i] != '\0'; i++)
        if (accept(s[i]))
            len = i + 1;

    return len;
}

struct movie
{
    char *symbol;
    bool defined;
    int aut;
    int year;
    char *name;
    struct movie *next;
};

struct movie *mov_first = NULL;

union element
{
    struct
    {
        enum type { NONE, HEADING, MOV, PP, TEXT, TITLE } type;
        union element *next;
        union
        {
            char *text;
            struct movie *movie;
        };
    };
    struct heading
    {
        enum type type;
        union element *next;
        int level;
        char *text;
    } heading;
};

static union element * element_new(enum type type)
{
    union element *it = malloc(sizeof (*it));
    it->type = type;
    it->next = NULL;
    return it;
}

int main(void)
{
    char *line = NULL;

    union element *elements = NULL;
    union element **last = &elements;
    
    char *title = NULL;

    while (getline(&line, &(size_t){0}, stdin) != -1)
    {
        line[strcspn(line, "\n")] = '\0';
#if 0
        puts(line);
#endif
        if (strncmp(".\\\"", line, 3))
        {
            if (!strncmp(".TITLE", line, 6))
            {
                char *quote_left = strchr(line, '\"');
                char *quote_right = strrchr(line, '\"');

                if (NULL == quote_right
                        || NULL == quote_left
                        || quote_right == quote_left)
                    puts("erro title head");
                else
                {
                    ptrdiff_t len = quote_right - quote_left - 1;
                    title = malloc(len + 1);
                    strncpy(title, quote_left + 1, len);
                }
            }
            else if (!strncmp(".HEADING", line, 8))
            {
                int level;
                if (sscanf(line + 8, "%d", &level) != 1
                        || level < 1 || level > 6)
                    puts("erro level");
                else
                {
                    char *quote_left = strchr(line, '\"');
                    char *quote_right = strrchr(line, '\"');

                    if (NULL == quote_right
                            || NULL == quote_left
                            || quote_right == quote_left)
                        puts("erro title");
                    else
                    {
                        ptrdiff_t len = quote_right - quote_left - 1;
                        *last = element_new(HEADING);
                        if (NULL == elements)
                            elements = *last;
                        (*last)->heading.level = level;
                        (*last)->heading.text = malloc(len + 1);
                        strncpy((*last)->heading.text, quote_left + 1, len);
                        last = &(*last)->next;
                    }
                }
                puts("achou heading");
            }
            else if (!strncmp(".PP", line, 3))
            {
                *last = element_new(PP);
                if (NULL == elements)
                    elements = *last;
                last = &(*last)->next;
                puts("achou paragraph");
            }
            else if (!strncmp(".MOV", line, 4))
            {
                puts("achou filme");

		char *start_symbol = strpbrk(line + 4, "_ABCDEFGHIJKLMNOPQRSTUVWXYZ");
                if (NULL == start_symbol)
                {
                    puts("error no symbol movie");
		    continue;
                }
		int len_symbol = strspn(start_symbol, "_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");

		assert(len_symbol >= 1);

		char *offset = start_symbol + len_symbol;
                int aut_code;
                int n_read;
                int year;
                int code;
                bool lone = false;

		while ((code = sscanf(offset, " tt%d %d %n", &aut_code, &year, &n_read)) != 2)
                {
                    if (EOF == code)
                    {
                        lone = true;
                        break;
                    }
                    else if (0 == code)
                    {
                        char *start_tag = strpbrk(offset, "_ABCDEFGHIJKLMNOPQRSTUVWXYZ");
                        if (NULL == start_tag)
                        {
                            puts("error no tag movie");
                            continue;
                        }
                        int len_tag = strspn(start_tag, "_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
                        assert(len_tag >= 1);
                        offset = start_tag + len_tag;
                    }
                    else
                    {
                        printf("c %d\n", code);
                        break;
                    }
                }

                // find or create block

                int len = lone ? 0 : lenlasta(offset + n_read, isgraph);
                if (!lone && 0 == len)
                {
                    puts("error no movie name");
                    continue;
                }

                struct movie **last_mov = &mov_first;
                struct movie *which = mov_first;

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
                    which->symbol = malloc(len_symbol + 1);
                    strncpy(which->symbol, start_symbol, len_symbol);
                    *last_mov = which;
                }

                if (!lone)
                {
                    if (which->defined)
                    {
                        puts("error movie already defined");
                        break;
                    }
                    else
                    {
                        which->year = year;
                        which->aut = aut_code;
                        which->defined = true;
                        which->name = malloc(len + 1);
                        strncpy(which->name, offset + n_read, len);
                        puts("filme novo");
                    }
                }
                else
                    puts("filme solto");

                *last = element_new(MOV);
                if (NULL == elements)
                    elements = *last;
                (*last)->movie = which;
                last = &(*last)->next;
            }
            else
            {
                *last = element_new(TEXT);
                if (NULL == elements)
                    elements = *last;
                (*last)->text = malloc(strlen(line + 1));
                strcpy((*last)->text, line);
                last = &(*last)->next;
                puts("texto solto");
            }
        }
    }

    if (ENOMEM == errno)
        fprintf(stderr, "Faltou memória\n");

    if (NULL == title)
    {
        puts("erro no title");
        return 1;
    }

    printf(HEAD, title);

    bool is_mov = false;
    bool is_pp = false;
    for (union element *curr = elements; curr != NULL; curr = curr->next) switch (curr->type)
    {
        case PP:
            if (is_pp)
                puts("error repeated pp");
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
                puts("error hanging text");
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
            {
                puts("error movie undefined");
                break;
            }
            else
            {
                // https://developer.imdb.com/documentation/key-concepts
                printf("  <li><a href=\"https://imdb.com/title/tt%07d/\">%s</a> (%d)</li>\n", curr->movie->aut, curr->movie->name, curr->movie->year);
            }
            //printf("%.*s tt%d %d %.*s\n", len_symbol, start_symbol, aut_code, year, len, offset + n_read);
        break;

        default: puts("dunno"); break;
    }

    if (is_mov)
        puts("</ul>");

    puts(END);

    return 0;
}
