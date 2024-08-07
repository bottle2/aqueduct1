#include <stdbool.h>

static bool is_centered = false;
static bool is_expanded = false;
static enum box { BOX_NONE, BOX, BOX_ALL, BOX_DOUBLE } box = BOX_NONE;
static char tab_separator = '\t';
static int  line_size = 0;
static bool has_eqn_delim = false;
static char eqn_delim_left;
static char eqn_delim_right;

%{
    # I don't know exact syntax, so bear with me.

    EOL = '\r'? '\n'?; # End of line.
    OWS = [ \t]*;      # Optional whitespace.
    RWS = [ \t]+;      # Required whitespace.

    action set_centered  { is_centered = true; }
    action set_expanded  { is_expanded = true; }
    action set_box       { box = BOX;        }
    action set_allbox    { box = BOX_ALL;    }
    action set_doublebox { box = BOX_DOUBLE; }
    action set_tab       { tab_separator = fc; }
    action set_line_size { line_size = line_size * 10 + fc; }
    action set_eqn_delim_left  { eqn_delim_left  = fc; }
    action set_eqn_delim_right { eqn_delim_right = fc; has_eqn_delim = true; }

    option  = "center" %set_centered
            | "expand" %set_expanded
            | "box"       %set_box
            | "allbox"    %set_allbox
            | "doublebox" %set_doublebox
            | "tab"      OWS '(' graph  %set_tab             ')'
            | "linesize" OWS '(' digit+ $set_line_size       ')'
            | "delim"    OWS '(' graph  %set_eqn_delim_left
                                 graph  %set_eqn_delim_right ')';

    options = OWS (option OWS)*;

    format = 

    part = format '.' EOL data EOL;
    table = ".TS" (RWS 'H')? EOL (options ';' EOL)? part (".T&" EOL part) ".TE" EOL
    main: = table*
}%

int main(void)
{
    return 0;
}
