int cs;

%% machine end;
%% write data;

int parse(char *p, char *pe);

int main(void)
{
    int cs;
    char *p = "foobarbarbarlalala");
    char *pe = p + strlen(p) + 1;
    %%{
        machine end;

        write data;
        write init;
        write exec;

    }%%

    return 0;
}
