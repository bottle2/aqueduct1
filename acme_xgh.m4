define(`X',`dnl
%% machine acme_xgh_resource_$1;

void acme_xgh_resource_$1_init(void)
{
    %% write init;
}

bool acme_xgh_resource_$1_eof(void)
{
    return acme_xgh_resource_cs >= %%{ write first_final; }%%;
}

enum acme_xgh_error acme_xgh_resource_$1_recv(unsigned char *p, unsigned char *pe, unsigned char *eof)
{
    %% write exec;
    return ACME_XGH_ERROR_NONE;
}
')dnl
X(`directory')
X(`account')`'dnl
