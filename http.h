#ifndef HTTP_H
#define HTTP_H

#include <stdbool.h>

#include <libuv.h>

struct http
{
    uv_tcp_t tcp;

    struct
    {
        int cs;

        enum http_method
        {
            HTTP_METHOD_NONE,
            HTTP_METHOD_GET,
            HTTP_METHOD_HEAD,
        } method;

        enum http_host
        {
            HTTP_HOST_NONE,
            HTTP_HOST_ABSOLUTE = 1,
            HTTP_HOST_FIELD = 2,
        } host;
    }; // HTTP parsing.

    struct write_doc_req
    {
        uv_write_t write;
        struct doc *doc_used;
    } write_doc_req;
};

struct http http_init(void);
void http_parse(struct http *http, unsigned char *buffer, int len);

#endif
