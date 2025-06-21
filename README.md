# The Web server and website written in C

## Future directions

### HTTPS support

First of all I need a domain name. I guess.

The following is a brain dump. **It is not written intended to be
cohesive and sensible.**

So I will use Let's Encrypt thing, which has this thing ACMEv2.
ACMEv2 is either a library or a command-line utility (or a Web server
plugin/module or a deamon, both of which I don't care).

The problem of most ACMEv2 implementations' documentation is that they
try to be "easy" while also paradoxically assuming the user knows all
the ins and outs of how ACMEv2 works. WTF? So yeah, I'm quite lost. I
don't really know what any ACMEv2 client is doing, if they are doing
more than necessary, FUCK. Fuck easy things. Fuck me.

I will probably have to read the entire ACMEv2 specification and all
RFCs dealing with HTTPS and the kitchen sink. AGAIN. Because fuck
abstraction, right? Also fuck me, right? Fuck C programmers. Fuck.

- [ACME Client Implementations](https://letsencrypt.org/docs/client-options/).
  Also fuck this webpage in particular. It may be up-to-date, but it
  provides zero comparisons to help me choose. FUCK.

I will absolutely not create my own ACMEv2 implementation. Because I
absolutely do not want to keep up with changes and security things. So
I'm forced to use some existing implementation.

**This is current hypothetical strategy**: I think that every client
tries to do *everything*, so while my little Web server has its own
"stack" to do IO, any client I use, they will have their own stack.
Fuck whatever I'm using, right? Fuck being generic.

**So this is really my strategy**: 1) put a timer to run once every
three months, 2) halt the entire fucking Web server, 3) run an ACMEv2
client and wait, 4) restart the entire fucking Web server. The
advantage is that the client can run as if nothing else is running,
with its entire stack, do whatever it wants. The entire Web server
will be rewritten as one infinite loop: a) run ACMEv2 client, b) run
the actual server, c) rinse and repeat, every three months. Fuck my
life.

Now let's see some approaches, with varying levels of convenience
versus security. And I didn't think about licensing stuff at all.
BRUH.

#### Option 1: embed some embedabble language and interpret a script

The following languages are probably easily embeddable:

- [Python](https://docs.python.org/3/extending/embedding.html)
- [Perl](https://perldoc.perl.org/perlembed)

So I have two options:

1. Literally interpret a command-line utility as if I was running it
   in a shell, and wait blocking
2. Wrap an entire library in some kind of `int do_everything(void)`
   function and call this function and wait, blocking

This is probably the easiest, most secure and reliable of all.

The interpreter version will be "stuck" until entire Web server is
recompiled. But at least the client can be updated without turning off
the server. But maybe there is some operating system specific way to
update dependencies. I don't know. Some operating system service. That
would be wicked epic. After all, the library is only used once every
three months.

#### Option 2: call `system()` or some shit

This function is standardized, exists and works on both Windows and
Linux. But using it is said to be an enormous source of vulnerability.
Who knows? I don't know. Whatever. Call the client and wait blocking.

The interpretation of return value differs on Linux and Windows. But
macros can always solve those differences. Actually, I will never run
an ACMEv2 client on Windows, because I'm not going to certify my test
machine?

Something something environment, something something securing. Fuck.

Independent from updates. Nice.

#### Option 3: call [`uv_spawn`](https://docs.libuv.org/en/v1.x/process.html#c.uv_spawn)

Probably very easy. Go Horse. I like this option very much. When the
callback is called, restart entire server. Doesn't worry with
dependencies nor linking. If I update the client, probably the server
doesn't need to be recompiled, just execute newest executable,
operating system solves all. I like this option.

#### Option 4: create a C interface for some existing library or client

There is no library for C. But there are libraries for Rust, C++, D.
And many clients. I could wrap them somehow, even submit my work as
pull request. Seems like A LOT of work for something I'm not sure will
even work. Thinking about linking dependencies and whatever makes me
doze. Thinking about uuuuugh learning makes me doze. Fuck. I hate
this option.

### Proper troff parsing

Look. There are many troff implementations. It is an enormous waste of
time creating my parser. I think the best strategy is to pick some
existing troff implementation and reuse its code. Because troff is
only powerful writing macros etc. So doing a purely semantic interface
is not worthwhile. Things will evolve like this. Conditional things
etc. It's only natural.

- neatroff (MIT?)
- mandoc (MIT)
- Heirloom troff
- GNU troff (GPL)

Leverage the parser, AST, and also interpreter. There is no reason to
be special, invent new things. So bro can reuse his troff skills
happily. We can patch the stuff to introduce new primitive-ish things
suitable for Webdevus.

It seems all of Heirloom, neatroff and mandoc implement groff
extensions. GOOD.

And we want our documents, also provide a PDF version. Really neat <3
And an epic simplified Gopher interface!!!!!!

---

Ignore this trash written below.

- Link movies.o, maybe add a rule .ctt.c whatever
- Test (optional)

## Document markup

A [troff](https://troff.org/)-like syntax is used to describe a Web
page. Commands are drawn from the
[mom](http://www.schaffter.ca/mom/momdoc/toc.html) macro set.
Currently only
[http:191.252.220.165/movies.html](http:191.252.220.165/movies.html)
is being generated, which is defined in [movies.txt](movies.txt).
A state machine specified in [parse2.rl](parse2.rl) reads the
markup and builds a linked list of elements. This specification
employs [Ragel](https://www.colm.net/open-source/ragel/). Moreover,
the state machine allows mixing LF and CRLF for line endings.

This linked list is defined in [movie.h](movie.h), and is consumed by
an ad-hoc state machine implemented in [parse.c](parse.c), which
finally generates HTML. There is currently no HTML escaping or
sanitization, so the user must write stuff like `&amp;` manually.

The output device is generic, and its interface is found in
[parse.h](parse.h). Thus, the simple debug batch implementation
[batch.c](batch.c) writes directly to `stdout`, but the actual Web
server code performs two passes: one device counts bytes, and the
second writes to a buffer, because HTML generation is deterministic
and reproducible. [main.c](main.c) handles all of this across several
callbacks.

### Commands and elements

Commands start obligatorily at the beginning of a line.
Free text is currently only understood after `.PP` command.
All mentions to digits refers to decimal Arabic numerals.

All commands span a single line, and there is no
mechanism such as escaping the end of line sequence with `\` to
continue a command or element in the next line.

This syntax is very far away from being compatible with troff.
Actually, it is already incompatible.

- `.\"`

  This a "comment command", anything that follows is ignored. They can
  appear anywhere.

- <code>.TITLE *quoted\_text*</code>

  <code>*quoted\_text*</code> is suffixed with `- aqueduct1` and placed
  inside `<title>..</title>`. It must start and end with a `"`
  character. Embedded `"`s must not be escaped.

- <code>.HEADING *level* *quoted\_text*</code>

  <code>*level*</code> is a number from 1 to 6, which is translated to
  <code>\<h*level*>..\</h*level*></code>. As in `.TITLE`,
  <code>*quoted\_text*</code> allows embedded `"`s and these must not
  be escaped, but it is copied inside the section heading tags as it
  is, without any suffix.

- `.PP`

  Starts a paragraph. The lines that follow until any command appears
  are added between `<p>..</p>`. No argument is expected for this
  command.

- <code>.MOV *symbol* __[__*imdb_code* *year* *title*__]__</code>

  A sequence of `.MOV` commands creates an unordered list
  `<ul>..</ul>` of movies, where each item `<li>..</li>` is in the
  form <code>*text* (*year*)</code>, and <code>*text*</code> is a
  hyperlink `<a href=..</a>` pointing to the movie's entry in
  [IMDb](https://www.imdb.com/). Any other command after `.MOV` will
  end the list.

  To define a movie, the second form of the command, with all optional
  arguments present, must be used.

  * <code>*symbol*</code> is a sequence of character uppercase or number or
    underline, but the first one must not be a number.
  * <code>*imdb_code*</code> is `tt` followed by at least 7 digits.[^1]
  * <code>*year*</code> is exactly four digits.
  * <code>*title*</code> is the remainder of the line until its end,
    and must not be quoted anyhow.

  Once a movie defined, and only once, it is also output to HTML as
  described before. Further, a movie definition can be reused before
  or after the initial definition using the first form of the command,
  simply through its <code>*symbol*</code>.

[^1]: https://developer.imdb.com/documentation/key-concepts#imdb-ids
