" Load plug
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter', {'branch': 'main'}
"Plug 'derekwyatt/vim-scala', {'for': 'scala'}
Plug 'easymotion/vim-easymotion'
"Plug 'fatih/vim-go', {'for': 'go', 'tag':'*'}
Plug 'godlygeek/tabular'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/vim-cursorword'
Plug 'liuchengxu/eleline.vim'
Plug 'jonathanfilip/vim-lucius'
"Plug 'kien/rainbow_parentheses.vim'
Plug 'matze/vim-move'
Plug 'navicore/vissort.vim'
"Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
Plug 'roman/golden-ratio'
Plug 'scrooloose/nerdcommenter'
"Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/vim-auto-popmenu'
Plug 'skywind3000/vim-dict'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'valloric/ListToggle'
Plug 'vim-scripts/LargeFile'
"Plug 'w0rp/ale', {'tag': '*'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
call plug#end()

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
" Write this in your vimrc file
let g:ale_lint_on_text_changed = 'never'
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_fix_on_save = 1
"nmap <silent> <F9> <Plug>(ale_previous_wrap)
"nmap <silent> <F10> <Plug>(ale_next_wrap)
"nmap <silent> <F8> :lop<cr>
"nmap <silent> <F9> :lcl<cr>


" rainbow
let g:rainbow_active = 1

" rainbow_parentheses.vim
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

" smartim
let g:smartim_default = 'com.apple.keylayout.ABC'

" easymotion

" Disable default mappings
let g:EasyMotion_do_mapping = 0 

" <Leader>f{char} to move to {char}
nmap <silent> <Leader>f <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
"nmap <silent> <Leader>s <Plug>(easymotion-overwin-f2)
" Move to word
"nmap <silent> <Leader>w <Plug>(easymotion-overwin-w)

"function! s:incsearch_config(...) abort
  "return incsearch#util#deepextend(deepcopy({
  "\   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  "\   'keymap': {
  "\     "\<CR>": '<Over>(easymotion)'
  "\   },
  "\   'is_expr': 0
  "\ }), get(a:, 1, {}))
"endfunction

"noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
"noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
"noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))

"function! s:config_easyfuzzymotion(...) abort
  "return extend(copy({
  "\   'converters': [incsearch#config#fuzzyword#converter()],
  "\   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  "\   'keymap': {"\<CR>": '<Over>(easymotion)'},
  "\   'is_expr': 0,
  "\   'is_stay': 1
  "\ }), get(a:, 1, {}))
"endfunction

"noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())


"  YankStack
"call yankstack#setup()
"let g:yankstack_map_keys = 0
"let g:yankstack_yank_keys = ['y', 'd']
"nmap <silent> <leader>p <Plug>yankstack_substitute_older_paste
"nmay <silent> <leader>P <Plug>yankstack_substitute_newer_paste

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

" LargeFile
let g:LargeFile = 2

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
  \ 'AcceptSelection("h")': ['<c-x>', '<c-b>'],
  \ 'AcceptSelection("t")': ['<cr>', '<c-t>'],
  \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
  \ 'ToggleFocus()':        ['<s-tab>'],
  \ 'ToggleRegex()':        ['<c-r>'],
  \ 'ToggleByFname()':      ['<c-d>'],
  \ 'ToggleType(1)':        ['<c-f>'],
  \ 'ToggleType(-1)':       ['<f12>'],
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

" leaderf
let g:Lf_ShortcutF = '<F11>'
"nmap <silent> <F11> :<C-U>LeaderfFile<CR>
"nmap <silent> <F12> :LeaderfMru<CR>
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git', '.idea', '.iml']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 1
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'airline'
let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}
let g:Lf_WildIgnore = {
  \ 'dir': ['.svn','.git','.hg', '.idea', '.vscode'],
  \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]', '*.class', '*.DS_Store', '*.jar']
  \}
let g:Lf_CommandMap = {
  \ '<CR>': ['<C-B>'],
  \ '<C-T>': ['<CR>']
  \}

" fzf.vim
let g:fzf_action = {
  \ 'enter': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
nmap <silent> <F11> :Files<cr>
nmap <silent> <F12> :History<cr>

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

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
"nnoremap <silent> <leader>d :GitGutterToggle<cr>

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" vim-scala
let g:scala_scaladoc_indent = 1

" neco-ghc
let g:necoghc_enable_detailed_browse = 1
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
"autocmd FileType haskell setl omnifunc=necoghc#omnifunc

" YouCompleteMe
"let g:ycm_path_to_python_interpreter = '/usr/local/bin/python3'
let g:ycm_auto_trigger = 1
let g:ycm_complete_in_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_collect_identifiers_from_comments_and_string = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 0
"set completeopt=menu,menuone,noselect
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_disable_for_files_larger_than_kb = 512
let g:ycm_filetype_specific_completion_to_disable = {
  \ 'gitcommit': 1
  \ }
let g:ycm_filetype_blacklist = {
  \ 'tagbar'  : 1,
  \ 'pandoc'  : 1,
  \ 'infolog' : 1,
  \ }
let g:ycm_semantic_triggers =  {
  \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
  \ 'cs,lua,javascript': ['re!\w{2}'],
  \ }

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

" asyncrun
" asyncrun open on quickfix window at hight 6
let g:asyncrun_open = 6
let g:asyncrun_bell = 1
"nnoremap <silent> <F10> :call asyncrun#quickfix_toggle(6)<cr>

" ListToggle
let g:lt_location_list_toggle_map = '<F9>'
let g:lt_quickfix_list_toggle_map = '<F10>'

" vim-move
let g:move_map_keys = 0
let g:move_auto_indent = 1
let g:move_past_end_of_line = 1

" support combination keys, move selected block or line with alt + j,k,h,l
if has("mac") || has("macunix")
  vmap ∆ <Plug>MoveBlockDown
  vmap ˚ <Plug>MoveBlockUp
  vmap ˙ <Plug>MoveBlockLeft
  vmap ¬ <Plug>MoveBlockRight
  nmap ∆ <Plug>MoveLineDown
  nmap ˚ <Plug>MoveLineUp
  nmap ˙ <Plug>MoveCharLeft
  nmap ¬ <Plug>MoveCharRight
endif
