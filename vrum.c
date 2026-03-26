#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <uv.h>
#include <bearssl.h>

#include "my_certs.c"

#include "http_client.c"
#include "acme.c"

#define IP "0.0.0.0"
#define HOST "www.howsmyssl.com"
#define PORT 14000
//#define HOST "man7.org"

#ifndef MIN
#define MIN(A,B) ((A) < (B) ? (A) : (B))
#endif

static uv_loop_t *loop = NULL;

#define TRY_UV(...) if ((r = (__VA_ARGS__))) \
{ fprintf(stderr, "%d: %s\n", __LINE__, uv_strerror(r)); \
exit(EXIT_FAILURE); } else (void)0

#define ONCE(...) { static int once = 0; if (!once++) { __VA_ARGS__ } } (void)0

struct funny_writer
{
    uv_write_t base;
    uv_buf_t holder;
    char bu[];
};

static void my_alloc_cb(uv_handle_t* handle, size_t suggested_size, uv_buf_t* buf) {
    fprintf(stderr,"#");
    (void)handle;
    buf->base = malloc(suggested_size);
    buf->len = suggested_size;
}

static void ensure_write(uv_write_t *req, int status)
{
    if (status)
        fprintf(stderr, "Ensured %d (%s)", status, uv_strerror(status));
    if (status)
        uv_close((uv_handle_t *)req->handle, NULL);
        #if 1
    free(req);
    #endif
}

static br_ssl_client_context sc;
static br_x509_minimal_context xc;
static struct http_response_parser hc;

static char request[] =
"GET /dir HTTP/1.1\r\n"
"User-Agent: acme-xgh\r\n"
#ifdef IP
"Host: pebble\r\n"
#else
"Host: " HOST "\r\n"
#endif
//"User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0\r\n"
//"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n"
//"Accept-Language: pt-BR,pt;q=0.8,en-US;q=0.5,en;q=0.3\r\n"
"Accept-Encoding: identity;q=1\r\n"
"Connection: close\r\n"
//"Upgrade-Insecure-Requests: 1\r\n"
//"Sec-Fetch-Dest: document\r\n"
//"Sec-Fetch-Mode: navigate\r\n"
//"Sec-Fetch-Site: none\r\n"
//"Priority: u=0, i\r\n"
//"Pragma: no-cache\r\n"
//"Cache-Control: no-cache\r\n"
"\r\n"
;

static void exchange(uv_stream_t *stream, ssize_t nread, const uv_buf_t *buf)
{
    int r;

    if (nread < 0)
    {
        fprintf(stderr, "nread %zu", nread);
        uv_close((uv_handle_t *)stream, NULL);
    }

    enum { total = sizeof request - 1 };
    static int elapsed_req = 0;
    int elapsed_incoming = 0;
    do
    {
        kludge:
    	fprintf(stderr, "+");
        unsigned s = br_ssl_engine_current_state(&sc.eng);

        if (BR_SSL_CLOSED == s)
        {
            fprintf(stderr, "closing(%d)", br_ssl_engine_last_error(&sc.eng));
            uv_close((uv_handle_t *)stream, NULL);
            break;
        }
        else if (BR_SSL_RECVAPP & s)
        {
            size_t len;
            unsigned char *buff = br_ssl_engine_recvapp_buf(&sc.eng, &len);
            fprintf(stderr, "Ra(%zu)", len);
	    assert(len <= INT_MAX);
            #if 0
            printf("%.*s", (int)len, buff);
            #else
            printf("\nran client code = %d\n\n", http_client(&hc, buff, len));
            #endif
            br_ssl_engine_recvapp_ack(&sc.eng, len);
            goto kludge;

            // TODO should http_client() call back into the JSON
            // parser, or follow BearSSL paradigm?
        }
        else if (BR_SSL_SENDREC & s)
        {
            size_t len;
            unsigned char *buff = br_ssl_engine_sendrec_buf(&sc.eng, &len);
            fprintf(stderr, "Sr(%zu)", len);
            struct funny_writer *fw = malloc(sizeof *fw + len);
            fw->holder.base = fw->bu;
            fw->holder.len = len;
            memcpy(fw->bu, buff, len);
            TRY_UV(uv_write(
                &fw->base,
                stream,
                &fw->holder,
                1, ensure_write
            ));
            br_ssl_engine_sendrec_ack(&sc.eng, len);
            goto kludge;

            // TODO should be a for-loop to atomically write several
            // uv_buf_t at once, array of them.
        }
        else if ((BR_SSL_RECVREC & s) && elapsed_incoming < nread)
        {
            size_t len;
            unsigned char *buff = br_ssl_engine_recvrec_buf(&sc.eng, &len);
            fprintf(stderr, "Rr(%zd,%zu)", nread, len);
            int const missing = nread - elapsed_incoming;
            size_t const actual = MIN(missing, len);
            memcpy(buff, buf->base + elapsed_incoming, actual);
            elapsed_incoming += actual;
            br_ssl_engine_recvrec_ack(&sc.eng, actual);
            goto kludge;
        }
        else if ((BR_SSL_SENDAPP & s) && elapsed_req < total)
        {
            size_t len;
            unsigned char *buff = br_ssl_engine_sendapp_buf(&sc.eng, &len);
            fprintf(stderr, "Sa(%zu)", len);
            int const left = total - elapsed_req;
            int allowed = MIN(left, len);
            memcpy(buff, request + elapsed_req, allowed);
            elapsed_req += allowed;
            br_ssl_engine_sendapp_ack(&sc.eng, allowed);
            if (elapsed_req >= total)
                br_ssl_engine_flush(&sc.eng, 0);
            goto kludge;
        }
        else
        {
            fprintf(stderr, "s(%d)", s);
        }
    }
    while (elapsed_incoming < nread);

    fprintf(stderr, ".");
    free(buf->base);
}

#if 0
static void idiot_read(uv_stream_t *stream, ssize_t nread, const uv_buf_t *buf)
{
    printf("nread = %zd, buf.len = %zu\n", nread, buf->len);
    if (nread > 0)
        printf("%.*s", (int)nread, buf->base);
}
#endif

static void bruh(uv_connect_t *req, int status)
{
    (void)req;
    if (status)
        fprintf(stderr, "tcp conn %d %s\n", status, uv_strerror(status));
}

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    http_client_init(&hc);
    acme_init();

    loop = uv_default_loop();
    uv_tcp_t client;
    uv_tcp_init(loop, &client);

    int r;

#ifdef IP
    struct sockaddr_in addr;
    uv_ip4_addr(IP, PORT, &addr);
#else
        uv_getaddrinfo_t gai;
        TRY_UV(uv_getaddrinfo(loop, &gai, NULL, HOST, NULL, NULL));

        char bazillion[1000];
        TRY_UV(uv_ip_name(gai.addrinfo->ai_addr, bazillion, 1000));
        printf("site ip is %s\n", bazillion);

    #if 1
	struct sockaddr_storage addr;
        memcpy(&addr, gai.addrinfo->ai_addr, gai.addrinfo->ai_addrlen);
        if (AF_INET == gai.addrinfo->ai_family)
            ((struct sockaddr_in *)&addr)->sin_port = htons(443);
        else if (AF_INET6 == gai.addrinfo->ai_family)
            ((struct sockaddr_in6 *)&addr)->sin6_port = htons(443);
        else
            assert(!"fuck");
    #endif
#endif

    #if 0
struct sockaddr_in addr2;
    uv_ip4_addr("62.210.214.227", 80, &addr2);
    printf("hardcoded: %d %d %d\n", addr2.sin_family, addr2.sin_port, addr2.sin_addr.s_addr);
#endif

        uv_connect_t fuc;
        TRY_UV(uv_tcp_connect(&fuc, &client, (struct sockaddr *)&addr, bruh));
        #ifndef IP
        uv_freeaddrinfo(gai.addrinfo);
        #endif

    uv_stream_t *stream = (uv_stream_t *)&client;

#if 1
    br_ssl_client_init_full(&sc, &xc, TAs, TAs_NUM);
    static unsigned char iobuf[BR_SSL_BUFSIZE_BIDI];
    fprintf(stderr, "iobuf %zu\n", sizeof iobuf);
    br_ssl_engine_set_buffer(&sc.eng, iobuf, sizeof iobuf, 1);
    if (!br_ssl_client_reset(&sc,
    #ifdef IP
    "pebble"
    #else
    HOST
    #endif
    , 0))
    {
    	fprintf(stderr, "reset_failed(%d)", br_ssl_engine_last_error(&sc.eng));
    }

    exchange(stream, 0, &(uv_buf_t){0,0});
    TRY_UV(uv_read_start(stream, my_alloc_cb, exchange));
#else
    struct funny_writer fw;
    fw.holder.base = request;
    fw.holder.len = sizeof request - 1;
    TRY_UV(uv_write(&fw.base, stream, &fw.holder, 1, ensure_write));
    TRY_UV(uv_read_start(stream, my_alloc_cb, idiot_read));
#endif

    // TODO erase iobuf securely
    // TODO stack wiping (?)
    return uv_run(loop, UV_RUN_DEFAULT);;
}

// SO_REUSEPORT.
// TODO Study this! VERY interesting.
// https://lwn.net/Articles/542629/
