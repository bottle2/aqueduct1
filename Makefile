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
-Wno-implicit-fallthrough \
-fno-strict-aliasing \
$$(pkg-config --cflags $(DEPS)) \
#-fsanitize=address,undefined
LDLIBS=$$(pkg-config --libs $(DEPS))

SOURCE=main.c parse.c code.c movie.c doc.c parse2.c http.c movies.c

http.c:http.rl response.c

http.rl:response.rl route.rl
	touch $@

response.c:response.m4
	m4 -Dgen=c $< > $@
response.rl:response.m4
	m4 -Dgen=ragel $< > $@

route.rl:route.m4 percent.m4
	m4 -Dgen=ragel $< > $@

percent.m4:percent
	./$< > $@

percent:percent.c
	cc -O3 $< -o $@

site:$(SOURCE) $(LLHTTP)
	$(CC) $(CFLAGS) -o $@ $(SOURCE) $(LLHTTP) $(LDLIBS)
	-sudo setcap CAP_NET_BIND_SERVICE=ep $@

batch:batch.c parse.c code.c parse2.c movies.c
	$(CC) $(CFLAGS) -o $@ batch.c parse.c code.c movie.c movies.c $(LDLIBS)

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

movies.c:movies.ctt ctt

draft.pdf:draft.mom
	pdfmom -Kutf8 $< > $@

edu_x_macros.pdf:edu_x_macros.mom
	pdfmom -Kutf8 -t $< > $@

edu_groff.pdf:edu_groff.mom
	pdfmom -Kutf8 -tp $< > $@

edu_makefile.pdf:edu_makefile.mom
	pdfmom -Kutf8 -t $< > $@

edu_ragel.pdf:edu_ragel.mom
	pdfmom -Kutf8 -t $< > $@

edu_m4.pdf:edu_m4.mom
	pdfmom -Kutf8 -t $< > $@

.SUFFIXES: .c .rl .svg .ctt

.rl.c:
	ragel -G2 $<
.rl.svg:
	ragel -pV $< | dot -Tsvg > $@
.ctt.c:
	./ctt < $< > $@
