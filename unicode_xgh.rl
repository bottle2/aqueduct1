%%{
    machine unicode_xgh;
    alphtype unsigned char;

    # Documentation for user-defined macros
    # UNICODE_XGH_EFFECT TODO
    # UNICODE_XGH_PARSE  TODO
    # UNICODE_XGH_USV    Unicode Scalar Value.
    #                    Both long and int_least32_t are fine.
    #                    Needs 21 bits to store a positive integer
    #                    value.
    #                    TODO
    # UNICODE_XGH_DEBUG  TODO

    action unicode_xgh_ill_formed {
        // TODO Since which edition? Be more specific than "input".
        UNICODE_XGH_DEBUG("Ill-formed input is a fatal error.\n")
        return 1;
    }

    action unicode_xgh_push
    {
        UNICODE_XGH_EFFECT(UNICODE_XGH_PARSE);
    }

    action unicode_xgh_utf8_1_ini
    {
        assert(0 == (fc & 0x80));
        UNICODE_XGH_EFFECT(UNICODE_XGH_USV = fc);
    }
    action unicode_xgh_utf8_2_ini
    {
        assert(0xC0 == (fc & 0xE0));
        UNICODE_XGH_EFFECT(UNICODE_XGH_USV = fc & 0x1F);
    }
    action unicode_xgh_utf8_3_ini
    {
        assert(0xE0 == (fc & 0xF0));
        UNICODE_XGH_EFFECT(UNICODE_XGH_USV = fc & 0xF);
    }
    action unicode_xgh_utf8_4_ini
    {
        assert(0xF0 == (fc & 0xF8));
        UNICODE_XGH_EFFECT(UNICODE_XGH_USV = fc & 7);
    }
    action unicode_xgh_utf8_a {
        assert(0x80 == (fc & 0xC0));
        UNICODE_XGH_EFFECT(
            UNICODE_XGH_USV = (UNICODE_XGH_USV << 6) + (0x3F & fc)
        );
    }

    # But... we could simplify! NO. We don't simplify. Ragel does. And the compiler.

    unicode_xgh_utf8_fr = 0x80..0xBF;

    unicode_xgh_utf8_1 = 0..0x7f >unicode_xgh_utf8_1_ini;

    unicode_xgh_utf8_2 = 0xC2..0xDF >unicode_xgh_utf8_2_ini unicode_xgh_utf8_fr @unicode_xgh_utf8_a;
    unicode_xgh_utf8_3 = 0xE0       >unicode_xgh_utf8_3_ini (0xA0..0xFB unicode_xgh_utf8_fr) $unicode_xgh_utf8_a
                       | 0xE1..0xEC >unicode_xgh_utf8_3_ini (unicode_xgh_utf8_fr{2}) $unicode_xgh_utf8_a
                       | 0xED       >unicode_xgh_utf8_3_ini (0x80..0x9F unicode_xgh_utf8_fr) $unicode_xgh_utf8_a
                       | 0xEE..0xEF >unicode_xgh_utf8_3_ini (unicode_xgh_utf8_fr{2}) $unicode_xgh_utf8_a
                       ;
    unicode_xgh_utf8_4 = 0xF0       >unicode_xgh_utf8_4_ini (0x90..0xBF unicode_xgh_utf8_fr{2}) $unicode_xgh_utf8_a
                       | 0xF1..0xF3 >unicode_xgh_utf8_4_ini (unicode_xgh_utf8_fr{3}) $unicode_xgh_utf8_a
                       | 0xF4       >unicode_xgh_utf8_4_ini (0x80..0x8F unicode_xgh_utf8_fr{2}) $unicode_xgh_utf8_a
                       ;

    #Visualization kludge
    #utf8_1 = 'a' >utf8_1_ini;
    #utf8_2 = 'b' >utf8_2_ini 'r' $utf8_a;
    #utf8_3 = 'c' >utf8_3_ini 'rr' $utf8_a;
    #utf8_4 = 'd' >utf8_4_ini 'rrr' $utf8_a;

    unicode_xgh_utf8 = ( unicode_xgh_utf8_1
                       | unicode_xgh_utf8_2
                       | unicode_xgh_utf8_3
                       | unicode_xgh_utf8_4
                       ) @unicode_xgh_push;

    #main := utf8* $!ill_formed;

    #write data noerror nofinal noentry;
    #write init;

    #write exec;
}%%
