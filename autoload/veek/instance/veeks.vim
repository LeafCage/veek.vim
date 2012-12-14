let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
let s:veeks = exists('s:veeks') ? s:veeks : {}
let s:veeks.pool = exists('s:veeks.pool') ? s:veeks.pool : {}
let s:veeklist = veek#instance#veeklist#export()
"-----------------------------------------------------------------------------
function! s:veeks.set(name, json) "{{{
  if type(a:name) != type([])
    let self.pool[a:name] = exists('self.pool[a:name]') ? self.pool[a:name] : []
    call self.__insert_poolItem__ala_name(a:name, a:json)
    return
  endif
  let range = len(a:name)==1 ? a:name :
    \ a:name[0] > a:name[1] ? range(a:name[1], a:name[0]) : range(a:name[0], a:name[1])
  for n in range
    let self.pool[n] = exists('self.pool[n]') ? self.pool[n] : []
    call self.__insert_poolItem__ala_name(n, deepcopy(a:json))
  endfor
endfunction
"}}}
function! s:veeks.__insert_poolItem__ala_name(name, json) "{{{
  let a:json.name = a:name
  call insert(self.pool[a:name], a:json)
  call s:veeklist.follow(a:name)
endfunction
"}}}
"--------------------------------------
function! s:veeks.collect(ago, _sort, _upward, ...) "{{{
  let [from_num, to_num] = [get(a:000, 0), get(a:000, 1)]
  if !a:_upward && a:0 == 1
    return self.__get_poolItemCopy__ala_ago(from_num, a:ago)
  endif

  let veeklist = copy(s:veeklist.get_list())
  call s:__collect_filter(veeklist, a:_sort, a:0, from_num, to_num)

  let g = []
  for n in veeklist
    let v = self.__get_poolItemCopy__ala_ago(n, a:ago)
    if !empty(v)
      call add(g, v)
    endif
  endfor
  return g
endfunction
"}}}
function! s:__collect_filter(veeklist, _sort, a0, from_num, to_num) "{{{
  if a:_sort
    call sort(a:veeklist, 's:_sort_large_small')
  endif
  if a:a0 == 1
    call filter(a:veeklist, 'v:val >= a:from_num')
  elseif a:a0 == 2
    call filter(a:veeklist, 'v:val >= a:from_num && v:val <= a:to_num')
  endif
endfunction
"}}}
"--------------------------------------
function! s:veeks.log(name, ...) "{{{
  let [since, until] = [get(a:000, 0), get(a:000, 1)]
  let log = s:veeks.__get_poolItemCopy__ala_ago(a:name)
  if a:0 == 0
    call reverse(log)
  elseif a:0 == 1
    let log = reverse(log[0:since])
  elseif a:0 == 2
    if since <= until
      let log = log[since:until]
    else
      let log = reverse(log[until:since])
    endif
  endif
  return log
endfunction
"}}}
"--------------------------------------
function! s:veeks.delete(_keep, _upward, ...) "{{{
  let [from_num, to_num] = [get(a:000, 0), get(a:000, 1)]
  if !a:_upward && a:0 == 1
    call s:veeks.__delete_poolItem(a:_keep, from_num)
    return
  endif

  let veeklist = sort(copy(s:veeklist.get_list()), 's:_sort_large_small')
  call s:__delete_filter(veeklist, a:0, from_num, to_num)
  for n in veeklist
    call s:veeks.__delete_poolItem(a:_keep, n)
  endfor
endfunction
"}}}
function! s:__delete_filter(veeklist, a0, from_num, to_num) "{{{
  if a:a0 == 1
    call filter(a:veeklist, 'v:val >= a:from_num')
  elseif a:a0 == 2
    call filter(a:veeklist, 'v:val >= a:from_num && v:val <= a:to_num')
  endif
endfunction
"}}}
function! s:veeks.__delete_poolItem(_keep, name) "{{{
  if !has_key(self.pool, a:name)
    return
  endif
  if a:_keep
    let self.pool[a:name] = []
  else
    unlet self.pool[a:name]
    call s:veeklist.remove(a:name)
  endif
  echo ' deleted '. a:name. ' veek.'
endfunction
"}}}
"-----------------------------------------------------------------------------

function! s:veeks.__get_poolItemCopy__ala_ago(name, ...) "{{{
  if a:0
    if !has_key(self.pool, a:name)
      return {}
    endif
    let ago = a:1
    let v = deepcopy(get(self.pool[a:name], ago, {}))
    if !empty(v)
      let v.ago = ago
    endif
    return v
  else
    if !has_key(self.pool, a:name)
      return []
    endif
    let veeklog = deepcopy(self.pool[a:name])
    for v in veeklog
      let v.ago = index(veeklog, v)
    endfor
    return veeklog
  endif
endfunction
"}}}

function! s:_sort_large_small(a, b) "{{{
  return a:a == a:b ? 0 : a:a > a:b ? 1 : -1
endfunction
"}}}
"=============================================================================
function! veek#instance#veeks#export() "{{{
  return s:veeks
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
