# The Web server and website written in C

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
