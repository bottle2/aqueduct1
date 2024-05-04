# XXX This is a mess OMG
PAGES=bookmarks.html vehicle-building-games.html

TARGET=site batch

all:$(TARGET) $(PAGES)

bookmarks.html:bookmarks
	./$? > $@
vehicle-building-games.html:vehicle-building-games
	./$? > $@

DEPS=libuv

CFLAGS=-g3 -fsanitize=address,undefined \
-Wpedantic -Wall -Wextra -Wshadow \
-fno-strict-aliasing \
$$(pkg-config --cflags $(DEPS)) -Illhttp
LDLIBS=$$(pkg-config --libs $(DEPS))

LLHTTP=llhttp/api.o llhttp/http.o llhttp/llhttp.o
LLHTTP_SOURCE=llhttp/api.c llhttp/http.c llhttp/llhttp.c llhttp/llhttp.h
LLHTTP_URL=https://raw.githubusercontent.com/nodejs/node/main/deps/llhttp
LLHTTP_RECIPE=$(CC) -g3 -Wall -Wextra -Wno-unused-parameter -o $@ -c $*.c

SOURCE=main.c parse.c code.c

site:$(SOURCE) $(LLHTTP)
	$(CC) $(CFLAGS) -o $@ $(SOURCE) $(LLHTTP) $(LDLIBS)

batch:batch.c parse.c code.c
	$(CC) $(CFLAGS) -o $@ batch.c parse.c code.c $(LDLIBS)

clean:
	rm -f $(LLHTTP) $(TARGET)
	rm -f $(PAGES) bookmarks vehicle-building-games

dist-clean:clean
	rm -rf llhttp

tags:
	ctags *.c llhttp/*.{c,h}
	# XXX Add tags for libuv

llhttp/api.o:$(LLHTTP_SOURCE)
	$(LLHTTP_RECIPE)

llhttp/http.o:$(LLHTTP_SOURCE)
	$(LLHTTP_RECIPE)

llhttp/llhttp.o:$(LLHTTP_SOURCE) # XXX Not good.
	$(LLHTTP_RECIPE)

$(LLHTTP_SOURCE):
	mkdir -p llhttp
	curl $(LLHTTP_URL)/src/api.c        > llhttp/api.c
	curl $(LLHTTP_URL)/src/http.c       > llhttp/http.c
	curl $(LLHTTP_URL)/src/llhttp.c     > llhttp/llhttp.c
	curl $(LLHTTP_URL)/include/llhttp.h > llhttp/llhttp.h

#check_lb:check_lb.c lb.h lb.c
#	$(CC) -Wpedantic -Wall -Wextra $$(pkgconf --cflags check) -o $@ check_lb.c lb.c $$(pkgconf --libs check)
