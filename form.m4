divert(-1)dnl

define(`TITULO',`Formulário de trajetos')

define(`NL',`
')

# TODO duplication...
define(`X',`define(`VALOR_$1_FUNC',`$2')define(`VALOR_$1_ATTR',`$3')define(`VALOR_$1_STYL',`$4')')
X(`FREE',          `directt',          `',`')
X(`PLACA_DE_CARRO',`validate_car_plate',`',`text-align: center;')
X(`MONEY',         `push_money',        `inputmode=$1`'decimal$1 ',`text-align: right;')
X(`DISTANCE',      `le_dist',           `inputmode=$1`'decimal$1 ',`text-align: right;')
undefine(`X')

# TODO Gerador de lista foda

define(`COLUNAS',`define(`X',`define(`CNT',incr(CNT))$1`'dnl')define(`CNT',-1)dnl
X(`Tipo de carga',    `FREE')
X(`Valor da carga',   `MONEY')
X(`Kilometragem',     `DISTANCE')
X(`Placa do veículo', `PLACA_DE_CARRO')
X(`Nome do motorista',`FREE')
X(`Ponto de entrega', `FREE')
X(`Ponto de saída',   `FREE')
undefine(`X')undefine(`CNT')dnl
')

define(`LINHA',`dnl
`'<td></td>COLUNAS($1`<td><input VALOR_$'`2_ATTR($2)oninput=$2dirty(this)$2 /></td>')<td><button onclick=$2self_destruct(this)$2style=$2filter: grayscale(100%)$2>&changecom()#x1F5D1;&#changecom(#)xFE0F;</button></td>`'dnl
')

define(`ERROS',`define(`X',`$1`'dnl')dnl
X(`requ',    `VOID',        `campo obrigatório não preenchido')
X(`spa_digi',`VOID',        `campo não pode ter espaços em branco entre dígitos')
X(`virg',    `PRM(int,cou)',`há mais de uma vírgula no número, só pode uma')
X(`dig15',   `PRM(int,cou)',`só pode até 15 dígitos no número, contando os decimais')
X(`dec2',    `PRM(int,cou)',`só pode duas casas decimais para dinheiro')
X(`unrec',   `VOID',        `caracteres não reconhecidos encontrados, somente dígitos e vírgula são permitidos')
X(`neg',     `VOID',        `valor não pode ser negativo')
undefine(`X')dnl
')

define(`ERROS_HTML',`ERROS(`dnl
      <div id="erro_$'`1" hidden>
        <h3>Erro: $'`3</h3>
        <p>Contagem de campos com esse erro: <span id="erro_$'`1_cnt"></span></p>
        <ul id="erro_$'`1_list">
        </ul>
      </div>
')')

divert(0)dnl
ifelse(gen,`html',`dnl
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>TITULO</title>
    <script>
    var all_cells = [];
    function self_destruct(who) {
      who.parentNode.parentNode.remove();
    }
    function escape2(strin) {
      // https://stackoverflow.com/a/6234804
      return strin
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll("\x34", "&quot;")
        .replaceAll("\x39", "&#039;");
    }
    function complain_bad(ver,file,nl,msg) {
      const full_msg = escape2(ver) +":" +escape2(file) +":" +escape2(nl+"") +":" +escape2(msg);
      document.getElementByid("badd_msg").innerText = full_msg;
      document.getElementById("badd").removeAttribute("hidden");
    }
    function roempty(ro) {
      return !Array.prototype.slice.call(ro.children,1,-1).some((chid) => chid.firstElementChild.value.trim().length);
    }
    function cleanse() {
      for (const row in Array.prototype.slice.call(document.getElementById("table").children,0,-1))
        if (row)
          row.remove();
    }
    function dirty(ev) {
      const is_last = ev.parentNode.parentNode == ev.parentNode.parentNode.parentNode.lastElementChild;
      if (is_empty && !is_last)
      {
        const cell = ev.parentNode;
        const row = cell.parentNode;
        const i = Array.prototype.indexOf.call(row.children, cell);
        row.nextElementSibling.children.item(i).firstElementChild.focus();
        row.remove();
      }
      else if (!is_empty && is_last)
        ev.parentNode.parentNode.parentNode.insertRow(-1).innerHTML = "<tr>LINHA(`',`\"')</tr>";
    }
    function go_bacc() {
      all_cells.length = 0; // NO memory leak at all. Guaranteed.
      document.getElementById("badd").setAttribute("hidden","");
      document.getElementById("resumo").setAttribute("hidden","");
      ERROS(`document.getElementById("erro_$'`1").setAttribute("hidden","");NL      ')`'dnl
_le_export();
    }
    function gay_goto(i) { all_cells[i].focus(); }
    </script>
    <style>
    tfoot tr { text-align: center; }
    tbody tr { text-align: right; }
    li button { user-select: text; }
`'`'COLUNAS(`ifelse(len(VALOR_$2_STYL),0,,`    tbody tr :nth-child(eval(CNT+2)) input { VALOR_$2_STYL }NL')')dnl
    <!-- TODO Formatar com a fonte e cores oficiais de placa de carro seria muito based -->
    </style>
  </head>
  <body>
    <h1>TITULO</h1>
    <button onclick="cleanse()">Remover linhas vazias (não precisa antes de exportar)</button>
    <table>
      <thead><tr>
      	<td></td>COLUNAS(`NL        <th>$1</th>')
      </tr></thead>
      <tbody id="table">
      <tr>LINHA(`NL        ',`"')
      </tr>
      </tbody>
      <tfoot><tr><td></td>COLUNAS(`<td>substr(`ABCDEFGHIJKLMNOPQRSTUVWXYZ',CNT,1)</td>')</tr></tfoot>
    </table>
    <button onclick="go_bacc()" type="button">
      Validar formulário e exportar Excel
    </button>
    <p>
      Se há erros, nenhum arquivo Excel é gerado. A lista de erros
      <strong>não</strong> é atualizada enquanto valores são
      modificados.
    </p>
    <div hidden id="badd">
      <p>Erro interno (não é culpa sua). Repasse toda a seguinte mensagem para um responsável:</p>
      <code id="badd_msg"></code>
      <button onclick="clipboard.writeText(document.getElementById(&quot;badd_msg&quot;).innerText)">Copiar</button>
    </div>
    <div hidden id="resumo">
      <h2>Erros a serem corrigidos: <span id="total"></span></h2>
ERROS_HTML`'dnl
    </div>
    <p>
    Copyright (C) 2026 Bento Borges Schirmer
    </p>
  </body>
  {{{ SCRIPT }}}
</html>
',gen,`h',`dnl
#ifndef FORM_XS
changecom()dnl
#define FORM_XS`'COLUNAS(` \NL`X'("$1",VALOR_$2_FUNC)')

#define FORM_ERROR_XS`'ERROS(` \NL`X'($1,$2)')
changecom(#)dnl

#endif
')`'dnl
