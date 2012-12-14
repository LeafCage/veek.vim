let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
function! veek#util#avsolutize_list_contents(list) "{{{
  let int = type(1)
  let ret = []
  for c in a:list
    if type(c) == int
      call add(ret, (c < 0 ? c*-1 : c))
    else
      call add(ret, c)
    endif
  endfor
  return ret
endfunction
"}}}

function! veek#util#veeks_echo(veeks) "{{{
  let veeks = type(a:veeks) == type([]) ? a:veeks : [a:veeks]
  for g in veeks
    let info = printf("%4s%3s: %-45s (%s)%s\n          %s",
      \'['.g.ago.']',
      \ string(g.name),
      \ '"'.g.expr.'"', g.stacktrace,
      \ (g.msg!='' ? "\n".'         #comment:   '. g.msg : ''),
      \ string(g.val)
      \ )
    echo info
  endfor
endfunction
"}}}
"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
