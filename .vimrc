" .vimrc: entry point of the Vim setup. It only lists the settings files, in load order.
" For Vim >= 8.2.1401. Neovim has its own setup in ~/.config/nvim and never reads this file.
"
"   options.vim    `set` options, swap and backup directories
"   mappings.vim   <Leader>, key mappings and user commands that need no plugin
"   plugins.vim    vim-plug plugin list, then the settings and mappings of each plugin
"   autocmds.vim   autocommands: general ones, then per filetype (has to come after plugins.vim)
"
" GUI-only settings are in ~/.vim/gvimrc, which Vim reads by itself when the GUI starts.

source ~/.vim/settings/options.vim
source ~/.vim/settings/mappings.vim
source ~/.vim/settings/plugins.vim
source ~/.vim/settings/autocmds.vim
