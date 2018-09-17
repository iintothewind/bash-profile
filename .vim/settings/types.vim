" Python
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self
au BufNewFile,BufRead *.py setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
au FileType python map <buffer> F :set foldmethod=indent<cr>
au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f #--- <esc>a
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def
au FileType python set cindent
au FileType python set cinkeys-=0#
au FileType python set indentkeys-=0#
au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

" JavaScript
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

" Json
au InsertEnter *.json setlocal conceallevel=0 concealcursor=
au InsertLeave *.json setlocal conceallevel=0 concealcursor=inc

" Markdown
au InsertEnter *.md setlocal conceallevel=0 concealcursor=
au InsertLeave *.md setlocal conceallevel=0 concealcursor=inc

" Scala
au BufWritePost *.scala silent :EnTypeCheck
"au BufLeave *.java,*.scala try | call ensime#au_buf_leave(expand("<afile>")) | catch | endtry
"au VimLeave *.java,*.scala try | call ensime#au_vim_leave(expand("<afile>")) | catch | endtry
nnoremap <localleader>t :EnType<CR>

function! JavaScriptFold()
  setl foldmethod=indent
  setl foldlevelstart=1
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

  function! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
  endfunction
  setl foldtext=FoldText()
endfunction

" CoffeeScript section
function! CoffeeScriptFold()
  setl foldmethod=indent
  setl foldlevelstart=1
endfunction
au FileType coffee call CoffeeScriptFold()

au FileType gitcommit call setpos('.', [0, 1, 1, 0])
au CompleteDone * pclose

" turn tab to spaces
set expandtab

" Shell section
if exists('$TMUX')
  set term=screen-256color
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
