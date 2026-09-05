define(`XGH_CC',`clang -ferror-limit=1')dnl
dnl # define(`XGH_CC',`gcc -fmax-errors=1')dnl
rule regen
  command=m4 $in > $out
  generator=1
rule m4
  depfile=$out.d
  deps=gcc
  command= m4 -di $in 2>&1 > $out $
         | awk '$$0~/m4debug: input read.*/{print $$5;next}$$0!~/m4debug: input.*/{print>"/dev/stderr"}' $
         | sort | uniq | xargs echo "$out:" > $out.d

rule m42
  command=m4 $arg $in | sed "s/@aq@/'/g" > $out

rule ragel
  depfile=$out.d
  deps=gcc
  command= ragel -G2 $in && sed -n 's/^#line .* \(.*\)$$/\1/p' $out $
         | grep -v $out | sort | uniq | xargs echo '$out:' > $out.d
#rule cc
#  depfile=$out.d
#  deps=gcc
#  command=cc -MM -MG -MF $out.d $cflags -cc
rule cc2
  depfile=$out.d
  deps=gcc
  command=XGH_CC -MMD -MF $out.d -fdiagnostics-color=always $cflags -o $out $in
rule cce
  command=tcc $cflags -run $in > $out
build build.ninja: regen ninja.m4
build json_xgh.c: ragel json_xgh.rl
build json_xgh: cc2 json_xgh.c
  cflags=-DIS_JSON_XGH_MAIN
build acme_xgh.rh: m4 acme_xgh.m4
build acme_xgh.h: ragel acme_xgh.rh
#build vrum: cc2 vrum.c | acme_xgh.h

# Website

rule arb
  command=$cmd1 $in $cmd2 $out #cmd3

dnl # define(`PAGE_XS',`define(`X',`$1')`'X(home,index)`'undefine(`X')')dnl

# TODO warnings
build web/index.html: m42 web.m4 home.m4
build web/movies.html: m42 collect.m4 movies.m4 web.m4 movies.m4
build web/vehicle-building-games.html: m42 web.m4 vehicle-building-games.m4
build web/not_found.html: m42 web.m4 not_found.m4
build web/programming.html: m42 web.m4 programming.m4
build web/bookmarks.html: m42 web.m4 bookmarks.m4
build web/dead.html: m42 web.m4 dead.m4
build web/music.html: m42 base.m4 collect.m4 music.m4 web.m4 music.m4
build web/meme2.jpg: arb web/meme.jpg
  cmd1=magick
  cmd2=-resize 1200x627 -quality 100 -background "rgb(244,242,238)" -gravity center -extent 1200x627

# build web/music.html: m42 music.m4 template.m4
#  arg=-DXGH_OUTPUT=html

# vim: syntax=ninja
