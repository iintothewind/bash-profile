" options.vim: `set` options that need no plugin. Sourced first by ~/.vimrc.
"   - full option names (cursorline, not cul)
"   - no line for an option that would only repeat Vim's default
"   - an option a plugin needs is set in that plugin's section of plugins.vim, GUI options in ~/.vim/gvimrc
"   - no external command runs here; the only side effect is creating the swap and backup directories

" Has to be the first command: `vim -u <file>` starts Vi-compatible. A no-op in a normal start.
set nocompatible

" --- files and encodings ------------------------------------------------------
set encoding=utf-8
set fileencodings=utf-8,gbk
set fileformats=unix,dos,mac
" East Asian locales: characters of ambiguous width take two cells
if v:lang =~? '^\(zh\|ja\|ko\)'
  set ambiwidth=double
endif
set autoread
set autowrite
set hidden
set history=500

" --- swap and backup files ----------------------------------------------------
" They go to private directories outside ~/.vim (sync_cfg mirrors ~/.vim with rsync --delete).
" Candidates in order of preference, RAM-backed (tmpfs) first. Every usable one is listed in the
" option, so Vim moves on to the next one when a directory is full or has disappeared:
"   /dev/shm/vim-$USER     Linux: tmpfs, survives logout, emptied by a reboot
"   $XDG_RUNTIME_DIR/vim   Linux with systemd: tmpfs, removed at the last logout
"   ~/.local/state/vim     every OS: on disk. The only candidate on macOS and Termux (no tmpfs there)
" With no usable candidate Vim's defaults stay in place.

" s:private_dir(dir): create {dir} with mode 0700 when it is missing. True when {dir} then is a
" real directory (no symlink) with mode 0700 that we can write to: in the world-writable /dev/shm
" this rejects a directory that another user prepared.
function! s:private_dir(dir) abort
  if !isdirectory(a:dir)
    silent! call mkdir(a:dir, 'p', 0700)
  endif
  return getftype(a:dir) ==# 'dir' && getfperm(a:dir) ==# 'rwx------' && filewritable(a:dir) == 2
endfunction

let s:candidates = []
if isdirectory('/dev/shm') && !empty($USER)
  call add(s:candidates, '/dev/shm/vim-' . $USER)
endif
if !empty($XDG_RUNTIME_DIR)
  call add(s:candidates, $XDG_RUNTIME_DIR . '/vim')
endif
call add(s:candidates, expand('~/.local/state/vim'))

let s:swap_dirs = []
let s:backup_dirs = []
for s:dir in s:candidates
  if s:private_dir(s:dir) && s:private_dir(s:dir . '/swap') && s:private_dir(s:dir . '/backup')
    " the trailing // puts the full path of the edited file into the file name: no name clashes
    call add(s:swap_dirs, s:dir . '/swap//')
    call add(s:backup_dirs, s:dir . '/backup//')
  endif
endfor
if !empty(s:swap_dirs)
  let &directory = join(s:swap_dirs, ',')
  let &backupdir = join(s:backup_dirs, ',')
endif
set backup

" --- display --------------------------------------------------------------------
" dark background; it also selects the dark variant of the color scheme set in plugins.vim
set background=dark
set number
set relativenumber
set cursorline
set showcmd
set showmatch
set matchtime=2
" abbreviated messages, no intro screen
set shortmess=atI
set belloff=all
set lazyredraw
" always a status line (eleline.vim draws it) and a tab line
set laststatus=2
set showtabline=2
set splitright
" a buffer opens with the folds below the first level closed; folds exist only where a filetype
" sets a fold method (JavaScript in autocmds.vim)
set foldlevel=99
set foldlevelstart=1

" --- searching ------------------------------------------------------------------
set ignorecase
set smartcase
set incsearch

" --- editing --------------------------------------------------------------------
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
" 2 spaces per indent level; filetypes that differ are in autocmds.vim
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent
" $ % # - are word characters
set iskeyword+=$,%,#,-

" --- command line and key timing --------------------------------------------------
set wildmenu
set wildmode=longest:full,full
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
" 500 ms to finish a mapping, 100 ms for the bytes of one key: <Esc> takes effect at once
set timeoutlen=500
set ttimeout
set ttimeoutlen=100

" --- buffers and tabs -------------------------------------------------------------
" jumping to a buffer (quickfix, :sbuffer) goes to the window or tab that shows it, else opens a tab
set switchbuf=useopen,usetab,newtab
