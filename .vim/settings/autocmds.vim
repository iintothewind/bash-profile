" autocmds.vim: autocommands, the general ones first, then one block per filetype.
" Sourced last by ~/.vimrc. plugins.vim has to come first: plug#end() registers Vim's own
" filetype autocommands, and ours must be defined after those, so that they override what a
" ftplugin sets and so that &filetype is already known in BufReadPost.
"   - every autocommand is inside `augroup vimrc`, which is cleared first: sourcing again is safe
"   - filetype settings use setlocal and <buffer> mappings
"   - a helper function is script-local (s:name) and sits above the augroup

" s:strip_trailing_space(): delete trailing white space in the whole buffer, keeping the view
" and the search pattern.
function! s:strip_trailing_space() abort
  let l:view = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

" s:json_format(): reformat the whole buffer with Python's json.tool.
function! s:json_format() abort
  if executable('python3')
    %!python3 -m json.tool
  elseif executable('python')
    %!python -m json.tool
  else
    echoerr 'python/python3 not found'
  endif
endfunction

augroup vimrc
  autocmd!

  " --- every file -----------------------------------------------------------------
  " reopen a file on the line where it was left; a commit message always starts at the top
  autocmd BufReadPost *
    \ if &filetype !=# 'gitcommit' && line("'\"") > 1 && line("'\"") <= line('$')
    \ |   execute "normal! g'\""
    \ | endif

  " --- Python ---------------------------------------------------------------------
  " 4 spaces per indent level, Unix line ends, no trailing white space
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab fileformat=unix
  autocmd BufWritePre *.py call s:strip_trailing_space()
  " True, None, False and self in the color of decorators
  autocmd FileType python syntax keyword pythonDecorator True None False self
  " F folds by indentation
  autocmd FileType python nnoremap <buffer> F :set foldmethod=indent<CR>

  " --- JavaScript -----------------------------------------------------------------
  " fold by indentation; a closed fold shows its first line with the block cut to {...}
  autocmd FileType javascript setlocal foldmethod=indent foldtext=substitute(getline(v:foldstart),'{.*','{...}','')

  " --- JSON -----------------------------------------------------------------------
  " =j reformats the buffer with json.tool, then re-indents it to the shiftwidth
  autocmd FileType json nnoremap <buffer> =j :call <SID>json_format()<CR>gg=G<CR>
augroup END
