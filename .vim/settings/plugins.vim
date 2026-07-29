" Load plug
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter', {'branch': 'main'}
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'itchyny/vim-cursorword'
Plug 'liuchengxu/eleline.vim'
Plug 'jonathanfilip/vim-lucius'
Plug 'matze/vim-move'
Plug 'navicore/vissort.vim'
Plug 'roman/golden-ratio'
Plug 'scrooloose/nerdcommenter'
Plug 'skywind3000/vim-auto-popmenu'
Plug 'skywind3000/vim-dict'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
call plug#end()

" color scheme
let g:lucius_style = 'dark'
let g:lucius_contrast = 'high'
let g:lucius_contrast_bg = 'normal'
let g:lucius_use_bold = 1
let g:lucius_user_underline = 1
try
  colorscheme lucius
catch
endtry

" easymotion
" Disable default mappings
let g:EasyMotion_do_mapping = 0
" <Leader>f{char} to move to {char}
nmap <silent> <Leader>f <Plug>(easymotion-overwin-f)

" nerdcommenter
nmap <Leader>/ <Plug>NERDCommenterToggle
vmap <Leader>/ <Plug>NERDCommenterToggle

" fzf.vim
let g:fzf_action = {
  \   'enter': 'tab split',
  \   'ctrl-x': 'split',
  \   'ctrl-v': 'vsplit' }
nnoremap <silent> <F11> :Files<cr>
nnoremap <silent> <F12> :History<cr>

" Default fzf layout
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_buffers_jump = 1

" Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" surround.vim config
vnoremap Si S(i<esc>f)

" Git gutter (Git diff)
let g:gitgutter_enabled = 1

" vim-auto-popmenu
let g:apc_enable_ft = {'*' : 1}
set cpt=.,k,w,b
set shortmess+=c
set completeopt=menu,menuone,noselect

" vim-dict
let g:vim_dict_dict = [
  \ '~/.vim/dict',
  \ ]
let g:vim_dict_config = {
  \ 'html':'html,javascript,css,text',
  \ 'markdown':'text',
  \ }

" vim-move
let g:move_map_keys = 0
let g:move_auto_indent = 1
let g:move_past_end_of_line = 1

" Mac-specific keybindings for vim-move (Option+hjkl as Meta)
if has("mac") || has("macunix")
  vmap ∆ <Plug>MoveBlockDown
  vmap ˚ <Plug>MoveBlockUp
  vmap ˙ <Plug>MoveCharLeft
  vmap ¬ <Plug>MoveBlockRight
  nmap ∆ <Plug>MoveLineDown
  nmap ˚ <Plug>MoveLineUp
  nmap ˙ <Plug>MoveCharLeft
  nmap ¬ <Plug>MoveCharRight
endif
