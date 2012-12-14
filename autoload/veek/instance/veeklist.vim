let s:save_cpo = &cpo| set cpo&vim
"=============================================================================

let s:veeklist = exists('s:veeklist') ? s:veeklist : {}
let s:veeklist.val = []
"--------------------------------------
function! s:veeklist.follow(name) "{{{
  if index(self.val, a:name) == -1
    call add(self.val, a:name)
  endif
endfunction
"}}}

function! s:veeklist.remove(name) "{{{
  let x = index(self.val, a:name)
  if x != -1
    call remove(self.val, x)
  endif
endfunction
"}}}
"--------------------------------------
function! s:veeklist.get_list() "{{{
  return deepcopy(self.val)
endfunction
"}}}
"--------------------------------------
function! s:veeklist.ret_young_undefined_num() "{{{
  let i = 0
  while 1
    let i += 1
    if index(self.val, i) == -1
      break
    endif
  endwhile
  return i
endfunction
"}}}
function! s:veeklist._modify_gap(_modify) "{{{
  "s:veeklist.valと実際のs:veeks.poolに何らかの原因で齟齬があるときそれを解消する
  let veeks = veek#instance#veeks#export()
  let errlog = []
  for v in keys(veeks.pool)
    if index(self.val, v) == -1
      if a:_modify
        call self.follow(v)
      endif
      call add(errlog, v)
    endif
  endfor
  let errlog2 = []
  for i in self.val
    if !has_key(veeks.pool, i)
      if a:_modify
        call self.remove(i)
      endif
      call add(errlog2, i)
    endif
  endfor
  if !empty(errlog)
    echomsg join(errlog). ' のVeekは取りこぼしていました'
  endif
  if !empty(errlog2)
    echomsg join(errlog2). ' のVeekは登録されていませんでした'
  endif
endfunction
"}}}

"=============================================================================
function! veek#instance#veeklist#export() "{{{
  return s:veeklist
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
