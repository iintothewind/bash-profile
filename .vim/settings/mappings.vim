" mappings.vim: <Leader>, key mappings and user commands that need no plugin.
" Sourced by ~/.vimrc after options.vim. The mappings of a plugin are in plugins.vim, the
" buffer-local ones of a filetype in autocmds.vim.
"   - non-recursive forms only (nnoremap, vnoremap, cnoremap, noremap)
"   - no comment at the end of a mapping line: it would become part of the mapping
"   - a helper function is script-local (s:name, called through <SID>) and sits right above the
"     only mapping that uses it

let g:mapleader = ';'

" --- commands -------------------------------------------------------------------
" :W writes the buffer through sudo, for a file opened without the permission to write it
command! W w !sudo tee % > /dev/null

" --- clipboard and macros ---------------------------------------------------------
" <Leader>p pastes from the system clipboard; <Leader>y / <Leader>d copy / cut the selection to it
nnoremap <Leader>p "+p
vnoremap <Leader>y "+y
vnoremap <Leader>d "+d<CR>
" <Leader>q records a macro; a plain q does nothing
noremap <Leader>q q
noremap q <Nop>

" --- moving and searching ---------------------------------------------------------
" 0 goes to the first non-blank character of the line
nnoremap 0 ^
" <C-N> scrolls half a page down, like <C-D>
nnoremap <C-N> <C-D>
" <F2> hides the search highlighting until the next search
nnoremap <silent> <F2> :nohlsearch<CR>

" s:search_selection(): make the text selected last the search pattern, taken literally.
function! s:search_selection() abort
  let l:saved = @"
  normal! gvy
  let @/ = substitute(escape(@", '\/.*$^~[]'), '\n$', '', '')
  let @" = l:saved
endfunction
" in Visual mode * and # search for the selection, forward and backward
vnoremap <silent> * :<C-U>call <SID>search_selection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-U>call <SID>search_selection()<CR>?<C-R>=@/<CR><CR>

" --- windows and tabs -------------------------------------------------------------
" <C-H> <C-J> <C-K> <C-L> go to the window on the left, below, above, on the right
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
" gb goes to the previous tab (gt is the next one), <Leader>tl to the tab used last
nnoremap <silent> gb :tabprevious<CR>
nnoremap <Leader>tl g<Tab>
" <Leader>cd makes the directory of the current file the working directory
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" --- command line -----------------------------------------------------------------
" as in Bash: <C-A> start of the line, <C-E> end of the line, <C-K> delete back to the start
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>

" s:delete_till_slash(): the command line cut back to its last slash, or to the one before it
" when the line already ends with a slash.
function! s:delete_till_slash() abort
  let l:cmd = getcmdline()
  let l:edited = substitute(l:cmd, '\(.*[/]\).*', '\1', '')
  if l:cmd ==# l:edited
    let l:edited = substitute(l:cmd, '\(.*[/]\).*/', '\1', '')
  endif
  return l:edited
endfunction
" $q removes the last path component: `:e ~/a/b/c$q` leaves `:e ~/a/b/`
cnoremap $q <C-\>e<SID>delete_till_slash()<CR>

" --- git ------------------------------------------------------------------------
" s:git_blame(): echo commit, author and date of the last change to the current line.
function! s:git_blame() abort
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
" <Leader>gb shows who changed the current line last
nnoremap <Leader>gb :call <SID>git_blame()<CR>
