function! DeleteTrailingWS() abort
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

function! FoldTextBraces() abort
  return substitute(getline(v:foldstart), '{.*', '{...}', '')
endfunction

function! JavaScriptFold() abort
  setlocal foldmethod=indent
  setlocal foldlevelstart=1
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
  setlocal foldtext=FoldTextBraces()
endfunction

function! CoffeeScriptFold() abort
  setlocal foldmethod=indent
  setlocal foldlevelstart=1
endfunction

function! JsonFormat() abort
  if executable('python3')
    %!python3 -m json.tool
  elseif executable('python')
    %!python -m json.tool
  else
    echoerr 'python/python3 not found'
  endif
endfunction

augroup filetype_settings
  autocmd!

  " Python
  autocmd FileType python syn keyword pythonDecorator True None False self
  autocmd FileType python nnoremap <buffer> F :set foldmethod=indent<cr>
  autocmd FileType python setlocal autoindent
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
  autocmd FileType json setlocal conceallevel=0
  autocmd FileType json nnoremap <buffer> =j :call JsonFormat()<cr>gg=G<cr>

  " Markdown
  autocmd FileType markdown setlocal conceallevel=0

  " CoffeeScript
  autocmd BufWrite *.coffee call DeleteTrailingWS()
  autocmd FileType coffee call CoffeeScriptFold()

  " Git
  autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
  autocmd CompleteDone * pclose
augroup END
