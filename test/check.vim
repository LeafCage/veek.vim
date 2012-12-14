
let s:veeklist = veek#instance#veeklist#export()
command! -nargs=* -bang  CheckVeeks    call <SID>check_veeks_pool()
function! s:check_veeks_pool() "{{{
  let g:check_veeks = veek#instance#veeks#export()
  UPP g:check_veeks.pool
  unlet g:check_veeks
endfunction
"}}}
command! -nargs=* -bang  CheckVeeklist    echo s:veeklist.get_list()

function! s:set_veeks() "{{{
  let test1 = 'out'
  let test = ['a', 'i', 3, ['foo', 'bar']]
  let test2 = {'kan': 'ron'}
  Veek [8], 1234
  Veek 3, test2, 'present'
  Veek -2, 5, test, 'kobutori'
  Veek [9, 11], 5678, 'hoihoi'
endfunction
"}}}
function! s:see_veeks() "{{{
  Veek
  debug echo ''
  Veek!
  debug echo ''
  Veek -2, 5
  debug echo ''
  Veek! [2, 5]
  debug echo ''
  Veek -5
  debug echo ''
endfunction
"}}}

function! s:log_test() "{{{
  let a = {'king': 4}
  let b = ['hoop']
  let c = 'konp'
  let D = function('s:see_veeks')
  Veek 3,a
  Veek 3,b,'on_logtest'
  Veek 3,c
  Veek 3,D, 'goal'
  unlet D

  Veek -3, -3
  debug echo ''

  Veek -3, -6
  debug echo ''

  Veek! 3
  debug echo ''
endfunction
"}}}
function! s:del_test() "{{{
  Veek 0, 11
  Veek 0, -4, 8
  Veek 0, -5
endfunction
"}}}

command! -nargs=* -bang  CheckSeeVeeks    call <SID>see_veeks()
call s:set_veeks()
call s:see_veeks()
call s:log_test()

command! -nargs=1 -bang  CheckModify    call s:veeklist._modify_gap(<q-args>)
