#include <ctype.h>
#include <stdio.h>
#include <string.h>

#define RESERVED GEN_DELIMS SUB_DELIMS
#define GEN_DELIMS ":/?#[]@"
#define SUB_DELIMS "!$&()*+,;=" // we omit ' because m4 can't handle it LOL

#define UNRESERVED "-._~"

int main(void)
{
    puts("define(`TRI',`ifelse(");

    #define HEX_HASNT_ALPHA(C) !((C) >= 160 || (((C) % 16) >= 10 && ((C) % 16) < 16))

    for (int i = 1; i < 256; i++)
        if (strchr(RESERVED, i))
            printf(" $1,`%c',`\"%%%X\"%s',\n", i, i, "i"+HEX_HASNT_ALPHA(i));
        else if (isalpha(i) || isdigit(i) || strchr(UNRESERVED, i))
            printf(" $1,`%c',`(\"%c\" | \"%%%X\"%s)',\n", i, i, i, "i"+HEX_HASNT_ALPHA(i));

    puts("`m4exit(1)')')dnl");

    return 0;
}
