let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
let s:veeks = veek#instance#veeks#export()

function! veek#set#go(nums_or_name, expr, val, msg) "{{{
  let g = {}
  let g.val = deepcopy(a:val)
  let g.expr = a:expr
  let g.msg = a:msg
  let g.stacktrace = substitute(expand('<sfile>'), '..veek#.*$', '', '')
  let g.time = localtime()
  let nums_or_name = veek#util#avsolutize_list_contents(a:nums_or_name)
  call s:veeks.set(nums_or_name, g)
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
