#ifndef PARSE_H
#define PARSE_H

#include <stdbool.h>

void vomit(void);

struct line_builder
{
    char *line;
    int len;
    int capacity;
    bool found_newline;
};

void line_builder_add(struct line_builder *lb, char *buffer, int len);

#endif
