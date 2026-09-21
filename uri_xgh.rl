%%{
  machine uri_xgh;
  alphtype unsigned char;

  ALPHA = [a-zA-Z];
  DIGIT = [0-9];
  HEXDIG = DIGIT | [A-F];

  scheme = ALPHA *(ALPHA | DIGIT | [\-+.]);

  unreserved = ALPHA | DIGIT | [\-._~];
  gen_delims = [:/?#\[\]@];
  sub_delims = [!$&'()*+,;=];
  reserved = gen_delims | sub_delims;

  pct_encoded = "%" HEXDIG HEXDIG;

  userinfo = (unreserved | pct_encoded | sub_delims | ":");

  IPvFuture = "v" HEXDIG+ "." (unreserved | sub_delims | ":")+;

  dec_octet = DIGIT
            | [1-9] DIGIT
            | "2" DIGIT{2}
            | "25" [0-5]
            ;

  IPv4address = dec_octet "." dec_octet "." dec_octet "." dec_octet;

  h16 = HEXDIG{1,4};
  ls32 = (h16 ":" h16) | IPv4address;

  IPv6address  =                               ( h16 ":" ){6} ls32
               |                          "::" ( h16 ":" ){5} ls32
               | (                 h16 )? "::" ( h16 ":" ){4} ls32
               | ( ( h16 ":" ){,1} h16 )? "::" ( h16 ":" ){3} ls32
               | ( ( h16 ":" ){,2} h16 )? "::" ( h16 ":" ){2} ls32
               | ( ( h16 ":" ){,3} h16 )? "::"   h16 ":"      ls32
               | ( ( h16 ":" ){,4} h16 )? "::"                ls32
               | ( ( h16 ":" ){,5} h16 )? "::"                h16
               | ( ( h16 ":" ){,6} h16 )? "::"
               ;

  IP_literal = "[" (IPv6address | IPvFuture) "]";

  reg_name = (unreserved | pct_encoded | sub_delims)*;

  host = IP_literal | IPv4address | reg_name;

  port = DIGIT*;

  authority = (userinfo "@")? host (":" port)?;

  pchar = unreserved | pct_encoded | sub_delims | [:@];

  segment = pchar*;
  segment_nz = pchar+;
  segment_nz_nc = (unreserved | pct_encoded | sub_delims | "@")+;

  path_abempty = ("/" segment)*;
  path_absolute = "/" (segment_nz ("/" segment)*)?;
  path_noscheme = segment_nz_nc ("/" segment)*;
  path_rootless = segment_nz ("/" segment)*;
  path_empty = zlen;

  hier_part = "//" authority path_abempty
            | path_absolute
            | path_rootless
            | path_empty;

  relative_part = "//" authority path_abempty
                | path_absolute
                | path_noscheme
                | path_empty;

  query    = (pchar | [/?])*;
  fragment = (pchar | [/?])*;

  relative_ref = relative_part ("?" query)? ("#" fragment)?;

  URI = scheme ":" hier_part ("?" query)? ("#" fragment)?;

  action inc_exter { n_exter++; }
  action inc_int { n_int++; }

  URI_reference = URI %inc_exter | relative_ref %inc_int;

  absolute_URI = scheme ":" hier_part ("?" query);

  action die
  {
    fprintf(
      stderr, "%d:%d: %d -> '%c'\n", lineno, colno, fcurs, fc
    );
    return 1;
  }

  main2 = space? URI_reference (space+ URI_reference)* space?;
  main := main2 $!die;
}%%

// https://datatracker.ietf.org/doc/html/rfc3986#appendix-A

#include <stdio.h>
#include <stddef.h>

int main(void)
{
  int cs, c, lineno = -1, colno = -1;
  int n_exter = 0, n_int = 0;

  %% write data noerror nofinal;
  %% write init;

  unsigned char prev, *p, *pe, *eof;

  if ((c = getchar()) != EOF) do
  {
    prev = c;
    c = getchar();
    p = &prev;
    pe = p + 1;
    eof = EOF == c ? p : NULL;

    %% write exec;
  }
  while (c != EOF);

  printf("define(`XGH_STATS___N_TOT',`%d')dnl\n", n_exter + n_int);
  printf("define(`XGH_STATS___N_EXTER',`%d')dnl\n", n_exter);
  printf("define(`XGH_STATS___N_INT',`%d')dnl\n", n_int);

  return 0;
}
