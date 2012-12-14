let s:save_cpo = &cpo| set cpo&vim
"=============================================================================

"記録
"USAGE: Veek {num}, {arg}           ; {arg}をVeek{num}に記録する ※{num}は正の整数である
"USAGE: Veek {-num1}, {num2}, {arg} ; {arg}を{num1}から{num2}までのVeek全てに記録する
"USAGE: Veek {[num1,num2]}, {arg}   ; {arg}を{num1}から{num2}までのVeek全てに記録する
"USAGE: Veek {num}, {arg}, {"msg"}  ; {"msg"}をつけて{arg}をVeek{num}に記録する
"USAGE: Veek {-num1}, {num2}, {arg}, {"msg"}
"                                   ; {"msg"}をつけて{arg}を{num1}から{num2}までのVeek全てに記録する
"USAGE: Veek {[num1,num2]}, {arg}, {"msg"}
"                                   ; {"msg"}をつけて{arg}を{num1}から{num2}までのVeek全てに記録する

"閲覧
"USAGE: Veek                  ; 有効な全てのVeekの現在ステータスを見る(定義順)
"USAGE: Veek!                 ; 有効な全てのVeekの現在ステータスを見る(番号順)
"USAGE: Veek {num}            ; Veek{num}の現在ステータスを見る
"USAGE: Veek! {num}           ; Veek{num}の過去から現在までのステータスを見る
"USAGE: Veek {-num1}, {-num2} ; Veek{num1}の{num2}つ過去から現在までのステータスを見る
"USAGE: Veek {[num1,-num2]}   ; Veek{num1}の{num2}つ過去から現在までのステータスを見る
"USAGE: Veek {-num}           ; {num}以降のVeekの現在ステータスを見る(定義順)
"USAGE: Veek! {-num}          ; {num}以降のVeekの現在ステータスを見る(番号順)
"USAGE: Veek {[num]}          ; {num}以降のVeekの現在ステータスを見る(定義順)
"USAGE: Veek! {[num]}         ; {num}以降のVeekの現在ステータスを見る(番号順)
"USAGE: Veek {[num1,num2]}    ; {num1}から{num2}までのうち有効なVeek全ての現在ステータスを見る(定義順)
"USAGE: Veek {-num1}, {num2}  ; {num1}から{num2}までのうち有効なVeek全ての現在ステータスを見る(定義順)
"USAGE: Veek! {[num1,num2]}   ; {num1}から{num2}までのうち有効なVeek全ての現在ステータスを見る(番号順)
"USAGE: Veek! {-num1}, {num2} ; {num1}から{num2}までのうち有効なVeek全ての現在ステータスを見る(番号順)

"削除
"USAGE: Veek 0, {num}               ; {num}Veekを削除する
"USAGE: Veek 0, {num1}, {num2}      ; {num1}から{num2}のVeekを削除する
"USAGE: Veek 0, [{num1},{num2}]     ; {num1}から{num2}のVeekを削除する
"USAGE: Veek 0, {-num}              ; {num}から最後までのVeekを削除する
"USAGE: Veek 0, {[num]}             ; {num}から最後までのVeekを削除する
"USAGE: Veek 0, 0                   ; 全てのVeekを削除する

"CAUTION: it does not correspond to the script local variable.
"CAUTION: :Veek のある行にコメントを付けることは出来ない
command! -nargs=* -bang  Veek    call veek#veek(<q-bang>, <q-args>, <args>)


"=============================================================================
"USAGE: let a = Veek()              ; 自動で番号を付けてVeekインターフェイスを作成
"USAGE: let a = Veek({name})        ; 名前{name}を付けてVeekインターフェイスを作成

"USAGE: call a.set({arg})           ; {arg}をVeekに記録
"USAGE: call a.set({arg}, {msg})    ; {msg}を付けて{arg}をVeekに記録
"USAGE: call a.view()               ; Veekの現在ステータスを見る
"USAGE: call a.view(2)              ; 2つ前のVeekのステータスを見る
"USAGE: call a.view(2, 0)           ; 2つ前から現在までのVeekのステータスを見る
"USAGE: call a.view(1, 4)           ; 1つ前から4つ前までのVeekのステータスを見る
"USAGE: call a.delete()             ; Veekを削除する

"USAGE: Veek {name}, {arg}          ; {arg}をVeek{name}に記録する
"USAGE: Veek {name}, {arg}, {"msg"} ; {"msg"}をつけて{arg}をVeek{num}に記録する
"USAGE: Veek {name}                 ; Veek{name}の現在ステータスを見る
"USAGE: Veek 0, {name}              ; Veek{name}を削除する
function! Veek(...) "{{{
  return call('veek#instance#namedveek#new', a:000)
endfunction
"}}}




"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
