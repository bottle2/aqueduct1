#include <stdio.h>

int main(int argc, char *argv[])
{
    if (argc != 2) return 1;
    FILE *f = fopen(argv[1],"rb");
    for (int c,o=0; (c = fgetc(f)) != EOF; )
        printf("%s%d",","+!(o++),c);
    fclose(f);
    return 0;
}
