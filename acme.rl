static unsigned char *buffed;
#define ENDPOINT_MAX 200
static unsigned char account[ENDPOINT_MAX];
static unsigned char nnonce[ENDPOINT_MAX];
static int prog;

%%{
    machine acme_directory;
    alphtype unsigned char;

    include json "json.rl";

    action buf
    {
        if (prog > ENDPOINT_MAX-2)
            DIE(20);
        buffed[prog++];
    }
    action buf_zero { prog = 0; }
    action buf_account { buffed = account; }
    action buf_nnonce  { buffed = nnonce; }
    action buf_end { buffed[prog] = '\0'; }

    #action ensure_asa_init { /*TODO*/ }
    #action ensure_asa { }
    #action ensure_asa_end { }

    action die { return ACME_ERROR; }

    # TODO if it more complex than that, I will KMS
    #domain2 = alnum+ ('.' alnum+)*;
    #domain = domain2 >ensure_asa_init $ensure_asa %ensure_asa_end;
    domain = "pebble"i; # TODO configure using m4... or allow config
    url = "https://"i domain '/' alnum+ $buf %buf_end;

    meta_field = empty #'"caaIdentities"'           %2 gc '[' url (ws ',' ws url)* ws ']'
               | '"externalAccountRequired"' %2 gc "false" # ("false" | "true")
               #| '"profiles"'                %2 gc profile
               #| '"termsOfService"'          %2 gc url
	       | string %1 gc value6
               ;

    meta_fields = meta_field (ws ',' ws meta_field)*;

    resource_field = empty #'"keyChange"'   %2 gc url
                   | '"meta"'        %2 gc '{' ws meta_fields ws '}'
                   | '"newAccount"'  %2 gc url >buf_zero >buf_account
                   | '"newNonce"'    %2 gc url >buf_zero >buf_nnonce
                   #| '"newOrder"'    %2 gc url
                   #| '"renewalInfo"' %2 gc url
                   #| '"revokeCert"'  %2 gc url
                   | '"newAuthz"' @die
                   | string %1 gc value6
                   ;

    resource_fields = resource_field (ws ',' ws resource_field)*;

    main2 = ws '{' ws resource_fields ws '}' ws;
    main := main2 $!die;

    #main := (ws '{' ws field (ws ',' ws field)* ws '}' ws); #$!die;

    #profile_field = string gc string;

    #profile = '{' ws profile_field (ws ',' ws profile_field)* ws '}';

    write data noerror nofinal noentry; 
}%%

static int cs;
static long usv; // TODO Make this optional with macro? No harm either..

void acme_init(void)
{
    %% write init;
}

enum acme { ACME_PARSING, ACME_ERROR, ACME_CORRECT }
acme(unsigned char *p, size_t len)
{
    unsigned char *pe = p + len, *eof = NULL;

    #define DIE(X) return (X)
    #define PARSE(...)

    %% write exec;

    if (cs < %%{ write first_final; }%%)
    	return ACME_PARSING;
    else
    {
        printf("newAccount endpoint: %s\n", account);
        printf("newNonce endpoint: %s\n", nnonce);
        return ACME_CORRECT;
    }
}

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
