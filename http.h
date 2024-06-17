#ifndef HTTP_H
#define HTTP_H

#include <stdbool.h>

#include <libuv.h>

struct http
{
    uv_tcp_t tcp;

    union // Either parsing or tearing down.
    {
        struct
        {
            int cs;
            bool is_absolute;

            enum http_method
            {
                HTTP_METHOD_NONE,
                HTTP_METHOD_GET,
                HTTP_METHOD_HEAD,
            } method;
            enum http_host
            {
                HTTP_HOST_NONE,
                HTTP_HOST_LOOPBACK,
                HTTP_HOST_LOCALHOST,
                HTTP_HOST_PUBLIC,
            } host;
        }; // HTTP parsing.

        struct
        {
            struct write_doc_req
            {
                uv_write_t write;
                struct doc *doc_used;
            } write_doc_req;
            uv_shutdown_t handle_st;
        }; // Callback hell.
    };
};

struct http http_init(void);
void http_parse(struct http *http, unsigned char *buffer, int len);

#endif
