# XXX This is a mess OMG
PAGES=bookmarks.html vehicle-building-games.html

TARGET=site batch #batch2

all:$(TARGET) $(PAGES)

bookmarks.html:bookmarks
	./$? > $@
vehicle-building-games.html:vehicle-building-games
	./$? > $@

my_certs.c:
	find /usr/share/ca-certificates/mozilla/ \
	-type f -exec brssl ta test/certs/pebble.minica.pem {} + > $@

http_client.c:http_base.rl

vrum:vrum.c my_certs.c http_client.c acme.c
	$(CC) -std=c18 -D_XOPEN_SOURCE=600 \
	$(CFLAGS) -o $@ vrum.c $(LDLIBS)

acme.c:unicode.rl

json:acme.c
	$(CC) -DIS_MAIN -Wpedantic -Wall -Wextra acme.c -o $@

JSON_CASES=JSONTestSuite/test_parsing/
json_test:json
	for i in $(JSON_CASES)y_* more_json/pass*; \
	do echo testing $$i; ./json $$i || exit $$?; done
	for i in $(JSON_CASES)n_* more_json/fail*; \
	do echo testing $$i; ./json $$i && exit 67; true; done

# TODO this is braindead. specially with make -B
libxlsxwriter/README.md:
	-git clone --depth 1 https://github.com/jmcnamara/libxlsxwriter.git
	cd libxlsxwriter && git checkout v1.2.4 && touch README.md

#EMSCRIPTEN_CFLAGS=-Og -g3
EMSCRIPTEN_CFLAGS=-Oz -flto
#EMSCRIPTEN_CFLAGS=-fsanitize=address,undefined,bounds -Oz -g3 -flto

libxlsxwriter.o:libxlsxwriter.c
	emcc -sUSE_ZLIB $(EMSCRIPTEN_CFLAGS) -c \
	-DUSE_NO_MD5 -DUSE_FMEMOPEN -DUSE_STANDARD_TMPFILE -DIOAPI_NO_64 \
	-Ilibxlsxwriter/include \
	-Ilibxlsxwriter/third_party/minizip \
	libxlsxwriter.c

libxlsxwriter.c:libxlsxwriter/README.md
	printf '#include "%s"\n' \
	libxlsxwriter/src/*.c \
	libxlsxwriter/third_party/minizip/{ioapi,zip}.c \
	> $@

form.c:form.rl
	ragel -G2 form.rl > $@

form.html:form.m4
	m4 -Dgen=html form.m4 > $@

form.h:form.m4
	m4 -Dgen=h form.m4 > $@

formulario.html:form.html form.c form.h libxlsxwriter.o
	emcc -mreference-types $(EMSCRIPTEN_CFLAGS) \
	-o $@ form.c libxlsxwriter.o \
	--shell-file=form.html \
	-sSINGLE_FILE -Ilibxlsxwriter/include \
	-sALLOW_MEMORY_GROWTH \
	-sUSE_ZLIB \
	-sEXPORTED_FUNCTIONS=stringToNewUTF8,_free,_worksheet_write_string

DEPS=libuv bearssl

CFLAGS=-g3 -Og \
-Wpedantic -Wall -Wextra -Wshadow \
-Wno-implicit-fallthrough \
-fno-strict-aliasing \
$$(pkg-config --cflags $(DEPS)) \
#-fsanitize=address,undefined,bounds
LDLIBS=$$(pkg-config --libs $(DEPS))

SOURCE=main.c parse.c code.c movie.c doc.c parse2.c http.c movies.c hack.c
OBJ=$(SOURCE:.c=.o)

http.c:http.rl response.c response.rl route.rl

#http:http.c
#	$(CC) -flto -O1 -DIS_MAIN $< -o $@
marshal:marshal.c
	$(CC) $< -o $@

hack.c:hack.m4 marshal
	m4 $< > $@

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

run:site key_private.donotcommit domain.csr
	./site

key_private.donotcommit:
	openssl genrsa 4096 > $@

key_domain.donotcommit:
	openssl genrsa 4096 > $@

domain.csr:key_domain.donotcommit
	openssl req -new -sha256 -key key_domain.donotcommit -subj '/CN=aqueduct1.horse' > $@

site:$(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) $(LDLIBS)
	-sudo setcap CAP_NET_BIND_SERVICE=ep $@

batch:batch.c parse.c code.c parse2.c movies.c
	$(CC) $(CFLAGS) -o $@ batch.c parse.c code.c movie.c movies.c $(LDLIBS)

#batch2:batch2.c parse.c code.c
#	$(CC) $(CFLAGS) -o $@ batch2.c parse.c code.c movie.c $(LDLIBS)

clean:
	rm -f $(TARGET) $(OBJ=.o=.d)
	rm -f $(PAGES) bookmarks vehicle-building-games

tags:
	ctags *.c
	# XXX Add tags for libuv

#check_lb:check_lb.c lb.h lb.c
#	$(CC) -Wpedantic -Wall -Wextra $$(pkgconf --cflags check) -o $@ check_lb.c lb.c $$(pkgconf --libs check)

movies.c:movies.ctt ctt

troff_exp.pdf:troff_exp.mom
	pdfmom -Kutf8 -pt troff_exp.mom > $@

draft.pdf:draft.mom
	pdfmom -Kutf8 -p $< > $@

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

include $(OBJ:.o=.d)

.SUFFIXES: .c .d .rl .svg .ctt

.rl.c:
	ragel -G2 $<
.rl.svg:
	ragel -pV $< | dot -Tsvg > $@
.ctt.c:
	./ctt < $< > $@
.c.d:
	cc -MM -MG $< | sed 's@^\(.*\)\.o:@\1.d \1.o:@' > $@
#TODO Missing CFLAGS
