" Helper functions
function! CmdLine(cmd) abort
  call feedkeys(":" . a:cmd . "\<CR>", "n")
endfunction

function! DeleteTillSlash() abort
  let l:cmd = getcmdline()

  if has("win16") || has("win32")
    let l:cmd_edited = substitute(l:cmd, "\\(.*\\[\\\\]\\).*", "\\1", "")
  else
    let l:cmd_edited = substitute(l:cmd, "\\(.*[/]\\).*", "\\1", "")
  endif

  if l:cmd ==# l:cmd_edited
    if has("win16") || has("win32")
      let l:cmd_edited = substitute(l:cmd, "\\(.*\\[\\\\]\\).*\\[\\\\]", "\\1", "")
    else
      let l:cmd_edited = substitute(l:cmd, "\\(.*[/]\\).*/", "\\1", "")
    endif
  endif

  return l:cmd_edited
endfunction

function! CurrentFileDir(cmd) abort
  return a:cmd . " " . expand("%:p:h") . "/"
endfunction

function! GitBlame() abort
  if !executable('git')
    echoerr 'git not found'
    return
  endif
  let l:file = expand('%')
  if empty(l:file)
    echoerr 'no file'
    return
  endif
  let l:out = system('git --no-pager blame -L ' . line('.') . ',+1 -- ' . shellescape(l:file))
  if v:shell_error
    echoerr substitute(l:out, '\n$', '', '')
    return
  endif
  echo split(split(l:out, "\n")[0], ') ')[0]
endfunction

" GUI related
" Set gui font according to system
if has("mac") || has("macunix")
  set guifont=Hack:h14,Source\ Code\ Pro:h12,Menlo:h11
elseif has("win16") || has("win32")
  set guifont=Hack:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2") || has("linux")
  set guifont=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
  set guifont=Monospace\ 11
endif

function! VisualSelection(direction, extra_filter) range abort
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction ==# 'gv'
    if exists(':Rg') == 2
      call CmdLine('Rg ' . fnameescape(l:pattern))
    else
      call CmdLine('grep ' . fnameescape(l:pattern))
    endif
  elseif a:direction ==# 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Fast editing and reloading of vimrc configs
augroup vimrc_reload
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
  autocmd BufWritePost */.vim/settings/*.vim source $MYVIMRC
augroup END

" Turn persistent undo on
" means that you can undo even when you close a buffer/VIM
"try
" set undodir=~/.vim/undo
" set undofile
"catch
"endtry

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
" use $q in command line that ends with a path
cnoremap $q <C-\>eDeleteTillSlash()<cr>
" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>

nnoremap <C-N> <C-D>
nnoremap <Leader>gb :call GitBlame()<CR>
