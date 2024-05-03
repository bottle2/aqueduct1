#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

#include <llhttp.h>

#include "parse.h"

#define DEFAULT_PORT    7000
#define DEFAULT_BACKLOG  128

uv_loop_t *loop = NULL;
llhttp_settings_t settings;

struct client
{
    uint8_t superclass[sizeof (uv_tcp_t)];
    llhttp_t parser;
    uv_write_t write_req;
};

#define RESPONSE \
  "HTTP/1.1 200 OK\r\n" \
  "Content-Type: text/plain\r\n" \
  "Content-Length: 12\r\n" \
  "\r\n" \
  "hello world\n"
static uv_buf_t resbuf = {.base = RESPONSE, .len = sizeof(RESPONSE)};

struct write_req
{
    uv_write_t req;
    uv_buf_t buf;
};

void write_req_free(uv_write_t *req)
{
    struct write_req *wr = (struct write_req *)req;
    free(wr->buf.base);
    free(wr);
}

static void alloc_buffer(uv_handle_t *handle, size_t suggested_size, uv_buf_t *buf)
{
    (void)handle;
    buf->base = malloc(buf->len = suggested_size);
}

static void on_close(uv_handle_t *handle) { free(handle); }

static void on_read(uv_stream_t *client, ssize_t nread, uv_buf_t const *buf)
{
    if (nread < 0)
    {
        if (nread != UV_EOF)
            fprintf(stderr, "Read error %s\n", uv_err_name(nread));

        uv_close((uv_handle_t *)client, on_close);
    }
    else if (nread > 0)
    {
        struct write_req *req = malloc(sizeof (*req));

        req->buf = uv_buf_init(buf->base, nread);

        int err;
        llhttp_t *parser = &((struct client *)client)->parser;
        if ((err = llhttp_execute(parser, buf->base, nread)) != HPE_OK)
        {
            fprintf(stderr, "Parse error %s %s\n", llhttp_errno_name(err), parser->reason);
            uv_close((uv_handle_t *)client, on_close);
        }
    }

    free(buf->base);
}

static void on_write_done(uv_write_t *req, int status)
{
    if (status < 0)
        fprintf(stderr, "Error writing: %s\n", uv_strerror(status));

    uv_close((uv_handle_t *)req->handle, on_close);
}

static int on_headers_complete(llhttp_t *parser)
{
    uv_write(&((struct client *)parser->data)->write_req, (uv_stream_t *)parser->data, &resbuf, 1, on_write_done);
    return 0;
}

static void on_new_connection(uv_stream_t *server, int status)
{
    if (status < 0)
    {
        fprintf(stderr, "New connection error %s\n", uv_strerror(status));
        return;
    }

    struct client *client = malloc(sizeof (*client));

    if (!client)
    {
        fprintf(stderr, "OOM for client\n");
        return;
    }

    uv_tcp_init(loop, (uv_tcp_t *)client);

    if (0 == uv_accept(server, (uv_stream_t *)client))
    {
        llhttp_init(&client->parser, HTTP_REQUEST, &settings);
        client->parser.data = client;
        uv_read_start((uv_stream_t *)client, alloc_buffer, on_read);
    }
    else
        uv_close((uv_handle_t *)client, on_close);
}

static void on_movies_change(
    uv_fs_event_t *handle,
    char const *path,
    int events,
    int status
) {
    (void)handle;

#if 0
    assert(UV_RENAME == status || UV_CHANGE == status);
#endif

    printf("%d %s %d\n", events, path, status);

    size_t len = 1000;
    char buffer[1000] = {0};
    int rc = uv_fs_event_getpath(handle, buffer, &len);
    printf("%d %s %zu\n", rc, buffer, len);
}

uv_fs_t read_movie = {0};

uv_file fucking_desc;
uv_buf_t portion = {.base = (char [21]){0}, .len = 20};

struct line_builder lb = {0};

void read_cb(uv_fs_t *fil)
{
    if (fil->result < 0)
    {
        fprintf(stderr, "fs read error %s\n", uv_strerror(fil->result));
        exit(EXIT_FAILURE);
    }

    if (0 == fil->result)
    {
        // close this shit fuck
        puts("we should close this piss fuck");
        vomit();
    }
    else
    {
#if 0
        printf("%.*s", (int)fil->result, portion.base);
#endif
#if 0
        portion.base[fil->result] = '\0';
#endif
        line_builder_add(&lb, portion.base, fil->result);
        if (uv_fs_read(loop, fil, fucking_desc, &portion, 1, -1, read_cb) != 0)
            assert(!"impossible return");
    }
}

void open_cb(uv_fs_t *fil)
{
    if (fil->result < 0)
    {
        fprintf(stderr, "fs open error 2 %s\n", uv_strerror(fil->result));
        exit(EXIT_FAILURE);
    }

    fucking_desc = fil->result;

    if (uv_fs_read(loop, fil, fucking_desc, &portion, 1, -1, read_cb) != 0)
        assert(!"impossible return");
}

int main(void)
{
    lb.line = malloc(1);
    loop = uv_default_loop();
    uv_tcp_t server;
    uv_tcp_init(loop, &server);

    llhttp_settings_init(&settings);
    settings.on_message_complete = on_headers_complete;

    struct sockaddr_in addr;

    uv_ip4_addr("0.0.0.0", DEFAULT_PORT, &addr);

    uv_tcp_bind(&server, (struct sockaddr const *)&addr, 0);

    int r = uv_listen((uv_stream_t *)&server, DEFAULT_BACKLOG, on_new_connection);

    if (r)
    {
        fprintf(stderr, "Listen error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    // TODO it stops working after rm or mv!
    uv_fs_event_t movies_event = {0};
    r = uv_fs_event_init(loop, &movies_event);

    if (r)
    {
        fprintf(stderr, "fs loop error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    r = uv_fs_event_start(&movies_event, on_movies_change, "./movies.txt", 0);

    if (r)
    {
        fprintf(stderr, "fs event error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    if ((r = uv_fs_open(loop, &read_movie, "./movies.txt", UV_FS_O_SEQUENTIAL | UV_FS_O_RDONLY, 0, open_cb)))
    {
        fprintf(stderr, "fs open error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    return uv_run(loop, UV_RUN_DEFAULT);
}
