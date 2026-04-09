#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <string.h>

// Thanks Simon Tatham.
// 'https://www.chiark.greenend.org.uk/~sgtatham/coroutines.html

#define crBegin switch(state) { case 0:
#define crFinish } (void)0

// Unused
#if 0
#define crYield do { state=__LINE__; return; case __LINE__:; } while (0)
#endif

// My extensions
#define crSaveSend do { s_send=__LINE__; case __LINE__:; } while (0)
#define crYieldSend do { s_send=__LINE__; return; case __LINE__:; } while (0)
#define crYieldRecv do { s_recv=__LINE__; return; case __LINE__:; } while (0)

static unsigned void *acme_current = NULL;
static size_t acme_remnant;
static void (*acme_xgh_http_client_body_init)(void);
static void (*acme_xgh_http_client_body_recv)(unsigned char *p, unsigned char *pe, unsigned char *eof);

#define LIT_BASE(...) \
  static unsigned char fwded[] = __VA_ARGS__; \
  current = fwded; \
  remnant = sizeof fwded - 1; \

#define LITS(...) do { \
  LIT_BASE(__VA_ARGS__) \
  crSaveSend; \
  assert(!remnant); \
} while (0)

#define LITY(...) if (ACME_SEND == ev) { \
  LIT_BASE(__VA_ARGS__) \
  crYieldSend; \
  assert(!remnant); \
} else if (ACME_SUM == ev) { \
  length_numbah += sizeof (__VA_ARGS__);
} else (void)0

#define STR(...) if (ACME_SEND == ev) { \
  current = (__VA_ARGS__); \
  remnant = strlen(current); \
  crYieldSend; \
  assert(!remnant); \
} else if (ACME_SUM == ev) { \
  length_numbah += strlen(__VA_ARGS__);
} else (void)0

#define PARSE(...) do { s_recv = __VA_ARGS__; crYieldRecv; } while (0)

#define LENGTH_NOW do { s_sum = __LINE__; acme_sum(); case __LINE__:; } while (0)

#define ESUM if (ACME_SUM == ev) { return; } else (void)0

#define ACME_XS(X) \
X(init, INIT, s_recv = s_send = state = 0) \
X(recv, RECV, state = s_recv) \
X(send, SEND, state = s_send) \
X(sum , SUM , state = s_sum )

#define AS_2(A, B, C) ACME_##B,
#define AS_DECO(A, B, C) acme_##A(void) { acme(ACME_##B); }
#define AS_ATT(A, B, C) case ACME_##B: C; break;

enum acme { ACME_XS(AS_2) };

ACME_XS(AS_DECO)

static void acme(enum acme ev)
{
    unsigned char length[20];
    static int length_numbah;

    bool is_recv, is_send;

    // X macros? TODO
    static int s_recv, s_send, s_sum;
    int state;

    switch (ev) { ACME_XS(AS_ATT) default: assert(!"fuck"); break; }

    crBegin;

    // Crypto startup.

    LITS(
        "GET /dir HTTP/1.1\r\n"
        ACME_SOME_FIELDS
        "Connection: keep-alive\r\n"
        "\r\n"
    );

    PARSE(acme_directory);

    if (nonce)
        printf("Already has nonce: %s\n", nonce);
    else
    {
        LITS("HEAD /");
        if (ACME_RECV == ev)
        {
            STR(nnonce_dir);
            LITY(
                " HTTP/1.1\r\n"
                ACME_SOME_FIELDS
                "Connection: keep-alive\r\n"
                "\r\n"
            );
        }

        PARSE(NULL);

        printf("Got nonce: %s\n", nonce);
    }

    LITS("GET /");
    STR(account_dir);
    LIT(
        " HTTP/1.1\r\n"
        ACME_SOME_FIELDS
        "Connection: keep-live\r\n"
        "Content-Length: "
    );
    LENGTH_NOW;
    LIT("\r\n\r\n");
    SLIT(
        "{\"termsOfServiceAgreed\":true,\"contact\":\"" ACME_CONTACT "\"}"
    );
    ESUM;

    PARSE(acme_account);

    crFinish;
}

unsigned char * acme_send_buf(size_t *len)
{
    if (!remnant)
        acme_send();

    if (current)
        *len = remnant;

    return remnant ? current : NULL;
}

void acme_send_ack(size_t len)
{
    assert(len <= remnant);
    remnant -= len;
    current += len;
}
