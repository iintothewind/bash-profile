func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

func! JavaScriptFold()
  setl foldmethod=indent
  setl foldlevelstart=1
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

  func! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
  endfunc
  setl foldtext=FoldText()
endfunc

func! CoffeeScriptFold()
  setl foldmethod=indent
  setl foldlevelstart=1
endfunc

func! JsonFormat()
  :%!python -m json.tool
endfunc

" Python
au FileType python syn keyword pythonDecorator True None False self
au FileType python map <buffer> F :set foldmethod=indent<cr>
au FileType python set cindent
au FileType python set cinkeys-=0#
au FileType python set indentkeys-=0#
au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako
au BufNewFile,BufRead *.py setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
au BufWrite *.py :call DeleteTrailingWS()

" JavaScript
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

" Json
au InsertLeave *.json setlocal conceallevel=0 concealcursor=inc
au FileType json map <buffer> =j :call JsonFormat()<cr>gg=G<cr>

" Markdown
au InsertLeave *.md setlocal conceallevel=0 concealcursor=inc

" Scala
"au BufLeave *.java,*.scala try | call ensime#au_buf_leave(expand("<afile>")) | catch | endtry
"au VimLeave *.java,*.scala try | call ensime#au_vim_leave(expand("<afile>")) | catch | endtry

" CoffeeScript
au BufWrite *.coffee :call DeleteTrailingWS()
au FileType coffee call CoffeeScriptFold()

" Git
au FileType gitcommit call setpos('.', [0, 1, 1, 0])
au CompleteDone * pclose
