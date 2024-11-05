#include <ctype.h>
#include <stdbool.h>
#include <stdlib.h>

// Our primary objective is to barebones render all classic examples to HTML.

static bool is_centered = false;
static bool is_expanded = false;
static enum box { BOX_NONE, BOX, BOX_ALL, BOX_DOUBLE } box = BOX_NONE;
static unsigned char tab_separator = '\t';
static int  line_size = 0;
static bool has_eqn_delim = false;
static unsigned char eqn_delim_left;
static unsigned char eqn_delim_right;

enum key_letter {
    KEY_LETTER_NONE = '0',
    KEY_LETTER_COLUMN_ENTRY_LEFT_ADJUSTED  = 'L',
    KEY_LETTER_COLUMN_ENTRY_RIGHT_ADJUSTED = 'R',
    KEY_LETTER_COLUMN_ENTRY_CENTERED       = 'C',
    KEY_LETTER_COLUMN_ENTRY_NUMERICAL      = 'N',
    KEY_LETTER_ALPHABETIC_SUBCOLUMN        = 'A',
    KEY_LETTER_SPANNED_HEADING             = 'S',
    KEY_LETTER_SPANNED_HEADING_VERTICALLY  = '^',
};

struct col
{
    enum key_letter key_letter;
    bool end;
    // TODO handle horizontal and vertical bars.
    
    struct col *next;
};

static struct col  *first = NULL;
static struct col **last  = &first;
static int longest = 0;
static int this_long = 0;

%%{
    machine tbl;
    alphtype unsigned char;
    # I don't know exact syntax, so bear with me.

    EOL = '\r'? '\n'; # End of line. Not handling macOS' single CR.
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
    # TODO I think number registers can be used for `tab` and `linesize`.

    option_sep = (OWS ',' OWS) | RWS;
    options = OWS option (option_sep option)* OWS;

    action set_key_letter {
        struct col *next = malloc(sizeof (struct col));
        if (NULL == next)
        {
            perror(NULL);
            exit(EXIT_FAILURE);
        }
        next->key_letter = toupper(fc);
        next->next = NULL;
        if (first != NULL)
            (*last)->next = next;
        *last = next;

        this_long++;
    }

    action next_line {
        if (this_long > longest)
            longest = this_long;
        this_long = 0;
    }

    column_modifier = digit+
                    |  'T'i
                    | ('F'i (digit+ | (alpha (alpha | [ \t]))))
                    |  'B'i
                    |  'I'i
                    | ('P'i [+\-]? digit+ (RWS digit+)?)
                    | ('V'i [+\-]? digit+ (RWS digit+)?)
                    | ('W'i ((digit+ (RWS digit+)) | ('(' digit+ [uicpPmnvM]? ')')))
                    |  'E'i
                    |  'U'i
                    |  'Z'i;

    # XXX repetition is allowed here... dunno if standard
    # TODO actual side effects

    vbars = '|' (OWS '|')?;
    col   = [_=] | (/[LRCNAS^]/i >set_key_letter column_modifier);
    col_0 = col - /S.*/i;
    line = OWS vbars? OWS col_0 OWS (vbars? OWS col)* OWS vbars? OWS;
    format = (line -- '^') ((EOL | ',') line)*;

    #action not_sep { fc != tab_separator }
    action is_sep { fc == tab_separator }
    #action end_row { }

    #action buf { }
    #action next { }

    #text_block = "T{" EOL "T}" | "T{" EOL any* :>> (EOL "T}");
    #special = ("\\^" | "\\_" | ("\\R" any));

    #NEOL = '\\' EOL;

    ## TODO PITA PITA PITA
    #command = '.' ([^0-9] any*)? - (".T&" | ".TE");

    #penis = any* - (special | text_block | command | [_=] | ".T&" | ".TE");

    #entry = text_block | special | penis;
    #items = entry ((any when is_sep) entry)*;
    #data_line = [_=] | command | items;

    ##penis = [^\r\n] | ('\\' EOL); 
    ##row =                  penis* when !is_sep
    ##      (/./ when is_sep penis* when !is_sep)* EOL;
    ## TODO PITA
    ## XXX What happens when tab(\)?

    #data = (data_line EOL)*;

    data = 
    start: ( '.'  -> dot
           | [_=] -> fhline
           | EOL  -> start
           | '\\' -> bslash
           | 'T'  -> block1
           ),
    dot: ( 'T'   -> dott
         | [0-9] -> item
         ),
    dott: ( '&' -> dottand
          | 'E' -> dotte
          ) 
    dottand: ( EOL part -> final
             ),
    dotte: ( EOL -> final
           ),
    fhline: ( EOL -> start
            ),
    bslash: ( [_^] -> special
            | ('R' any (any when is_sep)) -> item
            ),
    special: ( EOL -> start
             | (any when is_sep) -> item
             | empty),
    block1: ( '{' -> block2
           ),
    block2: ( EOL ("T}" | (any* :>> (EOL "T}")) (any when is_sep)) -> item
           | !EOL -> item
           ),
    item: empty;
    #text_block = "T{" EOL "T}" | "T{" EOL any* :>> (EOL "T}");


    part = format '.' EOL data;
    table = ".TS" (RWS 'H')? EOL (options ';' EOL)? part;
    #(".T&" EOL part) ".TE" EOL;
    main := table;
    # Just one for now, for the sake of testing
    # It may become part of a larger machine or something!
    # TODO .TH
    # TODO error action for error reporting
}%%

%% write data;

int main(void)
{
    int cs;

    return 0;
}
