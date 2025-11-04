divert(-1)

include(percent.m4)

define(`TR2',`ifelse(len($1),0,,` TRI(substr($1,0,1))'`TR(substr($1,1))')')
define(`TR',`substr(TR2($*),1)')

divert(0)ifelse(gen,`ragel',`dnl
%%{
    machine http;

    _index = TR(index);
    pages2 = TR(movies) %set_movie
           | TR(c)      %set_c
           | TR(exp) "/" TR(crud) "/" TR(hash) %set_hash
           ;
    pages = pages2 (TR(.html) | ("/" "./"* _index?))?;
    path = "/" "./"* (pages | _index)?;
}%%')
