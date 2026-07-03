function! DeleteTrailingWS() abort
  execute "normal mz"
  %s/\s\+$//e
  execute "normal `z"
endfunction

function! JavaScriptFold() abort
  setlocal foldmethod=indent
  setlocal foldlevelstart=1
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

  function! FoldText() abort
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
  endfunction
  setlocal foldtext=FoldText()
endfunction

function! CoffeeScriptFold() abort
  setlocal foldmethod=indent
  setlocal foldlevelstart=1
endfunction

function! JsonFormat() abort
  %!python -m json.tool
endfunction

" Python
autocmd FileType python syn keyword pythonDecorator True None False self
autocmd FileType python nnoremap <buffer> F :set foldmethod=indent<cr>
autocmd FileType python setlocal cindent
autocmd FileType python setlocal cinkeys-=0#
autocmd FileType python setlocal indentkeys-=0#
autocmd BufNewFile,BufRead *.jinja set syntax=htmljinja
autocmd BufNewFile,BufRead *.mako set filetype=mako
autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
autocmd BufWrite *.py call DeleteTrailingWS()

" JavaScript
autocmd FileType javascript call JavaScriptFold()
autocmd FileType javascript setlocal fen
autocmd FileType javascript setlocal nocindent

" Json
autocmd InsertLeave *.json setlocal conceallevel=0 concealcursor=inc
autocmd FileType json nnoremap <buffer> =j :call JsonFormat()<cr>gg=G<cr>

" Markdown
autocmd InsertLeave *.md setlocal conceallevel=0 concealcursor=inc

" Scala is intentionally omitted from active configs

" CoffeeScript
autocmd BufWrite *.coffee call DeleteTrailingWS()
autocmd FileType coffee call CoffeeScriptFold()

" Git
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
autocmd CompleteDone * pclose
