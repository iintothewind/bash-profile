" Basic

" General
" Sets how many lines of history VIM has to remember
set history=500

" noncompatible with vi
set nocompatible

" Enable filetype plugins
filetype plugin on
filetype indent on

"set splitbelow
set splitright

" Set to auto read when a file is changed from the outside
set autoread
set autowrite
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ";"
let g:mapleader = ";"

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Set 7 lines to the cursor - when moving vertically using j/k
" set so=7

set helplang=cn
" set encoding
if has("multi_byte")
  set encoding=utf-8
  set termencoding=utf-8
  set formatoptions+=mM
  set fencs=utf-8,gbk
  if v:lang =~? '^/(zh/)/|/(ja/)/|/(ko/)'
    set ambiwidth=double
  endif
  if has("win32")
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8
  endif
else
  echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

" Turn on the WiLd menu
set wildchar=<TAB>
set wildmenu
set wildmode=longest:full,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
"set ruler

" Height of the command bar
"set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=2
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
"set hlsearch
" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" highlight cursor line
set cul

" For regular expressions turn magic on
set magic
set number
set relativenumber
" Show matching brackets when text indicator is over them
set showmatch
set showmode
" How many tenths of a second to blink when matching brackets
set mat=2

set showcmd
" disable default welcome messages
set shortmess=atI
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
  autocmd GUIEnter * set vb t_vb=
endif

" fold according to indent
set fdl=99
set fdls=1
set fdm=manual

" Enable syntax highlighting
syntax enable

"set clipboard=unnamed
nmap <leader>p "+p
vmap <leader>y "+y
vmap <leader>d "+d<cr>

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

set background=dark
try
  colorscheme desert
catch
endtry

" Set extra options when running in GUI mode
if has('gui_running')
  set guifont=Monospace:bold:h9:cGB2312
  set guioptions-=m
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L
  set guicursor=n-v-c:blinkon0
  set t_Co=256
  set guitablabel=%M\ %t
  nnoremap <leader><F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
  nnoremap <leader><F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
  nnoremap <leader><F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>
endif
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

set backup
set backupdir=~/.vim/backup,/tmp
set directory=~/.vim/swap,/tmp

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

set viminfo+=!
set iskeyword+=_,$,@,%,#,-
" Linebreak on 300 characters
set lbr
set tw=300

set autoindent
set smartindent
set wrap


" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>
map <silent> <F2> :noh<cr>
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" map macro recording from q to leader-q
noremap <Leader>q q
noremap q <Nop>

" map redo C-r to r
map <silent> r :red<cr>

" Useful mappings for managing tabs
map <silent> gb :tabprev<cr>
"map <silent> gt :tabnext<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Always show the status line
set laststatus=2

" Format the status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}][TYPE=%Y][POS=%l,%v][%p%%]

" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
"nmap <silent> <leader>j mz:m+<cr>`z
"nmap <silent> <leader>k mz:m-2<cr>`z
"vmap <silent> <leader>j :m'>+<cr>`<my`>mzgv`yo`z
"vmap <silent> <leader>k :m'<-2<cr>`>my`<mzgv`yo`z


" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


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
