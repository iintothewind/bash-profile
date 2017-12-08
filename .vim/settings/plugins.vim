" Load plug
call plug#begin('~/.vim/plugged')
"Plug 'Shougo/neocomplete.vim'
"Plug 'Yggdroot/indentLine'
"Plug 'nathanaelkane/vim-indent-guides'
"Plug 'rking/ag.vim'
"Plug 'scrooloose/syntastic'
"Plug 'tpope/vim-fugitive'
"Plug 'Chiel92/vim-autoformat'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'Shougo/vimproc.vim', {'do': 'make', 'for': 'haskell'}
"Plug 'Valloric/YouCompleteMe', {'do': './install.py', 'for':'nothing'}
Plug 'Valloric/YouCompleteMe', {'do': './install.py'}
Plug 'airblade/vim-gitgutter'
Plug 'derekwyatt/vim-scala', {'for': 'scala'}
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'easymotion/vim-easymotion'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'godlygeek/tabular'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'jonathanfilip/vim-lucius'
Plug 'kien/ctrlp.vim'
Plug 'luochen1990/rainbow'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'navicore/vissort.vim'
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/LargeFile'
Plug 'w0rp/ale', {'tag': 'v1.6.2'}
Plug 'ybian/smartim'
call plug#end()

"  Load pathogen paths
"call pathogen#infect('~/.vim/infected/{}')
"call pathogen#helptags()

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


" ale
"nmap <silent> <F9> <Plug>(ale_previous_wrap)
"nmap <silent> <F10> <Plug>(ale_next_wrap)
nmap <silent> <F9> :lop<cr>
nmap <silent> <F10> :lcl<cr>

" rainbow
let g:rainbow_active = 1

" smartim
let g:smartim_default = 'com.apple.keylayout.ABC'

" easymotion
map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap <Leader>s <Plug>(easymotion-overwin-f2)
" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

"  YankStack
call yankstack#setup()
let g:yankstack_map_keys = 0
let g:yankstack_yank_keys = ['y', 'd']
nmap <silent> <leader>p <Plug>yankstack_substitute_older_paste
nmap <silent> <leader>P <Plug>yankstack_substitute_newer_paste

" nerdcommenter
nmap <Leader>/ <Plug>NERDCommenterToggle
vmap <Leader>/ <Plug>NERDCommenterToggle

" indentLine
"let g:indentLine_enabled = 1
"let g:indentLine_setConceal = 1
"let g:indentLine_conceallevel = 2
""let g:indentLine_char = '│'
"let g:indentLine_concealcursor = ''

" indentGuides
"let g:indent_guides_enable_on_vim_startup = 1
"let g:indent_guides_start_level = 1
"let g:indent_guides_auto_colors = 0
"let g:indent_guides_tab_guides = 1
"let g:indent_guides_space_guides = 1
"let g:indent_guides_indent_levels = 15
"let g:indent_guides_color_change_percent = 7
"set ts=2 sw=2 noet
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=darkgrey
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=black

"  CTRL-P
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_working_path_mode = 0
let g:ctrlp_map               = '<f11>'
let g:ctrlp_max_height        = 20
let g:ctrlp_custom_ignore     = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee|\.class|\.pyc'
let g:ctrlp_prompt_mappings   = {
  \ 'PrtBS()':              ['<bs>', '<c-]>'],
  \ 'PrtDelete()':          ['<del>'],
  \ 'PrtDeleteWord()':      ['<c-w>'],
  \ 'PrtClear()':           ['<c-u>'],
  \ 'PrtSelectMove("j")':   ['<c-j>', '<down>'],
  \ 'PrtSelectMove("k")':   ['<c-k>', '<up>'],
  \ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
  \ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
  \ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
  \ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
  \ 'PrtHistory(-1)':       ['<c-n>'],
  \ 'PrtHistory(1)':        ['<c-p>'],
  \ 'AcceptSelection("e")': ['<c-i>', '<2-LeftMouse>'],
  \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
  \ 'AcceptSelection("t")': ['<cr>', '<c-t>'],
  \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
  \ 'ToggleFocus()':        ['<s-tab>'],
  \ 'ToggleRegex()':        ['<c-r>'],
  \ 'ToggleByFname()':      ['<c-d>'],
  \ 'ToggleType(1)':        ['<c-f>', '<c-up>', '<f12>'],
  \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
  \ 'PrtExpandDir()':       ['<tab>'],
  \ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
  \ 'PrtInsert()':          ['<c-\>'],
  \ 'PrtCurStart()':        ['<c-a>'],
  \ 'PrtCurEnd()':          ['<c-e>'],
  \ 'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
  \ 'PrtCurRight()':        ['<c-l>', '<right>'],
  \ 'PrtClearCache()':      ['<F5>'],
  \ 'PrtDeleteEnt()':       ['<F7>'],
  \ 'CreateNewFile()':      ['<c-y>'],
  \ 'MarkToOpen()':         ['<c-z>'],
  \ 'OpenMulti()':          ['<c-o>'],
  \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
  \ }

"  Vim grep
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git generated'
set grepprg=/bin/grep\ -nH

"  vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_key='<c-g>'
let g:multi_cursor_start_word_key='w<c-g>'
let g:multi_cursor_next_key='<c-g>'
let g:multi_cursor_prev_key='<c-p>'
let g:multi_cursor_skip_key='<c-x>'
let g:multi_cursor_quit_key='<Esc>'

"  surround.vim config
vmap Si S(i<esc>f)

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme                      ='wombat'

"  Git gutter (Git diff)
let g:gitgutter_enabled = 1
nnoremap <silent> <leader>d :GitGutterToggle<cr>

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" vim-scala
let g:scala_scaladoc_indent = 1

" neco-ghc
let g:necoghc_enable_detailed_browse = 1
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setl omnifunc=necoghc#omnifunc

" YouCompleteMe
"let g:ycm_path_to_python_interpreter = '/usr/local/bin/python'
let g:ycm_complete_in_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_auto_trigger = 1
let g:ycm_min_num_identifier_candidate_chars = 0
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_semantic_triggers = {'haskell' : ['.']}
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = ''
let g:ycm_semantic_triggers = {'haskell' : ['.']}
let g:ycm_filetype_specific_completion_to_disable = {
    \ 'gitcommit': 1
    \}
let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'pandoc' : 1,
    \ 'infolog' : 1,
    \}




