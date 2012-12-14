let s:save_cpo = &cpo| set cpo&vim
"=============================================================================

function! veek#veek(bang, qargs, ...) "{{{
  let _sort = a:bang == '!' ? 1 : 0
  if !a:0
    call veek#view#all(_sort)
    return
  elseif empty(a:1)
    if a:0 > 1
      call s:__delete__fork(a:000[1:])
    endif
    return
  endif

  let ntype = s:__ret_args_numtype(a:000)
  let [nums6name, s:arg, msg, _is_arg, _is_msg, _upward] = s:__split_num_to_args__{ntype}(a:000)
  if !_is_arg
    call veek#view#go(nums6name, _upward, _sort)
    unlet s:arg
    return
  endif

  let expr = s:__get_expr__{ntype}(a:qargs, _is_msg)
  call veek#set#go(nums6name, expr, s:arg, msg)
  unlet s:arg
endfunction
"}}}
function! s:__delete__fork(v000) "{{{
  let ntype = s:__ret_args_numtype(a:v000)
  let [nums6name, arg, msg, _is_arg, _is_msg, _upward] = s:__split_num_to_args__{ntype}(a:v000)
  call veek#delete#go(nums6name, _upward)
endfunction
"}}}

"-----------------------------------------------------------------------------
function! s:__ret_args_numtype(v000) "{{{
  let t = type(a:v000[0])
  if t == type([])
    return 'list'
  elseif t == type('')
    return 'name'
  elseif t == type(1)
    if a:v000[0] < 0
      return 'minus'
    endif
    return 'num'
  endif
  return 'unknown'
endfunction
"}}}

"--------------------------------------
function! s:__split_num_to_args__list(v000) "{{{
  let _upward = 0
  if len(a:v000[0]) == 1
    let _upward = 1
  endif
  return [a:v000[0]] + s:___split_msg_to_args(a:v000[1:]) + [_upward]
endfunction
"}}}
function! s:__split_num_to_args__num(v000) "{{{
  return [[a:v000[0]]] + s:___split_msg_to_args(a:v000[1:]) + [0]
endfunction
"}}}
function! s:__split_num_to_args__minus(v000) "{{{
  let n1 = a:v000[0] * -1
  if type(get(a:v000, 1, '')) == type(1)
    let n2 = a:v000[1]
    return [[n1, n2]] + s:___split_msg_to_args(a:v000[2:]) + [0]
  endif
  return [[n1]] + s:___split_msg_to_args(a:v000[1:]) + [1]
endfunction
"}}}
function! s:__split_num_to_args__name(v000) "{{{
  return [a:v000[0]] + s:___split_msg_to_args(a:v000[1:]) + [0]
endfunction
"}}}
function! s:__split_num_to_args__unknown(v000) "{{{
  return [[], [], '', 0]
endfunction
"}}}
function! s:___split_msg_to_args(args) "{{{
  let e = len(a:args)
  if e == 0
    let [_is_arg, _is_msg] = [0, 0]
  elseif e == 1
    let [_is_arg, _is_msg] = [1, 0]
  elseif e > 1 && type(a:args[-1]) == type('')
    let [_is_arg, _is_msg] = [1, 1]
  endif
  return [get(a:args, 0, []), get(a:args, 1, ''), _is_arg, _is_msg]
endfunction
"}}}

"--------------------------------------
function! s:__get_expr__list(qargs, _is_msg) "{{{
  let q = substitute(a:qargs, '^\V[\(,\|\s\|-\?\d\+\)\*],\?\s\*', '', '')
  if a:_is_msg
    let q = s:___rmv_msg(q)
  endif
  return q
endfunction
"}}}
function! s:__get_expr__num(qargs, _is_msg) "{{{
  let q = substitute(a:qargs, '^\d\+,\s*', '', '')
  if a:_is_msg
    let q = s:___rmv_msg(q)
  endif
  return q
endfunction
"}}}
function! s:__get_expr__minus(qargs, _is_msg) "{{{
  let q = substitute(a:qargs, '^-\d\+,\s*\(-\?\d\+,\s*\)\?', '', '')
  if a:_is_msg
    let q = s:___rmv_msg(q)
  endif
  return q
endfunction
"}}}
function! s:__get_expr__unknown(qargs, _is_msg) "{{{
  return a:qargs
endfunction
"}}}
function! s:___rmv_msg(q) "{{{
  return substitute(a:q, '^.*\zs,\s*\(".\{-}"\|''.\{-}''\)$', '', '')
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
