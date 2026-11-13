" plugins.vim: the vim-plug plugin list, then one section per plugin with its settings, the
" options it needs and its mappings.
" Sourced by ~/.vimrc after mappings.vim (<Leader> is set there) and before autocmds.vim.
"   - plugins are installed in ~/.local/share/vim/plugged, not in ~/.vim: sync_cfg mirrors ~/.vim
"     with rsync --delete. After editing the list run :PlugInstall (or :PlugClean)
"   - vim-plug itself is the vendored ~/.vim/autoload/plug.vim
"   - a plugin reached only through commands or <Plug> mappings loads on first use (`on`); one
"     that hooks events, creates default mappings or draws the UI loads at startup
"   - a mapping to a plugin is recursive (nmap, vmap): its target is a mapping itself
"   - no line for a setting that would only repeat the plugin's default

call plug#begin('~/.local/share/vim/plugged')
Plug 'easymotion/vim-easymotion', { 'on': '<Plug>(easymotion-overwin-f)' }
Plug 'godlygeek/tabular', { 'on': ['Tabularize', 'GTabularize', 'AddTabularPattern', 'AddTabularPipeline'] }
Plug 'itchyny/vim-cursorword'
Plug 'liuchengxu/eleline.vim'
Plug 'jonathanfilip/vim-lucius'
Plug 'matze/vim-move'
Plug 'navicore/vissort.vim'
Plug 'preservim/nerdcommenter'
Plug 'skywind3000/vim-auto-popmenu'
Plug 'skywind3000/vim-dict'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" plug#end() also runs `filetype plugin indent on` and `syntax enable`: do not repeat them.
call plug#end()

" --- vim-lucius: color scheme -----------------------------------------------------
let g:lucius_contrast = 'high'
" no error on a machine where :PlugInstall has not run yet
try
  colorscheme lucius
catch /:E185:/
endtry

" --- vim-easymotion ---------------------------------------------------------------
let g:EasyMotion_do_mapping = 0
" <Leader>f{char} jumps to a {char} in any window
nmap <silent> <Leader>f <Plug>(easymotion-overwin-f)

" --- nerdcommenter ----------------------------------------------------------------
" <Leader>/ toggles the comment on the line or the selection; its <Leader>c... defaults stay
nmap <Leader>/ <Plug>NERDCommenterToggle
vmap <Leader>/ <Plug>NERDCommenterToggle

" --- fzf.vim ----------------------------------------------------------------------
" <F11> picks a file below the working directory, <F12> a recently opened file
nnoremap <silent> <F11> :Files<CR>
nnoremap <silent> <F12> :History<CR>
" <CR> opens the pick in a new tab, <C-X> in a split, <C-V> in a vertical split
let g:fzf_action = {
  \ 'enter': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_buffers_jump = 1

" --- vim-surround -----------------------------------------------------------------
" Si in Visual mode wraps the selection in ( ) and puts the cursor on the closing one
vmap Si S(i<Esc>f)

" --- vim-auto-popmenu: completion menu while typing -------------------------------
let g:apc_enable_ft = { '*': 1 }
" complete from this buffer, the dictionaries (vim-dict), other windows, other buffers
set complete=.,k,w,b
set completeopt=menu,menuone,noselect
set shortmess+=c

" --- vim-dict: dictionaries for the `k` source above ------------------------------
" dictionaries to use for a filetype instead of only the one named after it
let g:vim_dict_config = {
  \ 'html': 'html,javascript,css,text',
  \ 'markdown': 'text' }

" --- vim-move ---------------------------------------------------------------------
" no default <A-h/j/k/l> mappings: on macOS Option+h/j/k/l types the characters below, which
" move the current line or the selection
let g:move_map_keys = 0
if has('mac') || has('macunix')
  vmap ∆ <Plug>MoveBlockDown
  vmap ˚ <Plug>MoveBlockUp
  vmap ˙ <Plug>MoveBlockLeft
  vmap ¬ <Plug>MoveBlockRight
  nmap ∆ <Plug>MoveLineDown
  nmap ˚ <Plug>MoveLineUp
  nmap ˙ <Plug>MoveCharLeft
  nmap ¬ <Plug>MoveCharRight
endif
