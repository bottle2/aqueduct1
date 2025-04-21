#include <stdio.h>
#include <stddef.h>

%%{
    machine ctt;
    alphtype unsigned char;

    action echo { putchar(fc); }
    action die { puts("you fool!"); return 1; }

    action bslash_inc { n_bslash++; }
    action bslash_all {
        while (n_bslash-- > 0) putchar('\\');
        n_bslash = 0;
    }
    action bslash_half {
        while ((n_bslash -= 2) > 0) putchar('\\');
        n_bslash = 0;
    }

    action corpus_begin { printf("CTT_P(\""); }
    action corpus_end   { printf("\")"); }
    action corpus_percent { putchar('%'); putchar('%'); }
    action corpus_escape {
        putchar('\\');
        switch (fc)
        {
            case '\\': // Fall through.
            case '\'': // Fall through.
            case '\"': putchar(fc); break;
            case '\a': putchar('a'); break;
            case '\b': putchar('b'); break;
            case '\f': putchar('f'); break;
            case '\n': putchar('n'); break;
            case '\r': putchar('r'); break;
            case '\t': putchar('t'); break;
            case '\v': putchar('v'); break;
            default: printf("%o", fc); break;
        }
    }

    EOL = '\r'? '\n';

    comment_c = "/*" ( ( any )* - ( any* "*/" any*) ) "*/";
    comment_cpp = "//" any* :>> EOL;
    comment = comment_c | comment_cpp;

    escape_sequence = '\\' (['"?\\abfnrtv] | [0-7]{1,3} | 'x' xdigit+);
    string_lit = '"' ([^"\\\n] | escape_sequence)+ '"';
    char_const = "'" ([^'\\\n] | escape_sequence)+ "'";
    token = string_lit | char_const;

    corpus = (
        start: (
              (any - print - [%$\\]) @corpus_escape -> start
            | ['"] @corpus_escape -> start
            | (print-[%$\\]-['"]) @echo -> start
            | '%' @corpus_percent -> start
            | '$' @corpus_end -> final
            | '\\' @bslash_inc -> bslash_odd_2
        ),
        bslash_odd_2: (
              (any - print - [%$\\]) @bslash_all @corpus_escape -> start
            | ['"] @corpus_escape -> start
            | (print-[%$\\]-['"]) @bslash_all @echo -> start
            | '%' @bslash_all @corpus_percent -> start
            | '$' @bslash_half @echo -> start
            | '\\' @bslash_inc -> bslash_even
        ),
        bslash_even: (
              (any - print - [%$\\]) @bslash_all @corpus_escape -> start
            | ['"] @corpus_escape -> start
            | (print-[%$\\]-['"]) @bslash_all @echo -> start
            | '%' @bslash_all @corpus_percent -> start
            | '$' @bslash_half @corpus_end -> final
            | '\\' @bslash_inc -> bslash_odd_2
        )
    ) >corpus_begin;

    maybe_corpus = [^$\\] @echo
                  | (('\\' "\\\\"*) $bslash_inc '$' @bslash_half @echo )
                  | ("\\\\"* $bslash_inc '$' @bslash_half corpus)
                  | ('\\'+ $bslash_inc [^$\\] @bslash_all);

    main := ((token | comment)>2 $echo | maybe_corpus>1)* $!die;

    write data noerror nofinal noentry;
}%%

int main(void)
{
    int cs, curr;
    unsigned char prev, *pe = &prev + 1, *eof;
    int n_bslash = 0;

    %% write init;

    curr = getchar();

    while (curr != EOF)
    {
        prev = curr;
        curr = getchar();
        eof = EOF == curr ? pe : NULL;
        unsigned char *p = &prev;
        %% write exec;
    }

    return 0;
}
