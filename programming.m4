XGH_TIT(`Programming')
XGH_H(`2',`Next steps')
XGH_HUL(`3',`What I eagerly want to do next',`dnl
XGH_LI(`Try my hand at XGH_A2(`SNOBOL4',`https://www.regressive.org/snobol4/docs/burks/tutorial/contents.htm')')
XGH_LI(`Create a toy compiler with LLVM and GCC')
XGH_LI(`Adopt all testing produceres described for XGH_A2(`SQLite',`https://sqlite.org/testing.html'), specially setting up XGH_A2(`AFL++',`https://aflplus.plus/') to fuzz test my code')
XGH_LI(`Try my hand at cross compilation')
XGH_LI(`Make my first installer for Windows')
XGH_LI(`Use PGO with actual improvements')
XGH_LI(`Code coverage')
XGH_LI(`Some sort of documentation generation')
XGH_LI(`Unit tests, integration tests')
XGH_LI(`Learn what is CI/CD')
XGH_LI(`Software bill of materials (SBOM) production')
XGH_LI(`Do a n-split Ragel thing')
XGH_LI(`Experiments with SO_REUSEPORT')
XGH_LI(`Figure out code formatting for groff (already done ad nauseum by many people)')
XGH_LI(`Document and refine my dependency calculation for m4 and pic, and resource management for groff and gamedev')
XGH_LI(`Investigate ASN.1')
XGH_LI(`Return to competitive programming')
')
XGH_HUL(`3',`What terrifies me',`dnl
XGH_LI(`Binary compatibility')
XGH_LI(`Logging')
XGH_LI(`Accessbility')
')
XGH_HUL(`3',`Problems',`dnl
XGH_LI(`Automatic .gitignore for generated code')
XGH_LI(`Use m4 or a subset of it as a library for a Web server, it could generate thousands of little buffers and then we use XGH_A2(`XGH_C(`uv_write')',`https://docs.libuv.org/en/v1.x/stream.html`#'c.uv_write') to send most of all at once')
')
XGH_HUL(`3',`Flaws in my formation',`dnl
XGH_LI(`Ability to calculate time complexity of an algorithm')
XGH_LI(`Basic knowledge of concurrency primitives such as mutexes and semaphores')
')
XGH_H(`2',`Comsumption')
XGH_HUL(`3',`Books I@aq@ve read',`dnl
XGH_LI(`Effective Java, third edition')
')
XGH_HUL(`3',`Books that I own physically, but that I have not read at all',`dnl
XGH_LI(`Algorithms by CLRS')
XGH_LI(`Graphics Gems')
XGH_LI(`Practical Computer Vision Using C')
')
XGH_HUL(`3',`Books that I might read',`dnl
XGH_LI(`The fish book: Expert C Programming: Deep C Secrets')
XGH_LI(`Effective C')
XGH_LI(`Design Patterns by Erich Gamma')
')
XGH_HUL(`3',`Lists of books',`dnl
XGH_LIA(`https://4chan-science.fandom.com/wiki/Mathematics',`Mathematics | /sci/ Wiki | Fandom')
XGH_LIA(`https://github.com/EbookFoundation/free-programming-books',`free-programming-books')
XGH_LI(`Working Effectively with Legacy Code')
XGH_LI(`https://en.wikipedia.org/wiki/How_to_Design_Programs')
')
XGH_HUL(`3',`RFCs I@aq@ve read',`dnl
XGH_LIAL(`https://datatracker.ietf.org/doc/html/rfc6570')
XGH_LIA(`https://datatracker.ietf.org/doc/html/rfc2616',`RFC2616 Hypertext Transfer Protocol -- HTTP/1.1')
XGH_LIA(`https://datatracker.ietf.org/doc/html/rfc3875',`RFC3875 The Common Gateway Interface (CGI) Version 1.1')
XGH_LIA(`https://datatracker.ietf.org/doc/html/rfc1436',`RFC1436 The Internet Gopher Protocol')
XGH_LIA(`https://datatracker.ietf.org/doc/html/rfc2046',`Multipurpose Internet Mail Extensions (MIME) Part Two: Media Types')
XGH_LIA(`https://datatracker.ietf.org/doc/html/rfc3986',`RFC3986 Uniform Resource Identifier (URI): Generic Syntax')
XGH_LIA(`https://datatracker.ietf.org/doc/html/rfc4646',`RFC4646 Tags for Identifying Languages')
')
XGH_HUL(`3',`RFCs I@aq@ve not read',`dnl
XGH_LIA(`https://datatracker.ietf.org/doc/html/rfc7540',`RFC7540 Hypertext Transfer Protocol Version 2 (HTTP/2)')
XGH_LIA(`https://datatracker.ietf.org/doc/html/rfc5246',`RFC5246 The Transport Layer Security (TLS) Protocol Version 1.2')
XGH_LIA(`https://datatracker.ietf.org/doc/html/rfc8446',`RFC8446 The Transport Layer Security (TLS) Protocol Version 1.3')
')
XGH_H(`3',`Talks I@aq@ve watched')
XGH_P(`I@aq@ve watched them asychronously. This list is not ordered by watch order')
XGH_UL(`dnl
XGH_LI(`XGH_A2(`A Fast Wait-Free Hash Table',`https://www.youtube.com/watch?v=WYXgtXWejRM'): I get the gist, but I have not attempted to implement it')
XGH_LIA(`https://www.youtube.com/watch?v=8aGhZQkoFbQ',`What the heck is the event loop anyway?')
XGH_LI(`XGH_A2(`Data-Oriented Design and C++',`https://www.youtube.com/watch?v=rX0ItVEVjHc'): honestly I didn@aq@t fully get it')
XGH_LIA(`https://www.youtube.com/watch?v=ojZbFIQSdl8',`Using Types Effectively')
XGH_LIA(`https://www.youtube.com/watch?v=RHC-uGDbu7s',`In-Game Economies in Team Fortress 2 and Dota 2')
')
XGH_H(`2',`Games')
dnl # https://www.sbgames.org/
XGH_H(`3',`Where to publish')
XGH_WEB(`dnl
<table>
<thead><tr>
<th scope="col">Vendor</th>
<th scope="col">Revenue prospect</th>
<th scope="col">Target</th>
<th scope="col">Platform integration</th>
<th scope="col">Documentation</th>
</tr></thead>
<tbody>
<tr>
 <th scope="row">Newgrounds</th>
 <td>free</td>
 <td>Web</td>
 <td>medals, leaderboards and shared creations</td>
 <td><a href="https://www.newgrounds.io/get-started/">Newgrounds.io</a></td>
</tr>
<tr>
 <th scope="row">Steam</th>
 <td>sellable</td>
 <td>native</td>
 <td></td>
 <td><a href="https://partner.steamgames.com/doc/features?l=english">Steamworks</a></td>
</tr>
<tr>
 <th scope="row">Netflix</th>
</tr>
<tr>
 <th scope="row">Snapchat</th>
</tr>
<tr>
 <th scope="row">Discord Activities</th>
 <td></td>
 <td></td>
 <td></td>
 <td><a href="https://docs.discord.com/developers/activities/overview">link</a></td>
</tr>
<tr>
 <th scope="row">Itch.io</th>
 <td>sellable</td>
 <td>Web and native</td>
 <td colspan="2">none afaik</td>
</tr>
<tr>
 <th scope="row">Play Store</th>
</tr>
<tr>
 <th scope="row">App Store</th>
</tr>
<tr>
 <th scope="row">YouTube Playables</th>
 <td></td>
 <td>Web</td>
 <td></td>
 <td><a href="https://developers.google.com/youtube/gaming/playables">link</a></td>
</tr>
</tbody>
</table>
')
dnl # XGH_H(`2',`m4')
dnl # XGH_P(`Here@aq@s how I@aq@m commenting stuff:')
dnl # XGH_WEB(`<code>dnl # <code>')
XGH_HUL(`2',`Disorganized link dump',`dnl
XGH_LIAL(`https://unicode.org/mail-arch/unicode-ml/Archives-Old/UML023/1344.html')
XGH_LIAL(`https://github.com/berkeley-abc/abc')
XGH_LIAL(`https://mbreen.com/m4.html')
XGH_LIAL(`https://c-faq.com/decl/spiral.anderson.html')
XGH_LIAL(`https://mbreen.com/breenStatecharts.pdf')
XGH_LIAL(`https://github.com/pragma-/Plang/tree/master/doc`#'uniform-function-call-syntax')
XGH_LIAL(`https://github.com/Rhizomatica/uucp')
XGH_LIAL(`https://git.skarnet.org/cgit/skalibs/tree/README')
XGH_LIAL(`https://skarnet.org/software/s6/s6-fdholder-daemon.html')
XGH_LIAL(`https://www.arp242.net/my-first-vimrc')
XGH_LIAL(`https://zem.fi/tmp/c/snippet-linkage.txt')
XGH_LIAL(`https://slugcat.systems/post/25-09-21-dxgi-debugging-microsoft-put-me-on-a-list/')
XGH_LIAL(`https://www.open-std.org/jtc1/sc22/wg14/www/docs/summary.htm`#'dr_476')
XGH_LIAL(`https://drive.google.com/file/d/0B-3PfyBhOSOxOTdjYmM1N2ItMmE0ZC00OGE3LTllODUtZDNkMDMzYWU3NDlk/view')
XGH_LIAL(`https://www.gnu.org/software/m4/manual/html_node/History.html')
XGH_LIAL(`https://www.wholetomato.com/')
XGH_LIAL(`https://sourceforge.net/p/pigiron/svn/HEAD/tree/trunk/pigiron/piggen/')
XGH_LIAL(`https://github.com/jsoftware/jsource')
XGH_LIAL(`https://www.tuhs.org/cgi-bin/utree.pl?file=V7/usr/src/cmd/sh/service.c')
XGH_LIAL(`https://www.tuhs.org/cgi-bin/utree.pl?file=V7/usr/src/cmd/sh/mac.h')
XGH_LIAL(`https://github.com/zpl-c/enet')
XGH_LIAL(`https://natureofcode.com/')
XGH_LIAL(`https://lwn.net/Articles/832121')
XGH_LIAL(`https://github.com/vlm/asn1c')
XGH_LIAL(`https://devblogs.microsoft.com/oldnewthing/20140627-00/?p=633')
XGH_LIAL(`https://web.archive.org/web/20180421175051/https://lanedo.com/filesystem-monitoring-linux-kernel/')
XGH_LIAL(`https://web.archive.org/web/20260414000308/https://eklitzke.org/unexpected-places-you-can-and-cant-use-null-bytes')
XGH_LIAL(`https://embeddedartistry.com/course/heapless/')
XGH_LIAL(`https://graphics.pixar.com/library/OrthonormalB/paper.pdf')
XGH_LIAL(`https://github.com/git/git/blame/master/banned.h')
XGH_LIAL(`http://number-none.com/product/Understanding%20Slerp,%20Then%20Not%20Using%20It/')
XGH_LIAL(`https://blog.demofox.org/2016/02/19/normalized-vector-interpolation-tldr/')
XGH_LIAL(`https://remysharp.com/2019/09/10/blocks-of-tetris-code')
XGH_LI(`-fno-semantic-interposition')
XGH_LIAL(`http://gamedev.tutsplus.com/articles/business-articles/web-game-sponsorship/')
XGH_LIAL(`https://www.codeandweb.com/texturepacker')
XGH_LIAL(`https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/p1428r0.pdf')
XGH_LIAL(`https://www.youtube.com/watch?v=dCTyu3awI1A')
XGH_LIAL(`https://newosxbook.com/articles/MemoryPressure.html')
XGH_LI(`terraform + ansible')
XGH_LI(`clangd + LSP')
XGH_LI(`malloc_zone_pressure_relief')
XGH_LIAL(`https://stefansf.de/post/type-based-alias-analysis/')
XGH_LIAL(`https://floooh.github.io/2017/02/22/emsc-html.html')
XGH_LIAL(`https://github.com/tensorflow/tensorflow/blob/master/tensorflow/c/c_api.h')
XGH_LI(`LVGL')
XGH_LIAL(`https://github.com/nicbarker/clay')
XGH_LI(`ECL and C-Mera')
XGH_LIAL(`https://github.com/graphitemaster/incbin')
XGH_LIAL(`https://defs.ircdocs.horse/info/formatting')
XGH_LIAL(`https://defs.ircdocs.horse/')
XGH_LIAL(`https://www-archive.mozilla.org/projects/intl/input-method-spec.html')
XGH_LIAL(`https://www.dicas-l.com.br/arquivo/find_+_xargs.php')
XGH_LIAL(`https://www.youtube.com/watch?v=w3_e9vZj7D8')
XGH_LIAL(`https://web.archive.org/web/20170830125905/https://blogs.msdn.microsoft.com/oldnewthing/20040119-00/?p=41003')
XGH_LIAL(`https://github.com/rose-compiler/rose')
XGH_LIAL(`https://jadlevesque.github.io/PPMP-Iceberg/')
XGH_LIAL(`https://cseweb.ucsd.edu/classes/sp00/cse231/dynamopldi.pdf')
XGH_LIAL(`http://phodd.net/gnu-bc/')
XGH_LIAL(`https://insanecoding.blogspot.com/2007/11/pathmax-simply-isnt.html')
XGH_LIAL(`https://nakst.gitlab.io/tutorial/ui-part-1.html')
XGH_LIAL(`https://web.archive.org/web/20090421080714/http://www.cpax.org.uk/prg/portable/c/c++/rfe00000.html')
XGH_LIAL(`https://shintakezou.blogspot.com/2017/03/length-at-compile-time.html')
XGH_LIA(`https://devblogs.microsoft.com/oldnewthing/20200103-00/?p=103290',`Anybody who writes XGH_CI(``#'pragma pack(1)') may as well just wear a sign on their forehead that says "I hate RISC"')
XGH_LI(`Dave Cutler')
XGH_LIAL(`https://depts.washington.edu/acelab/proj/dollar/index.html')
XGH_LI(`Signed distance function')
XGH_LIAL(`https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function')
XGH_LIAL(`https://en.wikipedia.org/wiki/MurmurHash')
XGH_LIAL(`https://en.wikipedia.org/wiki/Open_addressing')
XGH_LI(`Split-horizon DNS')
XGH_LIAL(`https://www.getlazarus.org/pool/vectors/')
XGH_LIAL(`https://sourceforge.net/p/predef/wiki/Home/')
XGH_LIAL(`https://github.com/andrewrk/malcheck')
XGH_LIA(`https://matt.sh/howto-c',`how to c (as of 2016)')
XGH_LIA(`https://stackoverflow.com/questions/1674032/static-const-vs-define-vs-enum',`c - "static const" vs "`#'define" vs "enum" - Stack Overflow')
XGH_LIA(`http://sekrit.de/webdocs/c/beginners-guide-away-from-scanf.html',`A beginners@aq@ guide XGH_IT(`away') from scanf()')
XGH_LI(`Quote from Peter van der Linden in book Expert C Programming: "strong typing just means pounding extra hard on the keyboard"')
XGH_LIA(`https://www.kernel.org/doc/html/latest/process/coding-style.html',`Linux kernel coding style — The Linux Kernel documentation')
XGH_LIA(`https://www.cis.upenn.edu/~lee/06cse480/data/cstyle.ms.pdf',`cstyle.ms.pdf')
XGH_LIA(`https://nginx.org/en/docs/dev/development_guide.html`#'code_style',`Development guide`#'coding_style')
XGH_LIAL(`https://github.com/flutter/flutter/blob/master/docs/contributing/Style-guide-for-Flutter-repo.md`#'lazy-programming')
XGH_LI(`Tools like GNU indent')
XGH_LIA(`https://wiki.sei.cmu.edu/confluence/display/c/SEI+CERT+C+Coding+Standard',`SEI CERT C Coding Standard - SEI CERT C Coding Standard - Confluence')
XGH_LIA(`https://cellperformance.beyond3d.com/articles/2006/06/understanding-strict-aliasing.html',`Understanding Strict Aliasing')
XGH_LIA(`https://cellperformance.beyond3d.com/articles/2006/05/demystifying-the-restrict-keyword.html',`Demystifying The Restrict Keyword')
XGH_LIA(`https://www.lysator.liu.se/c/restrict.html',`Restricted Pointers in C (Draft 2), X3J11.1 93-006')
XGH_LIA(`http://www.robertgamble.net/2012/01/c11-generic-selections.html',`Generic Selections')
XGH_LIA(`http://www.robertgamble.net/2012/01/c11-static-assertions.html',`Static Assertions')
XGH_LIA(`https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_73/rzarg/static_array_index.htm',`Static array indices in function parameter declarations (C only)')
XGH_LIA(`https://graphics.stanford.edu/~seander/bithacks.html',`Bit Twiddling Hacks')
XGH_LIA(`http://www.catb.org/esr/structure-packing/',`The Lost Art of Structure Packing')
XGH_LIA(`http://locklessinc.com/articles/pthreads_on_windows/',`Pthreads on Microsoft Windows')
XGH_LIA(`https://computing.llnl.gov/tutorials/linux_clusters/gpu/NVIDIA.Introduction_to_CUDA_C.1.pdf',`Slide 1 - NVIDIA.Introduction_to_CUDA_C.1.pdf')
XGH_LIA(`https://computing.llnl.gov/tutorials/mpi/',`Message Passing Interface (MPI)')
XGH_LIA(`https://computing.llnl.gov/tutorials/parallel_comp/',`Introduction to Parallel Computing')
XGH_LIA(`https://computing.llnl.gov/tutorials/pthreads/',`POSIX Threads Programming')
XGH_LIA(`https://computing.llnl.gov/tutorials/openMP/',`OpenMP')
XGH_LIA(`https://github.com/kozross/awesome-c',`Awesome C')
XGH_LIA(`https://en.cppreference.com/w/c/links/libs',`open source C libraries')
XGH_LIA(`https://en.wikipedia.org/wiki/Category:C_(programming_language)_libraries',`Category:C (programming language) libraries - Wikipedia')
XGH_LIA(`https://github.com/nothings/single_file_libs',`List of single-file C/C++ libraries')
XGH_LIA(`https://www.tapirgames.com/blog/open-source-physics-engines',`Full List Of Open Source Physics Engines * Blog')
XGH_LIA(`https://github.com/RandyGaul/cute_headers',`RandyGaul/cute_headers: One-file C/C++ libraries with no dependencies, primarily used for games')
XGH_LIA(`https://nemequ.github.io/hedley/',`Hedley')
XGH_LIA(`https://github.com/orangeduck/mpc',`orangeduck/mpc: A Parser Combinator library for C')
XGH_LIA(`https://github.com/orangeduck/Corange',`orangeduck/Corange: Pure C Game Engine')
XGH_LIA(`https://www.hboehm.info/gc/',`A garbage collector for C and C++')
XGH_LIA(`https://frankforce.com/frank-engine/',`The Frank Engine | Killed By A Pixel')
XGH_LIA(`http://www.leonerd.org.uk/code/libtickit/',`libtickit')
XGH_LIA(`https://libuv.org/',`libuv | Cross-platform asynchronous I/O')
XGH_LIA(`https://github.com/Immediate-Mode-UI/Nuklear',`Immediate-Mode-UI/Nuklear: A single-header ANSI C immediate mode cross-platform GUI library')
XGH_LIA(`https://www.raylib.com/',`raylib')
XGH_LIA(`https://github.com/wmcbrine/PDCurses',`wmcbrine/PDCurses: PDCurses - a curses library for environments that don@aq@t fit the termcap/terminfo model')
XGH_LIA(`http://www.cs.gordon.edu/courses/cs320/handouts/C_C++_Syntax_vs_Pascal.html',`A Comparison of the Syntax of C/C++ and Pascal')
XGH_LIA(`git://leontynka.twibright.com/links.git',`links Git repository')
XGH_LIA(`https://www.boost.org/doc/libs/release/libs/preprocessor/',`Boost.Preprocessor')
XGH_LIA(`http://iso-9899.info/wiki/Books',`Books - C')
XGH_LIA(`https://www.gafferongames.com/',`Gaffer On Games')
XGH_LIA(`https://gitlab.com/openconnect/openconnect/-/blob/master/compat.c',`compat.c · master · OpenConnect VPN projects / OpenConnect · GitLab')
XGH_LIA(`https://github.com/ncm/selectable-socketpair/blob/master/socketpair.c',`selectable-socketpair/socketpair.c at master · ncm/selectable-socketpair')
XGH_LIA(`https://wiki.installgentoo.com/wiki/Programming_resources',`Programming resources - InstallGentoo Wiki')
XGH_LIA(`https://cses.fi/book/book.pdf',`book.pdf')
XGH_LIA(`http://www.brendangregg.com/books.html',`Books - Brendan Gregg')
XGH_LIA(`https://github.com/jpoirier/picoc',`jpoirier/picoc: A very small C interpreter')
XGH_LIA(`https://www.absint.com/astree/index.htm',`Astrée Static Analyzer for C and C++')
XGH_LIA(`http://www.ganssle.com/',`The Ganssle Group')
XGH_LIA(`https://old.reddit.com/r/C_Programming/',`C subreddit')
XGH_LIA(`http://www.nongnu.org/avr-libc/',`AVR Libc Home Page')
XGH_LIA(`https://web.archive.org/web/20210727070230/https://gist.github.com/zneak/5ccbe684e6e56a7df8815c3486568f01',`Quirks of C')
XGH_LIA(`https://web.archive.org/web/20210615002823/http://beefchunk.com/documentation/lang/c/pre-defined-c/precomp.html',`Pre-defined C/C++ Compiler Macros')
XGH_LIA(`http://poormansprofiler.org/',`poor man@aq@s profiler')
XGH_LIAL(`https://github.com/Celtoys/Remotery/')
XGH_LIA(`https://github.com/libav/c99-to-c89',`c99-to-c89')
XGH_LIA(`https://github.com/thradams/cake',`cake')
XGH_LIA(`https://sarifweb.azurewebsites.net/',`SARIF')
XGH_LI(`like polyfill for C. can@aq@t place keyword restrict inside array subscript of function prototype in MSVC')
XGH_LI(`Generate C code from pic specifications')
XGH_LI(`put m4 or groff inside C comments and extract as a form of documentation')
XGH_LI(`beautifier/formatter for Ragel')
XGH_LIA(`https://lwn.net/Articles/542629/',`The SO_REUSEPORT socket option')
XGH_LIA(`https://lwn.net/Articles/853637/',`Avoiding unintended connection failures with SO_REUSEPORT')
XGH_LIA(`https://www.funtoo.org/Bash_by_Example,_Part_1',`Bash by Example, Part 1')
XGH_LIA(`https://www.funtoo.org/Bash_by_Example,_Part_2',`Bash by Example, Part 2')
XGH_LIA(`https://www.funtoo.org/Bash_by_Example,_Part_3',`Bash by Example, Part 3')
XGH_LIA(`https://www.funtoo.org/Awk_by_Example,_Part_1',`Awk by Example, Part 1')
XGH_LIA(`https://www.funtoo.org/Awk_by_Example,_Part_2',`Awk by Example, Part 2')
XGH_LIA(`https://www.funtoo.org/Awk_by_Example,_Part_3',`Awk by Example, Part 3')
XGH_LIA(`https://www.funtoo.org/Sed_by_Example,_Part_1',`Sed by Example, Part 1')
XGH_LIA(`https://www.funtoo.org/Sed_by_Example,_Part_2',`Sed by Example, Part 2')
XGH_LIA(`https://www.funtoo.org/Sed_by_Example,_Part_3',`Sed by Example, Part 3')
XGH_LIA(`https://www.chiark.greenend.org.uk/%7Esgtatham/quasiblog/c11-generic/',`Workarounds for C11 _Generic')
XGH_LIA(`https://www.chiark.greenend.org.uk/~sgtatham/coroutines.html',`Coroutines in C')
XGH_LIA(`https://www.cs.cornell.edu/courses/cs403/2003sp/Lecture06/makefile.html',`How to write a Makefile')
XGH_LIAL(`https://www.cs.cornell.edu/courses/cs403/2003sp/Lecture06/makefile.html')
XGH_LIAL(`https://people.freedesktop.org/~dbn/pkg-config-guide.html')
XGH_LIA(`https://nullprogram.com/blog/2017/08/20/',`A Tutorial on Portable Makefiles')
XGH_LIA(`https://aegis.sourceforge.net/auug97.pdf',`Recursive Make Considered Harmful')
XGH_LIAL(`https://pubs.opengroup.org/onlinepubs/9799919799/utilities/make.html')
XGH_LIA(`https://github.com/pete-gordon/planet-hively/blob/master/makefile',`https://github.com/pete-gordon/planet-hively/blob/master/makefile')
XGH_LIA(`https://locklessinc.com/articles/makefile_tricks/',`https://locklessinc.com/articles/makefile_tricks/')
XGH_LI(`How do you do a canary? what does that mean in programming')
XGH_LI(`one single error namespace')
XGH_LI(`monadic error style')
XGH_LIAL(`https://errors.haskell.org/index.html')
XGH_LIAL(`https://www.cairographics.org/manual/bindings-errors.html')
XGH_LI(`wrap errors from underlying libraries (mapping trick)')
XGH_LI(`collecting errors using reflection is banned')
XGH_LI(`game with mass destruction like Dragon Ball')
XGH_LIA(`https://www.chiark.greenend.org.uk/~sgtatham/putty/wishlist/mosh.html',`mosh in putty')
XGH_LIA(`https://devblogs.microsoft.com/oldnewthing/20170714-00/?p=96605',`counterpoint to Unicode parrots')
XGH_LIA(`https://www.buildbot.net/',`Buildbot')
XGH_LIA(`https://www.youtube.com/watch?v=8Z685OF-PS8',`A New Way to look at Networking')
XGH_LIA(`https://puredata.info/',`Pure Data')
XGH_LIA(`https://github.com/google/re2',`google/re2')
XGH_LIA(`https://tldp.org/',`The Linux Documentation Project')
')
XGH_HUL(`2',`Webdevus',`dnl
XGH_LIAL(`https://dnsviz.net/')
XGH_LIAL(`https://yahooeng.tumblr.com/post/96098168666/important-announcement-regarding-yui')
XGH_LIAL(`https://whatsmyname.app/')
XGH_LIAL(`https://web.dev/articles/same-origin-policy')
XGH_LIAL(`https://cross-origin-isolation.glitch.me/coop')
XGH_LIAL(`https://www.chromium.org/Home/chromium-security/site-isolation/')
XGH_LIAL(`https://web.dev/articles/coop-coep')
XGH_LIAL(`https://web.dev/articles/why-coop-coep')
XGH_LIAL(`https://security.googleblog.com/2009/03/reducing-xss-by-way-of-automatic.html')
XGH_LIAL(`https://developer.mozilla.org/en-US/docs/Web/HTML/Content_categories')
XGH_LIAL(`https://www.irongeek.com/homoglyph-attack-generator.php')
XGH_LIAL(`https://zaplib.com/docs/blog_post_mortem.html')
XGH_LIAL(`https://ianjk.com/webassembly-vs-javascript')
XGH_LIAL(`https://web.archive.org/web/20260611194553/http://clearsilver.net/')
XGH_LI(`HTML tidy')
XGH_LIA(`https://validator.w3.org/',`The W3C Markup Validation Service')
XGH_LIA(`https://css-tricks.com/snippets/css/a-guide-to-flexbox/',`A Complete Guide to Flexbox | CSS-Tricks')
XGH_LIA(`https://css-tricks.com/snippets/css/complete-guide-grid',`A Complete Guide to Grid | CSS-Tricks')
XGH_LIA(`https://www.w3.org/Tools/',`Tools for WWW providers')
')
XGH_HUL(`2',`2+2-1=3, quick maths',`dnl
XGH_LIA(`https://www.mathe-fa.de/pt/',`Plotador Matemático MAFA')
')
XGH_HUL(`2',`Building, packaging',`dnl
xGH_LIAL(`https://github.com/twisted/towncrier')
XGH_LIA(`https://github.com/runestubbe/Crinkler',`runestubbe/Crinkler: Crinkler is an executable file compressor')
XGH_LIAL(`https://www.codegic.com/')
XGH_LIAL(`https://tonsky.me/blog/python-build/')
XGH_LIAL(`https://www.shlomifish.org/open-source/anti/autohell/')
')
XGH_HUL(`2',`Version control, legalese, licenses',`dnl
XGH_LIAL(`https://old.reddit.com/user/VideoGameAttorney/submitted/?sort=top')
XGH_LIAL(`https://en.wikipedia.org/wiki/Fair_License')
XGH_LIAL(`https://issues.apache.org/jira/browse/LEGAL-303')
XGH_LIAL(`https://notlegaladvice.law/')
XGH_LI(`Developer Certificate of Origin')
XGH_LIAL(`https://fedoraproject.org/wiki/Licensing:MIT?rd=Licensing/MIT#Old_Style')
XGH_LIAL(`https://opensource.guide/legal/')
XGH_LIAL(`https://en.wikipedia.org/wiki/Open_source_license_litigation')
XGH_LIAL(`https://spdx.org/licenses/Libtool-exception.html')
XGH_LIAL(`https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9263265')
XGH_LIAL(`https://en.wikipedia.org/wiki/File:Joseph_Ferdinand_Keppler_-_The_Pirate_Publisher_-_Puck_Magazine_-_Restoration_by_Adam_Cuerden.jpg')
XGH_LIAL(`https://spdx.dev/use/spdx-tools/')
XGH_LIAL(`https://web.archive.org/web/20190312190935/http://stlr.org/2018/10/15/the-truth-about-oss-frand-by-all-indications-compatible-models-in-standards-settings/')
XGH_LIAL(`https://polyformproject.org/')
XGH_LIAL(`https://abi-laboratory.pro/?view=timeline&l=libtomcrypt')
XGH_LIA(`https://git-scm.com/book/en/v2',`Git Pro Book')
XGH_LIA(`https://wiki.creativecommons.org/wiki/Main_Page',`Creative Commons')
XGH_LIA(`https://tldp.org/HOWTO/Software-Release-Practice-HOWTO/patching.html',`Good patching practice')
XGH_LIA(`http://www.kegel.com/academy/opensource.html',`Contributing to Open Source Projects HOWTO')
')
XGH_HUL(`2',`Competitive programming, contests, challenges and puzzles',`dnl
XGH_LIA(`https://en.wikipedia.org/wiki/ICFP_Programming_Contest',`ICFP Programming Contest - Wikipedia')
XGH_LIAL(`https://www.robopenguins.com/fatal_core_dump/')
')
XGH_HUL(`2',`Computer graphics',`dnl
XGH_LIAL(`https://web.archive.org/web/20120320184928/http://www.valvesoftware.com/publications/2007/SIGGRAPH2007_AlphaTestedMagnification.pdf')
XGH_LIAL(`https://opengl.gpuinfo.org/')
XGH_LIAL(`https://stackoverflow.com/a/50264651')
XGH_LI(`real-time intermediate flow estimation for video frame interpolation')
XGH_LI(`depth-aware video frame interpolation')
XGH_LIAL(`https://aras-p.info/blog/2017/02/05/Every-Possible-Scalability-Limit-Will-Be-Reached/')
XGH_LIAL(`https://old.reddit.com/r/GraphicsProgramming/comments/104q9ww/precision_highp_mediump_lowp_in_webglopengl/j36m110/')
XGH_LI(`virtools/3DVIA web player')
XGH_LI(`Tracy')
XGH_LIAL(`https://developer.nvidia.com/content/alpha-blending-pre-or-not-pre')
XGH_LIAL(`https://www.mathematische-basteleien.de/heart.htm')
XGH_LIAL(`https://fourcc.org/fccyvrgb.php')
XGH_LIAL(`https://alvyray.com/Memos/CG/Microsoft/6_pixel.pdf')
XGH_LIAL(`https://jcgt.org/read.html')
XGH_LIAL(`https://www.getlazarus.org/pool/balls/')
XGH_LIAL(`https://www.jmeiners.com/Hugo-Elias-Radiosity/')
XGH_LIAL(`https://web.archive.org/web/20160511192712/http://freespace.virgin.net/hugo.elias/radiosity/radiosity.htm')
XGH_LIAL(`https://www.parallelrealities.co.uk/tutorials/')
XGH_LIAL(`https://github.com/grimfang4/sdl-gpu')
XGH_LIA(`http://www.fmwconcepts.com/imagemagick/index.php',`Fred@aq@s ImageMagick Scripts')
XGH_LIA(`https://github.com/mxgmn',`mxgmn (Maxim Gumin)')
XGH_LIA(`https://thebookofshaders.com/',`The Book of Shaders')
XGH_LIA(`https://lazyfoo.net/tutorials/OpenGL/index.php',`Lazy Foo@aq@ Productions - OpenGL Tutorials')
XGH_LIA(`https://lazyfoo.net/tutorials/SDL/',`Lazy Foo@aq@ Productions - Beginning Game Programming v2.0')
XGH_LIA(`https://www.fundza.com/index.html',`CG References & Tutorials')
')
XGH_HUL(`2',`Audio and video',`dnl
XGH_LIA(`https://wiki.hydrogenaud.io/index.php?title=Topic_Index',`Topic Index - Hydrogenaudio Knowledgebase')
XGH_LI(`replay regain, ffmpeg')
XGH_LIA(`https://ottverse.com/i-p-b-frames-idr-keyframes-differences-usecases/')
')
dnl # .PS
dnl # box "MS Word" wid 1.5
dnl # line <- "NÃO" "" 1
dnl # box "Você é um imbecil?" wid 2
dnl # arrow at last box.s down " SIM" ljust
dnl # DRONE: box "Você é um drone do software livre" "que sonha pelo ano do desktop Linux?" wid 4 ht 0.75
dnl # arrow at last box.w left "SIM" "" 1
dnl # box "LibreOffice" "Writer" wid 1.5
dnl # arrow at DRONE.s down " NÃO" ljust
dnl # BURRO: box "Você é tão burro que recursos básicos não fazem falta?" wid 6
dnl # arrow at last box.w left "SIM" "" 1
dnl # box "Google Docs" wid 1.5
dnl # arrow at BURRO.s down " NÃO" ljust
dnl # SHIT: box \
dnl # "Você quer usar \fItemplates\fP e pacotes prontos para" \
dnl # "aderir à norma rapidamente sem questionar nada, e" \
dnl # "então desafiar sua sanidade realizando ajustes finos?" \
dnl # wid 7 ht 1
dnl # arrow at last box.w left "SIM" "" 1
dnl # box "LaTeX" wid 1.5
dnl # arrow at SHIT.s down " NÃO" ljust
dnl # box "Groff"
dnl # arrow at last box.w left
dnl # box invis "Não se esqueça que" "você ainda é um imbecil" wid 3
dnl # .PE
dnl # Ragel: Exercise 1-8 [p. 22] from K&R: count lines
dnl # Ragel: Exercise 1-23 from K&R: remove comments from a C source
dnl # Ragel: parse command line options (check POSIX)
dnl # Ragel: parse items such as: CPF, CNPJ, phone numbers, e-mail addresses, URLs (specific and generic), dates, such as birthday
dnl # Ragel: check if parenthesis are balanced
dnl # Ragel: check parenthesis, braces and brackets are balanced
dnl # Ragel: read JSON (e.g. https://doc.mapeditor.org/en/stable/reference/json-map-format/)
dnl # Ragel: read XML
dnl # .TS
dnl # center allbox;
dnl # cB cB cB
dnl # l l l.
dnl # Construção	Separador	Separador após último item
dnl # Lista de constantes de enumerador	Vírgula	Desde C99, sim
dnl # Várias funções em uma unidade de tradução	Nenhum
dnl # Vários \fCcase\fP em uma expressão \fCswitch\fP
dnl # Um bloco de código com vários \fIstatements\fP	Ponto e vírgula	Obrigatório
dnl # Lista de parâmetros	Vírgula	Proibido
dnl # Uma expressão	Operadores	Proibido
dnl # \fIstatements\fP primários	Ponto e vírgula	Obrigatório
dnl # .TE
XGH_HUL(`2',`Optimilaziations',`dnl
XGH_LIAL(`https://web.archive.org/web/20251217090805/https://cgit.freedesktop.org/cairo-traces/')
XGH_LI(`HTCondor')
XGH_LIAL(`https://www.llvm.org/docs/HowToBuildWithPGO.html')
XGH_LI(`Communicating Sequential Processes ')
XGH_LI(`Lock striping')
XGH_LIAL(`https://web.archive.org/web/20170707064110/https://software.intel.com/en-us/articles/32-openmp-traps-for-c-developers')
XGH_LIAL(`https://github.com/google/nsync')
XGH_LIA(`https://github.com/facebookincubator/BOLT',`facebookincubator/BOLT: Binary Optimization and Layout Tool')
XGH_LIA(`https://www.agner.org/optimize/',`Software optimization resources. C++ and assembly. Windows, Linux, BSD, Mac OS X')
XGH_LIA(`http://www.brendangregg.com/perf.html',`Linux perf Examples')
XGH_LIA(`https://cellperformance.beyond3d.com/articles/index.html',`CellPerformance')
')
XGH_HUL(`2',`Typography, typesetting, document processing',`dnl
XGH_LIAL(`https://en.wikipedia.org/wiki/Calibri#In_crime_and_politics')
XGH_LIAL(`https://labelary.com/')
XGH_LIAL(`https://tkurtbond.github.io/troff/mm-all.pdf')
XGH_LIAL(`https://codeberg.org/pjfichet')
XGH_LIAL(`https://pjfichet.github.io/utroff/index.html')
XGH_LIAL(`https://rfpit.org/persianword/poetry')
XGH_LIA(`https://www.schaffter.ca/mom/momdoc/definitions.html',`Mom -- Definitions and Terms')
XGH_LIA(`http://www.faqs.org/faqs/text-faq/',`comp.text Frequently Asked Questions')
XGH_LIAL(`http://tipografos.net/glossario/pdf.html')
')
XGH_HUL(`2',`Rice',`dnl
XGH_LIA(`https://github.com/djpohly/dwl',`djpohly/dwl: dwm for Wayland')
XGH_LIA(`https://bbs.archlinux.org/viewtopic.php?id=161740',`A Noobs Quest to Understanding dwm [and window managers in general] / Newbie Corner / Arch Linux Forums')
XGH_LIA(`https://news.ycombinator.com/item?id=11070797',`Ask HN: What do you use to manage dotfiles? | Hacker News')
')
XGH_HUL(`2',`Unicode (nightmare)',`dnl
XGH_LIAL(`https://www.unicode.org/notes/tn12/#Software_16')
XGH_LIA(`http://utf8everywhere.org/',`UTF-8 Everywhere')
XGH_LIA(`https://www.cl.cam.ac.uk/~mgk25/unicode.html',`UTF-8 and Unicode FAQ')
XGH_LIAL(`https://www.cogsci.ed.ac.uk/~richard/utf-8.cgi')
')
XGH_HUL(`2',`Memory management',`dnl
XGH_LIA(`https://www.memorymanagement.org/',`Home — Memory Management Reference 4.0 documentation')
')
XGH_HUL(`2',`Tooling',`dnl
XGH_LIA(`https://www.in-ulm.de/~mascheck/various/uuoc/',`Useful use of cat(1)')
XGH_LIA(`https://sanctum.geek.nz/arabesque/actually-using-ed/',`Actually using ed | Arabesque')
XGH_LIA(`https://stackoverflow.com/questions/91791/grep-and-sed-equivalent-for-xml-command-line-processing',`Grep and Sed Equivalent for XML Command Line Processing - Stack Overflow')
XGH_LIAL(`https://www.xml.com/pub/a/98/08/xmlqna0.html')
XGH_LIAL(`https://github.com/rofl0r/order-pp')
XGH_LIA(`https://beyondgrep.com/more-tools/',`More tools for searching source code')
XGH_LIA(`https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces',`vim - Redefine tab as 4 spaces - Stack Overflow')
')
XGH_HUL(`2',`Code generation',`dnl
XGH_LIA(`https://www.colm.net/open-source/ragel/',`Ragel State Machine Compiler')
')
XGH_HUL(`2',`Testing',`dnl
XGH_LIA(`https://dwheeler.com/essays/apple-goto-fail.html',`The Apple goto fail vulnerability: lessons learned')
XGH_LIA(`https://stackoverflow.com/questions/65820/unit-testing-c-code',`Unit Testing C Code - Stack Overflow')
XGH_LIAL(`https://fuzzing-project.org/')
XGH_LI(`csmith, yarpgen')
XGH_LIAL(`https://github.com/AFLplusplus/AFLplusplus')
XGH_LIAL(`https://en.wikipedia.org/wiki/Chaos_engineering')
XGH_LIAL(`https://github.com/csmith-project/creduce')
')
XGH_HUL(`2',`The C programming language',`dnl
XGH_LIAL(`https://web.archive.org/web/20230415080253/https://ramblings.implicit.net/c/2014/04/20/c-is-not-a-try-it-and-see-language.html')
XGH_LIA(`https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3787.pdf',`Array constant expressions (C2y proposal)')
XGH_LIAL(`http://unixwiz.net/techtips/reading-cdecl.html')
XGH_LIAL(`http://www.lysator.liu.se/c/')
')
XGH_HUL(`2',`Checksums',`dnl
XGH_LIAL(`https://barrgroup.com/embedded-systems/how-to/additive-checksums')
XGH_LIAL(`https://barrgroup.com/Embedded-Systems/How-To/CRC-Math-Theory')
XGH_LIAL(`https://barrgroup.com/Embedded-Systems/How-To/CRC-Calculation-C-Code')
XGH_LIAL(`https://www.zlib.net/crc_v3.txt')
')
XGH_HUL(`2',`Geometry',`dnl
XGH_LIAL(`https://dyn4j.org/2010/01/sat/')
XGH_LIAL(`https://vcg.isti.cnr.it/~ponchio/download/ponchio_phd.pdf')
XGH_LIAL(`https://github.com/KarypisLab/METIS')
')
XGH_HUL(`2',`Free assets',`dnl
XGH_LIAL(`https://www.findsounds.com/')
XGH_LIAL(`https://www.soundeffectsplus.com/')
XGH_LIAL(`https://freesound.org/')
')
XGH_HUL(`2',`Lei Rouanet e Lei do Audiovisual',`dnl
XGH_LIAL(`http://www.planalto.gov.br/ccivil_03/leis/l9609.htm')
XGH_LIAL(`https://www12.senado.leg.br/noticias/materias/2024/05/06/marco-legal-dos-jogos-eletronicos-entra-em-vigor')
XGH_LIAL(`https://www1.folha.uol.com.br/fsp/ilustrad/fq0605200908.htm')
XGH_LIAL(`https://institutodea.com/artigo/lei-rouanet-acessibilidade-na-in-no-23-25/')
XGH_LIAL(`https://www.rscriativo.rs.gov.br/mystimor-studio')
XGH_LIAL(`https://www.rscriativo.rs.gov.br/beta-2-games')
XGH_LIAL(`https://www.rscriativo.rs.gov.br/burning-goat-studio')
XGH_LIAL(`https://sict.rs.gov.br/edital-gamers-07-2023')
')
XGH_HUL(`2',`Code maintenance (X Macros and friends)',`dnl
XGH_LIAL(`https://github.com/SELinuxProject/selinux/blob/main/libselinux/src/selinux_config.c#L62-L87')
XGH_LIAL(`https://github.com/SELinuxProject/selinux/blob/main/libselinux/src/file_path_suffixes.h')
XGH_LIAL(`https://crates.io/crates/xmacro_lib')
XGH_LIAL(`https://searchfox.org/mozilla-central/source/js/public/friend/ErrorNumbers.msg')
XGH_LIAL(`https://quuxplusone.github.io/blog/2021/02/01/x-macros/')
XGH_LIAL(`https://wiki.c2.com/?ObjectOrientedAssembler')
XGH_LIAL(`https://gist.github.com/linneman/99ff9ff86d7b4c69604b012bfcc4c258')
XGH_LIAL(`http://www.50ply.com/blog/2013/04/19/eliminate-parallel-lists-with-higher-order-macros/')
XGH_LIAL(`https://github.com/Crell/enum-comparison')
XGH_LIAL(`https://docs.oracle.com/javase/1.5.0/docs/guide/language/enums.html')
XGH_LIAL(`https://blog.demofox.org/2013/05/03/macro-lists-for-the-win/')
XGH_LIAL(`https://blog.demofox.org/2013/05/07/macro-lists-for-the-win-side-b/')
XGH_LIAL(`https://blog.demofox.org/2013/05/11/lists-of-macro-lists/')
')
XGH_HUL(`2',`Object orientation',`dnl
XGH_LIAL(`http://www.angelikalanger.com/GenericsFAQ/JavaGenericsFAQ.html')
')
XGH_HUL(`2',`Flash',`dnl
XGH_LIAL(`https://animatearchive.neocities.org/?home')
')
XGH_HUL(`2',`Design patterns',`dnl
XGH_LIAL(`https://www.gameprogrammingpatterns.com/state.html')
')
XGH_HUL(`2',`Cross',`dnl
XGH_LIAL(`https://github.com/DarthGandalf/gentoo-overlay/commit/bf3d4ebc635689374e171c3e43d65c2917869339')
XGH_LIAL(`https://gcc.gnu.org/wiki/CompileFarm#Hardware_Wishlist')
XGH_LIAL(`https://osuosl.org/services/powerdev/request_hosting/')
XGH_LI(`zig cc for cross compilation')
XGH_LIAL(`https://github.com/chewi/cross-boss')
XGH_LIAL(`vite, webpack')
')
XGH_HUL(`2',`The quest for hot-reloading',`dnl
XGH_LIAL(`https://www.slembcke.net/blog/HotLoadC/')
')
XGH_HUL(`2',`Debugging',`dnl
XGH_LIAL(`https://xania.org/202506/how-compiler-explorer-works')
XGH_LI(`strace/truss ')
XGH_LIAL(`https://sourceware.org/gdb/current/onlinedocs/gdb.html/Sample-Session.html')
')
XGH_HUL(`2',`Header optimization',`dnl
XGH_LIAL(`https://lpc.events/event/17/contributions/1620/attachments/1228/2520/Linux%20Kernel%20Header%20Optimization.pdf')
')
XGH_HUL(`2',`GUIs',`dnl
XGH_LIAL(`https://github.com/lc-soft/LCUI')
')
XGH_HUL(`',`Formal languages and theory of computation',`dnl
XGH_LIAL(`https://en.wikipedia.org/wiki/Dirichlet%27s_theorem_on_arithmetic_progressions')
XGH_LIAL(`https://en.wikipedia.org/wiki/Parikh@aq@s_theorem')
XGH_LIAL(`https://en.wikipedia.org/wiki/Pumping_lemma_for_regular_languages')
XGH_LIAL(`https://en.wikipedia.org/wiki/Pumping_lemma_for_context-free_languages')
')
XGH_HUL(`2',`Logging',`dnl
XGH_LIAL(`https://hardysimpson.github.io/zlog/')
XGH_LIAL(`https://telemetry.mozilla.org/')
')
XGH_HUL(`2',`Data structures and algorithms',`dnl
XGH_LI(`Bloom filters')
XGH_LIAL(`https://lemire.me/en/publication/arxiv1912/')
XGH_LIAL(`https://github.com/P-p-H-d/mlib')
XGH_LIAL(`https://15721.courses.cs.cmu.edu/spring2018/papers/08-oltpindexes1/pugh-skiplists-cacm1990.pdf')
')
XGH_HUL(`2',`Security',`dnl
XGH_LIAL(`https://github.com/advisories')
')
XGH_HUL(`2',`Most likely brainrot (to be checked)',`dnl
XGH_LIAL(`https://www.dataorienteddesign.com/dodbook.pdf')
XGH_LIAL(`https://exceptions4c.guillermo.dev/')
')
XGH_HUL(`2',`Operating systems internals',`dnl
XGH_LIAL(`https://stackoverflow.com/questions/9970858/what-special-powers-does-ashmem-have')
')
XGH_HUL(`2',`Documentation',`dnl
XGH_LIAL(`https://www.freebsd.org/cgi/man.cgi')
XGH_LI(`"doxygen can be at end of file rather than inline for each function etc."')
')
XGH_HUL(`2',`Law',`dnl
XGH_LIAL(`https://www.planalto.gov.br/ccivil_03/_ato2019-2022/2020/lei/l14063.htm')
XGH_LIAL(`https://www.planalto.gov.br/ccivil_03/mpv/antigas_2001/2200-2.htm')
XGH_LIAL(`https://pt.wikipedia.org/wiki/Sistema_de_horas_de_trabalho_996')
XGH_LIAL(`https://web.archive.org/web/20260730113844/http://www.cryptolaw.org/')
')
XGH_HUL(`2',`Data',`dnl
XGH_LIAL(`https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry')
')
XGH_HUL(`2',`Investigate',`dnl
XGH_LI(`Cf. logs vs. metrics')
XGH_LI(`deterministic replay in a game (RNG from seed), timestamps')
XGH_LI(`mIRC Scripting (mSL)')
XGH_LI(`Bank Python')
XGH_LI(`Cancel half-played animations in a combo system of a fighter game')
XGH_LI(`Carl Hewitt and Actor model')
XGH_LI(`Paul John Morisson and Flow-based')
XGH_LI(`links for C11, C23, C99, SUSv4 ("Issue 7" ca. 2008, updated in 2018) plus the just-released SUSv5 ("Issue 8", ca. 2024) and/or SUSv3 ("Issue 6", ca. 2001)')
')
XGH_HUL(`2',`Snippets (maybe unknown)',`dnl
XGH_LI(`XGH_CI(`gcc -x c /dev/null -dM -E')')
XGH_LI(`XGH_CI(`gcc -x c /usr/include/limits.h -dM -E')')
XGH_LI(`XGH_CI(``#define' S(x) <x.h> \n `#include' S(stdio)')')
XGH_LI(`XGH_CI(`gdb -tui -ex "tui layout split"')')
XGH_LI(`cc -O1 -g -c a.c  objdump --visualize-jumps -S a.o `#'')
')
