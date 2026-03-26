#include <stddef.h>

%%{
    machine json;
    alphtype unsigned char;

    # ACME guarantees UTF-8, although JSON might be encoded in UTF-16
    # or UTF-32, which requires guessing analyzing the first four
    # octets.
    # https://datatracker.ietf.org/doc/html/rfc8555/#section-5
    include unicode "unicode.rl";

    ws = (0x20 | 0xA | 0xD | 0x9)*;
    #ws = zlen;

    character = (utf8) -- 0..31 -- '"' -- '\\'
              | '\\' (["\\/bfnrt] | 'u' xdigit{4});
    characters = character*;
    #characters = 'a'*;

    string = '"' characters '"';
    #string = 's';

    onenine = '1'..'9';
    integer = '-'? (digit | onenine digit+);
    fraction = ('.' digit+)?;
    exponent = ('E'i [\-+]? digit+)?;
    number = integer fraction exponent;
    #number = '1'+;

    # Gay colon
    gc = ws ':' ws;

    # !in_object means "in array"
    action in_obj { 1 == (le_stack & 1) }
    #action in_array { }
    action deepen
    {
        if (le_stack > (1 << 30))
            DIE(11);
        le_stack = (le_stack << 1) | ('{' == fc);
    }
    action pop {
        if (is_debug)
            printf("pop(%b->%b)",le_stack, le_stack >> 1);
        assert(le_stack != 0);
        if (1 == le_stack)
            DIE(12);
        le_stack >>= 1;
    }
    action overridden { 2 == le_stack || 3 == le_stack }
    #action fix { }
    action save { } # TODO what did I mean by this

    value4 = string | number | "true" | "false" | "null";

    value2 = start: ( '{' @deepen -> object_member
                    | '[' @deepen -> array_element
                    | value4 >(pri,1) -> cont
                    )
           , cont: ( ws ( ',' when  in_obj ws string gc -> start
                        | ',' when !in_obj ws -> start
                        | '}' when  in_obj when !overridden @pop -> cont
                        | ']' when !in_obj when !overridden @pop -> cont
                        | '}' when  in_obj when  overridden @pop -> final
                        | ']' when !in_obj when  overridden @pop -> final
                        )
                   )
           , object_member: (ws ( '}' when !overridden @pop -> cont 
                                | '}' when  overridden @pop -> final
                                | string gc -> start
                                )
                            )
           , array_element: (ws ( ']' when !overridden @pop -> cont 
                                | ']' when  overridden @pop -> final
                                | zlen -> start
                                )
                            )
           ;
}%%

//%%{
//    machine acme;
//    alphtype unsigned char;
//
//    include "json";
//
//    url = string;
//
//    profile_field = string gc string;
//
//    profile = '{' ws profile_field (ws ',' ws profile_field)* ws '}';
//
//    meta_field = '"caaIdentities"'           gc '[' url (ws ',' ws url)* ws ']'
//               | '"externalAccountRequired"' gc ("false" | "true")
//               | '"profiles"'                gc profile
//               | '"termsOfService"'          gc url
//               ;
//
//    meta = '{' ws meta_field (ws ',' ws meta_field)* ws '}';
//
//    known_field = '"keyChange"'   gc url
//                | '"meta"'        gc meta
//                | '"newAccount"'  gc url
//                | '"newNonce"'    gc url
//                | '"newOrder"'    gc url
//                | '"renewalInfo"' gc url
//                | '"revokeCert"'  gc url
//                ;
//
//    #element = ws value ws;
//    #elements = element (',' element)*;
//
//    #member = ws string ws ':' element;
//    #members = member (',' member)*;
//
//    #object = '{' (ws | members) '}';
//    #array = '[' (ws | element+) ']';
//
//    #object2 = '{' (ws | members) '}';
//
//    #value = object | array | string | number | "true" | "false" | "null";
//
//    # TODO what the fuck is below
//
//    value3 = zlen;
//
//    element = value3 %fix ws;
//
//    any_field = string gc element;
//
//    field = known_field | any_field;
//
//    action die { return ACME_ERROR; }
//
//    #main := (ws '{' ws field (ws ',' ws field)* ws '}' ws); #$!die;
//
//    write data noerror nofinal noentry; 
//}%%

#if 0
static cs;

void acme_init(void)
{
    //%% write init;
}

enum acme { ACME_PARSING, ACME_ERROR, ACME_CORRECT }
acme(unsigned char *p, size_t len)
{
    unsigned char *pe = p + len, *eof = NULL;
    //%% write exec;

    return (cs >= /*%%{ write first_final; }%%*/) ? 2 : 0;
}
#endif

#if 0
{
   "keyChange": "https://pebble/rollover-account-key",
   "meta": {
      "caaIdentities": [
         "pebble.letsencrypt.org"
      ],
      "externalAccountRequired": false,
      "profiles": {
         "default": "The profile you know and love",
         "shortlived": "A short-lived cert profile, without actual enforcement"
      },
      "termsOfService": "data:text/plain,Do%20what%20thou%20wilt"
   },
   "newAccount": "https://pebble/sign-me-up",
   "newNonce": "https://pebble/nonce-plz",
   "newOrder": "https://pebble/order-plz",
   "renewalInfo": "https://pebble/draft-ietf-acme-ari-03/renewalInfo",
   "revokeCert": "https://pebble/revoke-cert"
}
#endif

#ifdef IS_MAIN

#include <stdbool.h>
#include <stdint.h>
#include <assert.h>
#include <stdio.h>

static bool is_debug = false;

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

    uint_least32_t le_stack = 1;
    long usv;

    #define DIE(X) return (X)
    #define PARSE(...)

    int cs;

    %%{
        machine json_generic;
        alphtype unsigned char;

        include json;

        action die { { if (is_debug) printf("die(%d)", fcurs); DIE(10); } }

        action idiocy { if (is_debug) printf("%d(%c)", fcurs, fc); }

        main := (ws (value4 >(pri,2) | value2) ws) $idiocy $!die;

        write data noerror nofinal noentry;
        write init;
        write exec;
    }%%

    return 0;
}
#endif
