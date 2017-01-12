" Load plug
call plug#begin('~/.vim/plugged')
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim'
Plug 'Townk/vim-autoclose'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'amix/open_file_under_cursor.vim'
Plug 'eagletmt/neco-ghc'
Plug 'godlygeek/tabular'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'jonathanfilip/vim-lucius'
Plug 'kien/ctrlp.vim'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mhinz/vim-signify'
Plug 'mkitt/tabline.vim'
Plug 'navicore/vissort.vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'plasticboy/vim-markdown'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'shemerey/vim-peepopen'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/Align'
Plug 'vim-scripts/AutoAlign'
Plug 'vim-scripts/LargeFile'
Plug 'yegappan/mru'
call plug#end()

"  Load pathogen paths
call pathogen#infect('~/.vim/infected/{}')
call pathogen#helptags()

" color scheme
let g:lucius_style          = 'dark'
let g:lucius_contrast       = 'high'
let g:lucius_contrast_bg    = 'normal'
let g:lucius_use_bold       = 1
let g:lucius_user_underline = 1
try
  colorscheme lucius
catch
endtry

"  bufExplorer plugin
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
"map <leader>o :BufExplorer<cr>

"  MRU plugin
let MRU_Max_Entries = 400
map <silent> <leader>f :MRU<CR>

"  YankStack
nmap <silent> <c-p> <Plug>yankstack_substitute_older_paste
nmap <silent> <c-P> <Plug>yankstack_substitute_newer_paste

"  CTRL-P
let g:ctrlp_working_path_mode = 0

let g:ctrlp_map = '<c-f>'
map <silent> <leader>g :CtrlP<cr>
map <silent> <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'

"  ZenCoding
" Enable all functions in all modes
let g:user_zen_mode='a'

"  Vim grep
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH

"  Nerd Tree
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden= 0
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.class$', '\.DS_Store$']
let g:NERDTreeWinSize=35
map <silent> <F9> :NERDTreeMirror<CR>
map <silent> <F9> :NERDTreeToggle<CR>
let g:nerdtree_tabs_open_on_console_startup = 1
let g:nerdtree_tabs_autofind                = 1

"  vim-multiple-cursors
let g:multi_cursor_next_key="\<C-s>"

"  surround.vim config
" Annotate strings with gettext http://amix.dk/blog/post/19678
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme                      ='wombat'

"  Vimroom
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>

"  Vim-go
" let g:go_fmt_command = "goimports"

"  Syntastic (syntax checker)
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_ignore_files = [".*\.xml$"] 
" Python
let g:syntastic_python_checkers=['pyflakes']

" Javascript
"let g:syntastic_javascript_checkers = ['jshint']

" Go
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

" Custom CoffeeScript SyntasticCheck
func! SyntasticCheckCoffeescript()
    let l:filename = substitute(expand("%:p"), '\(\w\+\)\.coffee', '.coffee.\1.js', '')
    execute "tabedit " . l:filename
    execute "SyntasticCheck"
    execute "Errors"
endfunc
"nnoremap <silent> <leader>c :call SyntasticCheckCoffeescript()<cr>

"  Git gutter (Git diff)
let g:gitgutter_enabled=0
nnoremap <silent> <leader>d :GitGutterToggle<cr>

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" neco-ghc
let g:necoghc_enable_detailed_browse = 1

" neocomplete plugin
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1

let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }
" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  "return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"
" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1
" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags " Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
