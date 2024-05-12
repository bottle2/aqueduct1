#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

#include <llhttp.h>

#include "doc.h"
#include "parse.h"

#ifdef __STDC_NO_ATOMICS__
#error fuck no _Atomic for me!
#endif

#include <stdatomic.h>

_Static_assert(2 == ATOMIC_BOOL_LOCK_FREE, "bro we are fucked");
_Static_assert(2 == ATOMIC_POINTER_LOCK_FREE, "bro we are fucked pointers");

#define DEFAULT_PORT     80
#define DEFAULT_BACKLOG 128

uv_loop_t *loop = NULL;
llhttp_settings_t settings;

struct client
{
    uint8_t superclass[sizeof (uv_tcp_t)];
    llhttp_t parser;
    struct write_doc_req {
        uint8_t superclass[sizeof (uv_write_t)];
        struct doc *doc_used;
    } write_doc_req;
};

#define RESPONSE \
  "HTTP/1.1 503 Service Unavailable\r\n" \
  "Content-Type: text/plain\r\n" \
  "Content-Length: 21\r\n" \
  "\r\n" \
  "document unavailable\n"

static uv_buf_t standard = {.base = RESPONSE, .len = sizeof(RESPONSE)};

struct doc *latest = NULL;

struct write_req
{
    uv_write_t req;
    uv_buf_t buf;
};

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

static void on_write_doc(uv_write_t *req, int status)
{
    struct write_doc_req *doc_req = (struct write_doc_req *)req;

    if (status < 0)
        fprintf(stderr, "Error writing doc: %s\n", uv_strerror(status));

    uv_close((uv_handle_t *)req->handle, on_close);
    doc_free(doc_req->doc_used);
}

static void on_write_default(uv_write_t *req, int status)
{
    if (status < 0)
        fprintf(stderr, "Error writing default: %s\n", uv_strerror(status));
    uv_close((uv_handle_t *)req->handle, on_close);
}

static int on_headers_complete(llhttp_t *parser)
{
    struct client *client = parser->data;

    uv_buf_t *bufs;
    void (*on_write)(uv_write_t *, int);
    int n_buf;

    if (NULL == latest)
    {
        bufs     = &standard;
        on_write = on_write_default;
        n_buf    = 1;
    }
    else
    {
        bufs = doc_get(client->write_doc_req.doc_used = latest);
        on_write = on_write_doc;
        n_buf = 4;
    }

    uv_write(
        (uv_write_t *)&client->write_doc_req,
        (uv_stream_t *)parser->data,
        bufs, n_buf, on_write
    );

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

struct movie_req
{
    uv_fs_t file;
    uv_file desc;
    uv_buf_t buf[1];
    struct line_builder lb;
    struct movies movies;
    int gen;

    char base[20];
    _Atomic bool stop;
};

static void maybe_open_movie(void);

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

    maybe_open_movie();
}

void close_movie(uv_fs_t *fil);

void read_cb_movie(uv_fs_t *fil)
{
    struct movie_req *req = (struct movie_req *)fil;

    if (fil->result < 0)
    {
        fprintf(stderr, "fs movie read error %s\n", uv_strerror(fil->result));
        uv_fs_req_cleanup(fil);
        uv_fs_close(loop, fil, req->desc, close_movie);
    }
    else if (req->stop)
    {
        fprintf(stderr, "atomic movie stop called!\n");
        uv_fs_req_cleanup(fil);
        uv_fs_close(loop, fil, req->desc, close_movie);
    }
    else if (0 == fil->result)
    {
        // LE IMPORTANT STUFF HAPPENS HERE. XXX
        int code = vomit((struct printer){stdout, pfprintf}, &req->movies);
        if (code != CODE_OKAY)
            fprintf(stderr, "error %d: %s\n", code, code_msg(code));
        uv_fs_req_cleanup(fil);
        uv_fs_close(loop, fil, req->desc, close_movie);
    }
    else
    {
        int code;
        if ((code = line_builder_add(&req->movies, &req->lb, req->base, fil->result)) != CODE_OKAY)
        {
            fprintf(stderr, "error %d: %s\n", code, code_msg(code));
            uv_fs_req_cleanup(fil);
            uv_fs_close(loop, fil, req->desc, close_movie);
        }
        else
        {
            uv_fs_req_cleanup(fil);
            if (uv_fs_read(loop, fil, req->desc, req->buf, 1, -1, read_cb_movie) != 0)
                assert(!"impossible return");
        }
    }
}

static int gen = 0; // used when thread ends to only add latest.
static struct movie_req *_Atomic current;

void close_movie(uv_fs_t *fil)
{
    struct movie_req *req = (struct movie_req *)fil;

    struct movie_req *desired = req;
    atomic_compare_exchange_strong(&current, &desired, NULL);

    if (fil->result < 0)
    {
        fprintf(stderr, "error closing movies, nothing to be done: %s\n", uv_strerror(fil->result));
    }

    uv_fs_req_cleanup(fil);
    free(req->lb.line);
    movies_free(&req->movies);
    free(req);
}

static void maybe_open_movie(void)
{
    uv_fs_t req = {0};
    int r = uv_fs_open(loop, &req, "./movies.txt", UV_FS_O_SEQUENTIAL | UV_FS_O_RDONLY, 0, NULL);
    uv_file descriptor = req.result;
    uv_fs_req_cleanup(&req);

    if (r < 0)
        fprintf(stderr, "open movie error %s\n", uv_strerror(r));
    else
    {
        struct movie_req *candidate = malloc(sizeof (*candidate));

        if (NULL == candidate)
            fprintf(stderr, "OOM before reading movies\n");
        else if (NULL == (candidate->lb.line = malloc(1))) // shitty shitty
        {
            fprintf(stderr, "OOM for line builder (movies)\n");
            free(candidate);
        }
        else
        {
            memset(&candidate->file  , '\0', sizeof (candidate->file));
            memset(&candidate->movies, '\0', sizeof (candidate->movies));
            candidate->movies.last = &candidate->movies.elements;
            candidate->buf->base = candidate->base;
            candidate->buf->len  = 20; // shitty hardcode
            candidate->lb.capacity = 1;
            candidate->lb.len = 0;
            candidate->lb.found_newline = false;
            candidate->desc = descriptor;
            // wtf is this ugly shit construction wtf wtf wtf wtf
            atomic_init(&candidate->stop, false);
            int re;
            if ((re = uv_fs_read(loop, (uv_fs_t *)candidate, descriptor, candidate->buf, 1, -1, read_cb_movie)) < 0)
            {
                free(candidate->lb.line);
                free(candidate);
                fprintf(stderr, "failed first movie read: %s\n", uv_strerror(re));
            }
            else
            {
                candidate->gen = gen++;
                struct movie_req *curr = atomic_exchange(&current, candidate);
                if (curr != NULL)
                    curr->stop = true;
#if 0
                current = candidate;
#endif
            }
        }
    }
}

#if 0
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
#endif

int main(void)
{
    atomic_init(&current, NULL);
    loop = uv_default_loop();
    uv_tcp_t server;
    uv_tcp_init(loop, &server);

    llhttp_settings_init(&settings);
    settings.on_message_complete = on_headers_complete;

    struct sockaddr_in addr;

    uv_ip4_addr("0.0.0.0", DEFAULT_PORT, &addr);
    uv_tcp_bind(&server, (struct sockaddr const *)&addr, 0);

    int r;

    if ((r = uv_listen((uv_stream_t *)&server, DEFAULT_BACKLOG, on_new_connection)))
    {
        fprintf(stderr, "Listen error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    // TODO it stops working after rm or mv! (only on Android, Windows looking good!)
    uv_fs_event_t movies_event = {0};

    if ((r = uv_fs_event_init(loop, &movies_event)))
    {
        fprintf(stderr, "fs loop error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    if ((r = uv_fs_event_start(&movies_event, on_movies_change, "./movies.txt", 0)))
    {
        fprintf(stderr, "fs event error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

#if 1
    maybe_open_movie();
#else
    if ((r = uv_fs_open(loop, &read_movie, "./movies.txt", UV_FS_O_SEQUENTIAL | UV_FS_O_RDONLY, 0, open_cb)))
    {
        fprintf(stderr, "fs open error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }
#endif

    return uv_run(loop, UV_RUN_DEFAULT);
}
