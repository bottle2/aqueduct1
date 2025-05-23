#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <uv.h>

#include "doc.h"
#include "http.h"
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

struct doc *latest = NULL;

static void alloc_buffer(uv_handle_t *handle, size_t suggested_size, uv_buf_t *buf)
{
    (void)handle;
    buf->base = malloc(buf->len = suggested_size);
}

void on_close(uv_handle_t *handle) { free(handle); }

// This approach is currently shit.
// Alternatives:
// - Some timer that closes connection.
// - Some priority queue that closes oldest least active connections.
// Future directions:
// - Implement shutdown to have graceful HTTP close.
static void on_read(uv_stream_t *client, ssize_t nread, uv_buf_t const *buf)
{
    if (nread > 0)
        http_parse((struct http *)client, (unsigned char *)buf->base, nread);
    else if (nread < 0)
        uv_close((uv_handle_t *)client, on_close);

    if (buf->len > 0 || buf->base)
        free(buf->base);
}

static void on_new_connection(uv_stream_t *server, int status)
{
    if (status < 0)
    {
        fprintf(stderr, "New connection error %s\n", uv_strerror(status));
        return;
    }

    struct http *client = malloc(sizeof (*client));

    if (!client)
    {
        fprintf(stderr, "OOM for client\n");
        return;
    }

    uv_tcp_init(loop, &client->tcp);

    client->write_doc_req.outer = client;

    if (0 == uv_accept(server, (uv_stream_t *)client))
    {
        http_init(client);
        uv_read_start((uv_stream_t *)client, alloc_buffer, on_read);
    }
    else
        uv_close((uv_handle_t *)client, on_close);
}

struct movie_req
{
    union // Look at the horrible evil evil evil things you are forcing me to do!!!!
    {
        struct
        {
            uv_fs_t file;
            uv_file desc;
        };
        uv_work_t work;
    };
    uv_buf_t buf[1];
    struct parser parser;
    struct movies movies;
    int gen;

    char base[20];
    _Atomic bool stop;
    bool good_read;

    char *html5;
    size_t html5_len;
};

void add_to_latest_movie(uv_work_t *work, int status)
{
    struct movie_req *req = (struct movie_req *)work;

    if (UV_ECANCELED == status)
        assert(NULL == req->html5);
    else if (status != 0)
        fprintf(stderr, "Mystery error %d: %s\n", status, uv_strerror(status));
    else if (req->html5 != NULL && req->html5_len > 0)
    {
        enum code code = doc_add(&latest, req->html5, req->html5_len, req->gen);

        if (code != CODE_OKAY)
        {
            fprintf(stderr, "error before adding!! %s\n", code_msg(code));
            free(req->html5);
        }
    }
    else
        fprintf(stderr, "some error IDK!!\n");

    movies_free(&req->movies);
    free(req); // can we free this piece of shit HERE?
}

static int counter_printf(void *data, char const *fmt, ...)
{
    // thanks bubuche87 from #c chatroom @ libera.chat !!!
    size_t *len = data;

    va_list ap;
    va_start(ap, fmt);

    int code = vsnprintf(NULL, 0, fmt, ap);

    assert(code >= 0);

    if (code >= 0)
        *len += code;

    va_end(ap);

    return code;
}

struct virt_file
{
    char *buffer;
    size_t pos;
    size_t cap;
};

static int actual_printf(void *data, char const *fmt, ...)
{
    struct virt_file *vf = data;

    va_list ap;
    va_start(ap, fmt);

    int code = vsnprintf(vf->buffer + vf->pos, vf->cap, fmt, ap);

    assert(code >= 0);

    vf->pos += code;

    assert(vf->pos < vf->cap);

    va_end(ap);

    return code;
}

void process_movie(uv_work_t *work)
{
    struct movie_req *req = (struct movie_req *)work;
    req->html5     = NULL;
    req->html5_len = -1;
    struct virt_file vf = {0};
    struct printer count = {.data = &vf.cap, .pprintf = counter_printf};
    enum code code;
    if ((code = vomit(count, &req->movies)) != CODE_OKAY)
    {
        fprintf(stderr, "error processing vomit: %s\n", code_msg(code));
        // fail fail fail fail fail
        return;
    }
    if (NULL == (vf.buffer = malloc(++vf.cap)))
    {
        fprintf(stderr, "error processing vomit: enomem enomem enomem");
        return;
    }

    struct printer actual = {.data = &vf, .pprintf = actual_printf};

    code = vomit(actual, &req->movies);

    assert(CODE_OKAY == code);

    req->html5     = vf.buffer;
    req->html5_len = vf.pos;
}

static void maybe_open_movie(void);

static void on_movies_change(
    uv_fs_poll_t *handle,
    int status,
    uv_stat_t const *prev,
    uv_stat_t const *curr
) {
    (void)handle;
    (void)prev;
    (void)curr;

#if 0
    assert(UV_RENAME == status || UV_CHANGE == status);
#endif

    printf("poll: %d\n", status);
    if (status != 0)
        return;

    size_t len = 1000;
    char buffer[1000] = {0};
    int rc = uv_fs_poll_getpath(handle, buffer, &len);
    printf("poll: %d %s %zu\n", rc, buffer, len);

    maybe_open_movie();
}

void close_movie(uv_fs_t *fil);

void read_cb_movie(uv_fs_t *fil)
{
    struct movie_req *req = (struct movie_req *)fil;

    req->good_read = false;

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
        uv_fs_req_cleanup(fil);
        req->good_read = true;
        uv_fs_close(loop, fil, req->desc, close_movie);
    }
    else
    {
        int code;
        if ((code = parse(&req->parser, (unsigned char *)req->base, fil->result, &req->movies)) != CODE_OKAY)
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
    if (req->good_read)
    {
        int code;
        if ((code = parse(&req->parser, NULL, 0, &req->movies)) != CODE_OKAY)
            fprintf(stderr, "error %d: %s\n", code, code_msg(code));

        memset(&req->work, '\0', sizeof (req->work));
        int re;
        if ((re = uv_queue_work(loop, &req->work, process_movie, add_to_latest_movie)) != 0)
        {
            fprintf(stderr, "error queuing movie work: %s\n", uv_strerror(re));
            goto free_everything;
        }
    }
    else
        goto free_everything;
    parser_del(&req->parser);
    return;
free_everything:
    parser_del(&req->parser);
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
        else
        {
            candidate->parser = parser_init();
            memset(&candidate->file  , '\0', sizeof (candidate->file));
            memset(&candidate->movies, '\0', sizeof (candidate->movies));
            candidate->movies.last = &candidate->movies.elements;
            candidate->buf->base = candidate->base;
            candidate->buf->len  = 20; // shitty hardcode
            candidate->desc = descriptor;
            // wtf is this ugly shit construction wtf wtf wtf wtf
            atomic_init(&candidate->stop, false);
            int re;
            if ((re = uv_fs_read(loop, (uv_fs_t *)candidate, descriptor, candidate->buf, 1, -1, read_cb_movie)) < 0)
            {
                parser_del(&candidate->parser);
                free(candidate);
                fprintf(stderr, "failed first movie read: %s\n", uv_strerror(re));
            }
            else
            {
                candidate->gen = gen++;
                struct movie_req *curr = atomic_exchange(&current, candidate);
                if (curr != NULL)
                    curr->stop = true;
            }
        }
    }
}

int main(int argc, char *argv[])
{
    atomic_init(&current, NULL);
    loop = uv_default_loop();
    uv_tcp_t server;
    uv_tcp_init(loop, &server);

    struct sockaddr_in addr;

    int r;

    if ((r = uv_ip4_addr(
        argc > 1 ? argv[1]       : "0.0.0.0",
        argc > 2 ? atoi(argv[2]) : DEFAULT_PORT,
        &addr
    )))
    {
        fprintf(stderr, "ip4 error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    if ((r = uv_tcp_bind(&server, (struct sockaddr const *)&addr, 0)))
    {
        fprintf(stderr, "bind error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    if ((r = uv_listen((uv_stream_t *)&server, DEFAULT_BACKLOG, on_new_connection)))
    {
        fprintf(stderr, "Listen error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    // TODO it stops working after rm or mv! (only on Android, Windows looking good!)
    uv_fs_poll_t movies_event = {0};

    if ((r = uv_fs_poll_init(loop, &movies_event)))
    {
        fprintf(stderr, "fs poll loop error %s\n", uv_strerror(r));
        return EXIT_FAILURE;
    }

    if ((r = uv_fs_poll_start(&movies_event, on_movies_change, "./movies.txt", 5000)))
    {
        fprintf(stderr, "fs poll start error %s\n", uv_strerror(r));
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
