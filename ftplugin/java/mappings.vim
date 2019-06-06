runtime codegen_lib/transformers.vim
runtime codegen_lib/functionals.vim
runtime codegen_lib/format.vim
runtime codegen_lib/core.vim


" All of these are leader commands now, cause otherwise stuff
" like jo interferes with words like join, and that we can't have!

" java section header comments
autocmd FileType java inoremap <buffer> /* /*  */<Left><Left><Left>

" java println
" Note: this also is the implementation of this tool
autocmd FileType java inoremap <buffer> <leader>js <Esc>ISystem.out.println(<Esc>A);<Esc>V=$F)i
autocmd FileType java nnoremap <buffer> <leader>js ISystem.out.println(<Esc>A);<Esc>V=$F)

" java object
autocmd FileType java inoremap <buffer> <leader>jo <Esc>:call  ObjLiteral(Visibility(0))<Cr>
autocmd FileType java inoremap <buffer> <leader>jpo <Esc>:call ObjLiteral(Visibility(1))<Cr>
autocmd FileType java inoremap <buffer> <leader>jPo <Esc>:call ObjLiteral(Visibility(2))<Cr>

" java object constructor
autocmd FileType java inoremap <buffer> <leader>joc <Esc>:call  ObjConstructor(Visibility(0))<Cr>
autocmd FileType java inoremap <buffer> <leader>jpoc <Esc>:call ObjConstructor(Visibility(1))<Cr>
autocmd FileType java inoremap <buffer> <leader>jPoc <Esc>:call ObjConstructor(Visibility(2))<Cr>

" java array
autocmd FileType java inoremap <buffer> <leader>ja <Esc>:call  ArrLiteral(Visibility(0))<Cr>
autocmd FileType java inoremap <buffer> <leader>jpa <Esc>:call ArrLiteral(Visibility(1))<Cr>
autocmd FileType java inoremap <buffer> <leader>jPa <Esc>:call ArrLiteral(Visibility(2))<Cr>

" java array constructor
autocmd FileType java inoremap <buffer> <leader>jac <Esc>:call  ArrConstructor(Visibility(0))<Cr>
autocmd FileType java inoremap <buffer> <leader>jpac <Esc>:call ArrConstructor(Visibility(1))<Cr>
autocmd FileType java inoremap <buffer> <leader>jPac <Esc>:call ArrConstructor(Visibility(2))<Cr>

" " java array list constructor
" autocmd FileType java inoremap <buffer> <leader>jl <Esc>:call ListCon(0, 1)<Cr>
" autocmd FileType java inoremap <buffer> <leader>jpl <Esc>:call ListCon(1, 1)<Cr>
" autocmd FileType java inoremap <buffer> <leader>jPl <Esc>:call ListCon(2, 1)<Cr>

" " java static final
" autocmd FileType java inoremap <buffer> <leader>jpsfo <Esc>:call ConLit(1)<Cr>
" autocmd FileType java inoremap <buffer> <leader>jPsfo <Esc>:call ConLit(2)<Cr>
"
" " java static final array
" autocmd FileType java inoremap <buffer> <leader>jpsfa <Esc>:call ConArrLiteral(1)<Cr>
" autocmd FileType java inoremap <buffer> <leader>jPsfa <Esc>:call ConArrLiteral(2)<Cr>
"
" " java static final constructor<buffer>
" autocmd FileType java inoremap <buffer> <leader>jpsfoc <Esc>:call ConCon(1)<Cr>
" autocmd FileType java inoremap <buffer> <leader>jPsfoc <Esc>:call ConCon(2)<Cr>
"
" " java static final array const<buffer> ructor
" autocmd FileType java inoremap <buffer> <leader>jpsfac <Esc>:call ConArrCon(1)<Cr>
" autocmd FileType java inoremap <buffer> <leader>jPsfac <Esc>:call ConArrCon(2)<Cr>
"
" " java static final ArrayList
" autocmd FileType java inoremap <buffer> <leader>jpsfl <Esc>:call ConListCon(1)<Cr>
" autocmd FileType java inoremap <buffer> <leader>jPsfl <Esc>:call ConListCon(2)<Cr>

" java method
autocmd FileType java inoremap <buffer> <leader>jpm <Esc>:call  MakeMethod(Visibility(1))<Cr>
autocmd FileType java inoremap <buffer> <leader>jPm <Esc>:call  MakeMethod(Visibility(2))<Cr>
autocmd FileType java inoremap <buffer> <leader>jpsm <Esc>:call MakeMethod(Visibility(1).'static ')<Cr>
autocmd FileType java inoremap <buffer> <leader>jPsm <Esc>:call MakeMethod(Visibility(2).'static ')<Cr>

" loops
autocmd FileType java inoremap <buffer> jfor <Esc>:call   For()<Cr>
autocmd FileType java inoremap <buffer> jwhile <Esc>:call While()<Cr>
autocmd FileType java inoremap <buffer> jdo <Esc>:call    DoWhile()<Cr>
autocmd FileType java inoremap <buffer> jeach <Esc>:call  ForEach()<Cr>

" conditional blocks
autocmd FileType java inoremap <buffer> jif <Esc>:call   If()<Cr>
autocmd FileType java inoremap <buffer> jelif <Esc>:call ElseIf()<Cr>
autocmd FileType java inoremap <buffer> jelse <Esc>:call Else()<Cr>

" conditional oneliners
autocmd FileType java inoremap <buffer> Jif <Esc>:call   IfOne()<Cr>
autocmd FileType java inoremap <buffer> Jelif <Esc>:call ElseIfOne()<Cr>
autocmd FileType java inoremap <buffer> Jelse <Esc>:call ElseOne()<Cr>

" switch statement
autocmd FileType java inoremap <buffer> jswitch <Esc>:call Switch()<Cr>

" javadocs
autocmd FileType java nnoremap <buffer> <leader>jdoc :call Jdoc()<Cr>
