" Helper functions
func! DeleteTillSlash()
  let g:cmd = getcmdline()

  if has("win16") || has("win32")
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
  else
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  endif

  if g:cmd == g:cmd_edited
    if has("win16") || has("win32")
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
    else
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    endif
  endif

  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc


func! GitBlame()
  echo split(split(system('git --no-pager blame -L ' . line('.') . ',+1 ' . expand('%')), '\n')[0], ') ')[0]
endfunc

" GUI related
" Set gui font according to system
if has("mac") || has("macunix")
  set gfn=Hack:h14,Source\ Code\ Pro:h12,Menlo:h11
elseif has("win16") || has("win32")
  set gfn=Hack:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
  set gfn=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
  set gfn=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
  set gfn=Monospace\ 11
endif

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call CmdLine("Ag \"" . l:pattern . "\" " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
"set guioptions-=r
"set guioptions-=R
"set guioptions-=l
"set guioptions-=L

" Fast editing and reloading of vimrc configs
autocmd! bufwritepost vimrc source ~/.vimrc

" Turn persistent undo on
" means that you can undo even when you close a buffer/VIM
"try
"    set undodir=~/.vim/undo
"    set undofile
"catch
"endtry

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
" use $q in command line that ends with a path
cnoremap $q <C-\>eDeleteTillSlash()<cr>
" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

nnoremap <C-N> <C-D>
nnoremap <Leader>gb :call GitBlame()<CR>



" turn tab to spaces
set expandtab

" Shell section
if exists('$TMUX')
  set term=screen-256color
endif
