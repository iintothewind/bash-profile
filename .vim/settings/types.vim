" Python
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self
au FileType python setl cindent
au FileType python setl cinkeys-=0#
au BufNewFile,BufRead *.py setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
au FileType python setl indentkeys-=0#
au BufNewFile,BufRead *.jinja setl syntax=htmljinja
au BufNewFile,BufRead *.mako setl ft=mako

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
