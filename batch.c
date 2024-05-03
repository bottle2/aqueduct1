#include <stdio.h>
#include <stdlib.h>

#include "parse.h"

int main(void)
{
    struct line_builder lb = {.line = malloc(1), .capacity = 1};
    int c;
    while ((c = getchar()) != EOF)
        line_builder_add(&lb, (char []){c}, 1);
    line_builder_add(&lb, NULL, 0);

    vomit();

    return 0;
}
