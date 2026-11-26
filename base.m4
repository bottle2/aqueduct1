define(`_',`ifelse(`$#',`0',`dnl#')')dnl
define(`XGH_NL',`
')dnl
define(`XGH_CAT',`$1$2')dnl
define(`XGH_CONT1',`XGH_$1(`$2',shift(shift(shift($@))))')dnl
define(`XGH_CONT2',`XGH_$1(`$2',shift(shift(shift(shift($@)))))')dnl
define(`XGH_AUTHOR_')dnl
define(`XGH_AUTHOR2',`XGH_CAT(`XGH_AUTHOR_',substr(`$1',`0',`1'))(substr(`$1',`1'),shift($@))')dnl
define(`XGH_AUTHOR',`ifelse(
  `$#',`1',`XGH_AUTHOR2(`R',$@)',
  `$#',`2',`XGH_AUTHOR2(`N',$@)',
           `XGH_AUTHOR2($@)')')dnl
define(`XGH_H_RESET',`define(`XGH_H___TOP',`1')define(`XGH_H___CNT',)')dnl
define(`XGH_H_UPD',
  `ifelse(
    XGH_H___TOP,`$1',
      `define(`XGH_H___CURR2',XGH_H___CURR)_(
      )popdef(`XGH_H___CURR')_(
      )pushdef(`XGH_H___CURR',incr(XGH_H___CURR2))_(
      )popdef(`XGH_H___CNT')_(
      )pushdef(`XGH_H___CNT',XGH_H___CNT`'XGH_H___CURR`.')_(
    )',
    eval(`$1 <' XGH_H___TOP),`1',
      `define(`XGH_H___TOP',decr(XGH_H___TOP))_(
      )popdef(`XGH_H___CURR')_(
      )popdef(`XGH_H___CNT')_(
      )XGH_H_UPD(`$1')_(
    )',
    eval(`$1 ==' XGH_H___TOP `+ 1'),`1',
      `define(`XGH_H___TOP',incr(XGH_H___TOP))_(
      )pushdef(`XGH_H___CURR',`1')_(
      )pushdef(`XGH_H___CNT',XGH_H___CNT`'`1.')_(
    )',
      `errprint(`must increase heading level one at a time')_(
      )m4exit(`1')_(
  )')'dnl
)dnl
