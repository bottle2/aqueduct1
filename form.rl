#include <stdbool.h>
#include <stdint.h>

#include <emscripten.h>

#include "xlsxwriter.h"
#include "form.h"

#define BUILD_VER v1

#define EM_JS2(...) EM_JS(__VA_ARGS__)

#define VOID
#define PRM(T,N) , T N
#define USE_PRM(T,N) +' ('+N+')'
#define USE_VOID
#define X(ID,P) EM_JS2(void, report_##ID##_gay, (int rowi, int coli, __externref_t cell P), { \
    document.getElementById(erro_##ID##_list).insertAdjacentHTML('beforeend','<li><button onclick=\x34gay_goto('+all_cells.length+')\x34>'+'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[coli] +(rowi+1) USE_##P +'</button></li>'); \
    all_cells.push(cell); });
FORM_ERROR_XS
#undef X
#undef USE_PRM
#undef USE_VOID
#undef PRM
#undef VOID

#define X(ID,P) int count_##ID;
FORM_ERROR_XS
#undef X

// PEAK indirection
#define VOID
#define PRM(T,N) , T N
#define USE_VOID
#define USE_PRM(T,N) , N
#define X(ID,P) static inline void report_##ID(int rowi, int coli, __externref_t cell P) { count_##ID++; report_##ID##_gay(rowi, coli, cell USE_##P); }
FORM_ERROR_XS
#undef X
#undef USE_PRM
#undef USE_VOID
#undef PRM
#undef VOID

EMSCRIPTEN_KEEPALIVE bool validate_car_plate(lxw_worksheet *worksheet, char *p, int i, int j, __externref_t inputt)
{
    return LXW_NO_ERROR != worksheet_write_string(worksheet, i, j, p, NULL);
}

#if 0
int validate_car_plate(char *cp, struct )
{
    action push_symb
    {
    }

    action on_err {
        return 1;
    }

    %%{
        machine car_plate;
        main := (std_1990_2018 -- ([a-z]i{3} "0000")) | std_mercosul 
    }%%
}

EM_JS(char *, get_value, (__externref_t input), {
    return stringToNewUTF8(input.value);
});
EM_JS(void, set_value, (__externref_t input, char *valu), {
    input.value = UTF8ToString(valu);
});

EMSCRIPTEN_KEEPALIVE money(__externref_t input, int phase)
{
    char *val = get_value(input), *p = val;
    int dec=0, frac=0;
    %%{
        action dec { dec=dec*10+fc; }
        action frac { frac=frac*10+fc; }
        action abrupt { fbreak; }

        numbah = ('R'i '$'?)? any* ([.'] | (digit) >dec )* (','
        main := any* :> numbah? %abrupt :>> any*;
    }%%
    free(val);
    frac < 100;
    sprintf("%d,%02d);
    set_value(input, 
}
#endif

EM_JS2(void, complain, (int nl, char *msg), {
    complain_bad(`BUILD_VER`,`__FILE__`,nl,UTF8ToString(msg));
});

// https://stackoverflow.com/questions/73508035/convert-binary-data-to-download
EM_JS(void, le_dump, (char const *start, char const *end), {
    const data = HEAP8.subarray(start, end);
    const fil = new File([data], 'trajetos.xlsx', {
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    });
    const url = URL.createObjectURL(fil);
    const a = document.createElement('a');
    a.href = url;
    a.download = fil.name;
    a.click();
    URL.revokeObjectURL(url);
});

EMSCRIPTEN_KEEPALIVE bool push_money(lxw_worksheet *worksheet, char *p, int i, int j, __externref_t inputt)
{
    return LXW_NO_ERROR != worksheet_write_string(worksheet, i, j, p, NULL);

#if 0
    int_least64_t entirety = 0;

    // Error reporting related
    int comma_count = 0;
    int significant_length = 0;
    int decimal_length = 0;
    bool is_neg = false;
    bool illegal[256] = {0};

#if 0
    __externref_t error_builder = UTF8ToString("");
#endif

#if 0
    %%{
        # Extreme Go Horse
        action control { if (sig) fbreak; }
        digi = [0-9] | ['.];
        numbeh = '1';
        main := '2';
        write exec noend;
    }%%

    #endif

    return true;
#endif
}

EMSCRIPTEN_KEEPALIVE bool directt(lxw_worksheet *worksheet, char *p, int i, int j, __externref_t inputt)
{
    return LXW_NO_ERROR != worksheet_write_string(worksheet, i, j, p, NULL);
}

EMSCRIPTEN_KEEPALIVE bool le_dist(lxw_worksheet *worksheet, char *p, int i, int j, __externref_t inputt)
{
    return LXW_NO_ERROR != worksheet_write_string(worksheet, i, j, p, NULL);
}

#define X(N,T) { \
const inputtt = cells[j].firstElementChild; \
const ptr = stringToNewUTF8((inputtt.value+"").trim()); \
const ret = (_##T(worksheet, ptr, total, j, inputtt)); j++; _free(ptr); if (ret) return true; }

EM_JS2(int, process_table, (lxw_worksheet *worksheet), {
    const rows = document.getElementById('table').children;
    for (let i = 0, total = 0; i < rows.length-1; i++)
    {
        if (roempty(rows[i]))
            continue;
        total++;
        const cells = rows[i].children;

        let j = 0;
        cells[j++].innerText = total;
        FORM_XS
    }

    return false;
});
#undef X

EMSCRIPTEN_KEEPALIVE void le_export(void)
{
    #define X(ID,P) count_##ID = 0;
    FORM_ERROR_XS
    #undef X

    char const *output_buffer;
    size_t output_buffer_size; 

    lxw_workbook_options options = {
        .output_buffer = &output_buffer,
        .output_buffer_size = &output_buffer_size,
        .constant_memory = LXW_FALSE,
        .tmpdir = NULL,
        .use_zip64 = LXW_FALSE
    };

    lxw_workbook *workbook = workbook_new_opt(NULL, &options);
    lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);

    {
        int i = 0;
        #define X(N,T) worksheet_write_string(worksheet, 0, i++, (N), NULL);
        FORM_XS
        #undef X
    }

    bool failed = process_table(worksheet);

    lxw_error error = workbook_close(workbook);

    if (error)
        complain(__LINE__,lxw_strerror(error));
    else
    {
        if (!failed)
            le_dump(output_buffer, output_buffer+output_buffer_size);
        free((void *)output_buffer);
    }
}
