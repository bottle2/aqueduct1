#include <stdio.h>

%%{
    machine example;

    action cmd_err {
        puts("command error");
        fhold; fgoto line;
    }

    action from_err {
        puts("from error");
        fhold; fgoto line;
    }

    action to_err {
        puts("to error");
        fhold; fgoto line;
    }

    action toc_err {
        puts("toc error");
        fhold; fgoto line;
    }

    ws = space - '\n';

    line := [^\n]* '\n' @{ fgoto main; };

    main := (
          'from' @!cmd_err (ws+ 'a' ws+ 'd' '\n') @!from_err
        | 'toc' @!cmd_err (ws+ 'd' '\n') @!toc_err
        | 'to' @!cmd_err (ws+ 'a' '\n') @!to_err
    )*;
}%%

int main(void)
{
}
