define(`M4_CC',`clang -ferror-limit=1')dnl
dnl # define(`M4_CC',`gcc -fmax-errors=1')dnl
rule regen
  command=m4 $in > $out
  generator=1
rule m4
  depfile=$out.d
  deps=gcc
  command= m4 -di $in 2>&1 > $out $
         | awk '$$0~/m4debug: input read.*/{print $$5;next}$$0!~/m4debug: input.*/{print>"/dev/stderr"}' $
	 | sort | uniq | xargs echo "$out:" > $out.d
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
  command=M4_CC -MMD -MF $out.d -fdiagnostics-color=always $cflags -o $out $in
build build.ninja: regen ninja.m4
build json_xgh.c: ragel json_xgh.rl
build json_xgh: cc2 json_xgh.c
  cflags=-DIS_JSON_XGH_MAIN
build acme_xgh.rh: m4 acme_xgh.m4
build acme_xgh.h: ragel acme_xgh.rh
build vrum: cc2 vrum.c | acme_xgh.h
# vim: syntax=ninja
