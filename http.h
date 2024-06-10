#ifndef HTTP_H
#define HTTP_H

// Maybe use code enum?
#define HTTP_ANSWER_XS(X) \
X(NO_HTTP2       ) \
X(BAD_REQUEST    ) \
X(NOT_IMPLEMENTED) \
X(OKAY           )

struct http
{
    int cs;

    enum http_method { HTTP_METHOD_GET, HTTP_METHOD_HEAD, } method;
};

struct http http_init(void);
void http_del(struct http *http);
enum code http_parse(struct http *http, unsigned char *buffer, int len);

#endif
