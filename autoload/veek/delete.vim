let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
let s:veeks = veek#instance#veeks#export()

function! veek#delete#go(name, _upward) "{{{
  let name = veek#util#avsolutize_list_contents(a:name)
  let name = get(name, 0) == 0 ? [] : name    "a:nameに0を与えられた時は全削除
  call call(s:veeks.delete, [0, a:_upward] + name, s:veeks)
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
