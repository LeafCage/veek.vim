let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
let s:veeklist = veek#instance#veeklist#export()
let s:veeks = veek#instance#veeks#export()

function! veek#instance#namedveek#new(...) "{{{
  "if a:1 !~ '^\(\a\|_\)\(\a\|\d\|_\)*'
  let named = {}
  let named.name = a:0 ? a:1 : s:veeklist.ret_young_undefined_num()
  let named.expr = '== Veek() =='
  function! named.set(val, ...) "{{{
    call veek#set#go(self.name, self.expr, a:val, (a:0 ? a:1 : ''))
  endfunction
  "}}}
  function! named.view(...) "{{{
    let log = call(s:veeks.log, [self.name] + a:000 )
    call veek#util#veeks_echo(log)
  endfunction
  "}}}
  function! named.delete() "{{{
    call s:veeks.delete(0, 0, self.name)
  endfunction
  "}}}
  return named
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
