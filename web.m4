define(`XGH_NL',`
')dnl
define(`XGH_H',`<h$1>$2</h$1>')dnl
define(`XGH_TIT',`define(`XGH_WEB_TITLE',`$1')XGH_H(`1',`$1')')dnl
define(`XGH_UL',`<ul>XGH_NL`'$1`'dnl
</ul>')dnl
define(`XGH_LI',`<li>XGH_NL`'$1`'XGH_NL</li>')dnl
define(`XGH_LIA',`XGH_LI(`<a href="$1">$2</a>')')dnl
define(`XGH_LIAL',`XGH_LI(`<a href="$1">$1</a>')')dnl
define(`XGH_LIAR',`XGH_LIA(`./$1.html',`$2')')dnl
define(`XGH_P',`<p>XGH_NL`'$1`'XGH_NL</p>')dnl
define(`XGH_DL',`<dl>XGH_NL`'$1</dl>')dnl
define(`XGH_DI',`<dt>$1</dt>XGH_NL<dd>XGH_NL`'$2`'XGH_NL</dd>')dnl
define(`XGH_AMP',`&amp;')dnl
define(`XGH_MOV',`<a href="https://www.wikidata.org/wiki/XGH_MOV___$1___WIKIDATA">XGH_MOV___$1___TITLE (XGH_MOV___$1___YEAR)</a>')dnl
define(`XGH_MOVI',`<li>XGH_MOV($@)</li>')dnl
define(`XGH_MOVIX',`<li>$1`'XGH_MOV(shift(shift($@)))`'$2</li>')dnl
define(`XGH_HUL',`XGH_H(`$1',`$2')`'XGH_NL`'XGH_UL(`$3')')dnl
define(`XGH_A',`<a href="$1">$2</a>')dnl
define(`XGH_A2',`XGH_A(`$2',`$1')')dnl
define(`XGH_AI',`<li>XGH_A($@)</li>')dnl
define(`XGH_HR',`<hr />')dnl
define(`XGH_WEB',`$*')dnl
define(`XGH_GAME',`<li>$1`'$2`'XGH_GAME___PART3`'define(`XGH_GAME___PART3')</li>')dnl
define(`XGH_GAME_LOC',` [$1]')dnl
define(`XGH_GAME___PART3')dnl
define(`XGH___ALPHABET',`abcdefghijklmnopqrstuvwxyz')dnl
define(`XGH___FN_I',`0')dnl
define(`XGH_FN_INC',`dnl
`'define(`XGH___FN_L',substr(XGH___ALPHABET,XGH___FN_I,`1'))dnl
`'define(`XGH___FN_I',incr(XGH___FN_I))dnl
')dnl
define(`XGH_GAME_NOTE',`define(`XGH_GAME___PART3',` ($1)')dnl')dnl
define(`XGH_GAME_NOTEF',`dnl
`'XGH_FN_INC`'dnl
`'divert(7)<p><sup><a id="fn_`'XGH___FN_L" href="`#'fn_`'XGH___FN_L`'_rev">XGH___FN_L</a></sup> $2</p>
divert(1)dnl
`'define(`XGH_GAME___PART3',` (`$1' <sup><a id="fn_`'XGH___FN_L`'_rev" href="`#'fn_`'XGH___FN_L">XGH___FN_L</a></sup>)')dnl')dnl
define(`XGH_GAME_LOC1',` [<a href="$2">XGH_GAME___LOC_$1</a>]')dnl
define(`XGH_GAME_LOC1A',` [<a href="$2">XGH_GAME___LOC_$1</a> (archive)]')dnl
define(`XGH_GAME_LOC1M',` [<a href="$2">XGH_GAME___LOC_$1</a> (mention)]')dnl
define(`XGH_GAME_ATTR___Z',`')dnl
define(`XGH_GAME_ATTR___A',`<sup> (archive)</sup>')dnl
define(`XGH_GAME_ATTR___M',`<sup> (mention)</sup>')dnl
define(`XGH_GAME_LOCC',` [<a href="$4">XGH_GAME___LOC_$1<sup>$3</sup></a>XGH_GAME_ATTR___$2`'XGH_GAME_LOCC2(shift(shift(shift(shift($@)))))]')dnl
define(`XGH_GAME_ATTR___2Z',`')dnl
define(`XGH_GAME_ATTR___2A',` (archive)')dnl
define(`XGH_GAME_ATTR___2M',` (mention)')dnl
define(`XGH_GAME_LOCC2',`ifelse(1,$#,,` <sup><a href="$3">$2</a>XGH_GAME_ATTR___2$1</sup>XGH_GAME_LOCC2(shift(shift(shift($@))))')')dnl
define(`XGH_GAME_LOCi',`define(`XGH_GAME_LOC___i',`1') [<a href="$3">XGH_GAME___LOC_$1<sup>1</sup></a>XGH_GAME_ATTR___$2`'XGH_GAME_LOCi2(shift(shift(shift($@))))]')dnl
define(`XGH_GAME_LOCi2',`ifelse(1,$#,,`define(`XGH_GAME_LOC___i',incr(XGH_GAME_LOC___i)) <sup><a href="$2">XGH_GAME_LOC___i</a>XGH_GAME_ATTR___2$1</sup>XGH_GAME_LOCi2(shift(shift($@)))')')dnl
define(`XGH_IMG',`<img width="300px" src="./$1.$2" alt="$3">')dnl
define(`XGH_IT',`<i>$1</i>')dnl
m4wrap(`divert(0)dnl
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta property="og:image" content="./meme2.jpg" />
<meta property="og:site_name" content="Home of the greatest m4 enthusiast" />
<!--<link rel="icon" type="image/svg+xml" href="./logo.svg">-->
<title>XGH_WEB_TITLE - aqueduct1</title>
</head>
<body>')dnl
m4wrap(`divert(9)</body>XGH_NL</html>')dnl
divert(1)dnl
