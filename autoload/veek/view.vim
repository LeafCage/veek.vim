let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
let s:veeks = veek#instance#veeks#export()

"=============================================================================
function! veek#view#all(_sort) "{{{
  let veeks = s:veeks.collect(0, a:_sort, 0)
  call veek#util#veeks_echo(veeks)
endfunction
"}}}

"-----------------------------------------------------------------------------
function! veek#view#go(name, _upward, _sort) "{{{
  let [name, _should_be_log] = s:__treat_veekname(a:name, a:_sort)
  if _should_be_log
    let veeks = call(s:veeks.log, name, s:veeks)
  else
    let veeks = call(s:veeks.collect, [0, a:_sort, a:_upward] + name, s:veeks)
  endif
  call veek#util#veeks_echo(veeks)
endfunction
"}}}
function! s:__treat_veekname(name, _log) "{{{
  "[3] か [3, 5](collect) か [3, -5](log) か ['name'](name) か [-2](未定義) か [-2, 5](未定義)
  let _should_be_log = 0
  let namelen = len(a:name)
  if namelen == 1 && a:_log
    let _should_be_log = 1
  elseif namelen > 1 && get(a:name, 1, 0) < 0
    let _should_be_log = 1
  endif
  return [veek#util#avsolutize_list_contents(a:name), _should_be_log]
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
