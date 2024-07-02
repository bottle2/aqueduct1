# XXX This is a mess OMG
PAGES=bookmarks.html vehicle-building-games.html

TARGET=site batch #batch2

all:$(TARGET) $(PAGES)

bookmarks.html:bookmarks
	./$? > $@
vehicle-building-games.html:vehicle-building-games
	./$? > $@

DEPS=libuv

CFLAGS=-g3 \
-Wpedantic -Wall -Wextra -Wshadow \
-fno-strict-aliasing \
$$(pkg-config --cflags $(DEPS))
LDLIBS=$$(pkg-config --libs $(DEPS))

SOURCE=main.c parse.c code.c movie.c doc.c parse2.c http.c

site:$(SOURCE) $(LLHTTP)
	$(CC) $(CFLAGS) -o $@ $(SOURCE) $(LLHTTP) $(LDLIBS)
	-sudo setcap CAP_NET_BIND_SERVICE=ep $@

batch:batch.c parse.c code.c parse2.c
	$(CC) $(CFLAGS) -o $@ batch.c parse.c code.c movie.c $(LDLIBS)

#batch2:batch2.c parse.c code.c
#	$(CC) $(CFLAGS) -o $@ batch2.c parse.c code.c movie.c $(LDLIBS)

clean:
	rm -f $(LLHTTP) $(TARGET)
	rm -f $(PAGES) bookmarks vehicle-building-games

tags:
	ctags *.c
	# XXX Add tags for libuv

#check_lb:check_lb.c lb.h lb.c
#	$(CC) -Wpedantic -Wall -Wextra $$(pkgconf --cflags check) -o $@ check_lb.c lb.c $$(pkgconf --libs check)

.SUFFIXES: .c .rl .svg

.rl.c:
	ragel $<
.rl.svg:
	ragel -pV $< | dot -Tsvg > $@
