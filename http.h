#ifndef HTTP_H
#define HTTP_H

#include <libuv.h>

// Maybe use code enum?
#define HTTP_ANSWER_XS(X) \
X(NO_HTTP2       ) \
X(BAD_REQUEST    ) \
X(NOT_IMPLEMENTED) \
X(OKAY           )

struct http
{
    uv_tcp_t tcp;

    int cs;

    enum http_method { HTTP_METHOD_NONE, HTTP_METHOD_GET, HTTP_METHOD_HEAD, } method;
    enum http_host { HTTP_HOST_NONE, HTTP_HOST_LOOPBACK, HTTP_HOST_LOCALHOST, HTTP_HOST_PUBLIC, } host;

    uv_shutdown_t handle1;
    uv_handle_t handle2; // little thoughts given.
};

struct http http_init(void);
void http_parse(struct http *http, unsigned char *buffer, int len);

#endif
