divert(-1)

include(percent.m4)

define(`TR',`ifelse(len($1),0,,` TRI(substr($1,0,1))'`TR(substr($1,1))')')

divert(0)ifelse(gen,`ragel',`dnl
%%{
    machine http;

    _html =TR(.html);
    _index =TR(index);
    pages =TR(movies) (_html | ("/" "./"* _index?))?;
    path = "/" "./"* (pages %set_movie | _index)?;
}%%')
