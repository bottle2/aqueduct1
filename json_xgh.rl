%%{
    machine json_xgh;
    alphtype unsigned char;

    # Documentation for user-defined macros
    # JSON_XGH_DIE       TODO
    # JSON_XGH_DEBUG     TODO
    # JSON_XGH_STACK     TODO. Lvalue. Initial value must be 1
    # JSON_XGH_DEPTH_MAX TODO

    # ACME guarantees UTF-8, although JSON might be encoded in UTF-16
    # or UTF-32, which requires guessing analyzing the first four
    # octets.
    # https://datatracker.ietf.org/doc/html/rfc8555/#section-5
    include unicode_xgh "unicode_xgh.rl";

    json_xgh_ws = (0x20 | 0xA | 0xD | 0x9)*;
    #ws = zlen;

    json_xgh_character = unicode_xgh_utf8 -- 0..31 -- '"' -- '\\'
                       | '\\' (["\\/bfnrt] | 'u' xdigit{4});
    json_xgh_characters = json_xgh_character*;
    #characters = 'a'*;

    json_xgh_string = '"' json_xgh_characters '"';
    #string = 's';

    json_xgh_onenine = '1'..'9';
    json_xgh_integer = '-'? (digit | json_xgh_onenine digit+);
    json_xgh_fraction = ('.' digit+)?;
    json_xgh_exponent = ('E'i [\-+]? digit+)?;
    json_xgh_number = json_xgh_integer
                      json_xgh_fraction
                      json_xgh_exponent;
    #number = '1'+;

    # Gay colon
    json_xgh_gc = json_xgh_ws ':' json_xgh_ws;

    # !in_object means "in array"
    action json_xgh_in_obj { 1 == (JSON_XGH_STACK & 1) }
    #action in_array { }
    action json_xgh_deepen
    {
        if (JSON_XGH_STACK > (1 << JSON_XGH_DEPTH_MAX))
            JSON_XGH_DIE(11);
        JSON_XGH_STACK = (JSON_XGH_STACK << 1) | ('{' == fc);
    }
    action json_xgh_pop {
        JSON_XGH_DEBUG("pop(%b->%b)",JSON_XGH_STACK, JSON_XGH_STACK >> 1);
        assert(JSON_XGH_STACK != 0);
        if (1 == JSON_XGH_STACK)
            JSON_XGH_DIE(12);
        JSON_XGH_STACK >>= 1;
    }
    action json_xgh_overridden
    {
        2 == JSON_XGH_STACK || 3 == JSON_XGH_STACK
    }
    #action fix { }
    action json_xgh_save { } # TODO what did I mean by this

    json_xgh_value4 = json_xgh_string
                    | json_xgh_number
                    | "true" | "false" | "null";

    json_xgh_value2
    = start: ( '{' @json_xgh_deepen -> object_member
             | '[' @json_xgh_deepen -> array_element
             | json_xgh_value4 >(pri,1) -> cont
             )
    , cont: ( json_xgh_ws ( ',' when  json_xgh_in_obj json_xgh_ws json_xgh_string json_xgh_gc -> start
                 | ',' when !json_xgh_in_obj json_xgh_ws -> start
                 | '}' when  json_xgh_in_obj when !json_xgh_overridden @json_xgh_pop -> cont
                 | ']' when !json_xgh_in_obj when !json_xgh_overridden @json_xgh_pop -> cont
                 | '}' when  json_xgh_in_obj when  json_xgh_overridden @json_xgh_pop -> final
                 | ']' when !json_xgh_in_obj when  json_xgh_overridden @json_xgh_pop -> final
                 )
            )
    , object_member: ( json_xgh_ws ( '}' when !json_xgh_overridden @json_xgh_pop -> cont 
                                   | '}' when  json_xgh_overridden @json_xgh_pop -> final
                                   | json_xgh_string json_xgh_gc -> start
                                   )
                     )
    , array_element: ( json_xgh_ws ( ']' when !json_xgh_overridden @json_xgh_pop -> cont 
                                   | ']' when  json_xgh_overridden @json_xgh_pop -> final
                                   | zlen -> start
                                   )
                     )
    ;

    json_xgh_value6 = json_xgh_value4 >(json_xgh_pri,2) | json_xgh_value2;
}%%

#ifdef IS_JSON_XGH_MAIN

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <assert.h>
#include <stdio.h>

#define JSON_XGH_DEBUG(...) //printf(__VA_ARGS__)
#define JSON_XGH_DIE(X) return (X)
#define JSON_XGH_STACK stack
#define JSON_XGH_DEPTH_MAX 30
#define UNICODE_XGH_EFFECT(...) //__VA_ARGS__
#define UNICODE_XGH_PARSE

int main(int argc, char *argv[])
{
    if (argc < 2)
        return 3;
    unsigned char *p;
    unsigned char *pe;
    {
        FILE *file = fopen(argv[1], "rb");
        static unsigned char text[50000];
        pe = text + fread(p = text, 1, sizeof text, file);
        bool die = ferror(file) || !feof(file);
        (void)fclose(file);
        if (die)
            return 2;
    }
    unsigned char *eof = pe;

    uint_least32_t stack = 1;

    int cs;

    %%{
        machine json_xgh_generic;
        alphtype unsigned char;

        include json_xgh;

        action die {
            JSON_XGH_DEBUG("die(%d)", fcurs);
            JSON_XGH_DIE(10);
        }

        action idiocy { JSON_XGH_DEBUG("%d(%c)", fcurs, fc); }

        main := (json_xgh_ws json_xgh_value6 json_xgh_ws) $idiocy $!die;

        write data noerror nofinal noentry;
        write init;
        write exec;
    }%%

    return 0;
}
#endif
