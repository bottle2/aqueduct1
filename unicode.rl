    long usv; // Unicode Scalar Value

%%{
    machine unicode;
    alphtype unsigned char;

    action ill_formed {
        // TODO Since which edition? Be more specific than "input".
        fprintf(stderr, "Ill-formed input is a fatal error.\n");
        return 1;
    }

    action push { PARSE(usv); }

    action utf8_1_ini { assert(   0 == (fc & 0x80)); usv = fc; }
    action utf8_2_ini { assert(0xC0 == (fc & 0xE0)); usv = fc & 0x1F; }
    action utf8_3_ini { assert(0xE0 == (fc & 0xF0)); usv = fc & 0xF; }
    action utf8_4_ini { assert(0xF0 == (fc & 0xF8)); usv = fc & 7; }
    action utf8_a {
        assert(0x80 == (fc & 0xC0));
        usv = (usv << 6) + (0x3F & fc);
    }

    # But... we could simplify! NO. We don't simplify. Ragel does. And the compiler.

    utf8_fr = 0x80..0xBF;
    utf8_1 =    0..0x7f >utf8_1_ini;
    utf8_2 = 0xC2..0xDF >utf8_2_ini utf8_fr @utf8_a;
    utf8_3 = 0xE0       >utf8_3_ini (0xA0..0xFB utf8_fr) $utf8_a
           | 0xE1..0xEC >utf8_3_ini (utf8_fr    utf8_fr) $utf8_a
           | 0xED       >utf8_3_ini (0x80..0x9F utf8_fr) $utf8_a
           | 0xEE..0xEF >utf8_3_ini (utf8_fr    utf8_fr) $utf8_a
           ;
    utf8_4 = 0xF0       >utf8_4_ini (0x90..0xBF utf8_fr utf8_fr) $utf8_a
           | 0xF1..0xF3 >utf8_4_ini (utf8_fr    utf8_fr utf8_fr) $utf8_a
           | 0xF4       >utf8_4_ini (0x80..0x8F utf8_fr utf8_fr) $utf8_a
           ;

    #Visualization kludge
    #utf8_1 = 'a' >utf8_1_ini;
    #utf8_2 = 'b' >utf8_2_ini 'r' $utf8_a;
    #utf8_3 = 'c' >utf8_3_ini 'rr' $utf8_a;
    #utf8_4 = 'd' >utf8_4_ini 'rrr' $utf8_a;

    utf8 = (utf8_1 | utf8_2 | utf8_3 | utf8_4) @push;

    #main := utf8* $!ill_formed;

    #write data noerror nofinal noentry;
    #write init;

    #write exec;
}%%
