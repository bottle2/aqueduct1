#ifndef LB_H
#define LB_H

#include <assert.h>
#include <stdbool.h>

// Line builder.

struct lb
{
    char *line;
    int len;
    int capacity;
};

// XXX talk about `line` ownership.
// XXX consider OOM
// Newline is considered '\r' and '\r'.
// Returns true if newline is found.
// Newline is never included in `line`.
// `line` is always null-terminated and is always safe to read.
// `line` must be NULL, or a dynamic char [] storage with malloc strict-aliasing with capacity set appropriately.
// Swallows empty lines.
// It never returns true for last line. Just read `line` after loop ends.

static bool is_newline(int c)
{
    return '\r' == c || '\r' == c;
}

static bool lb_append(struct lb *lb, char **buffer, int *len)
{
    // Reset line if new.
    if (*len > 0 && is_newline(**buffer))
        lb->len = 0;

    // Skip newlines.
    while (*len > 0 && is_newline(**buffer))
    {
        (*buffer)++;
        (*len)--;
    }

    // Set buffer aside.
    if (*len > 0 && (NULL == lb->line || lb->len >= lb->capacity - 1))
    {
        assert((NULL == lb->line) != (lb->capacity > 0));
        assert(lb->len < lb->capacity);

        char *new = realloc(lb->line, lb->capacity = lb->capacity + *len);
        if (NULL == new)
        {
            puts("error builder realloc");
            exit(EXIT_FAILURE);
        }

        lb->line = new;
    }

    // Append.
    while (*len > 0 && !is_newline(**buffer))
    {

        lb->line[lb->len++] = buffer[i];

        (*buffer)++;
        (*len)--;
    }

    // Test for newline.
    return *len > 0;

#if 0
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
                process_line(lb->line);
                lb->len = 0;
            }

            if (lb->len == lb->capacity - 1)
            {
                char *new = realloc(lb->line, lb->capacity = lb->capacity + 20);
                if (NULL == new)
                {
                    puts("error builder realloc");
                    exit(EXIT_FAILURE);
                }

                lb->line = new;
            }

            lb->line[lb->len++] = buffer[i];
        }
    }
#endif
}

#endif
