syn on
filetype plugin indent on
set nu si hls is ic scs
set ttimeout ttyfast ttimeoutlen=1 "esc delay
set et ts=8 sw=4 ls=2 ru
set list lcs=tab:»··,trail:· fcs=eob:\ 
ino jk <ESC>
no H ^
no L g_
no J }
no K {
no { J
no } K
let mapleader = "\<Space>"
nno <leader>, :let @/ = '<c-r><c-w>' \| set hls<CR>
nno <C-l> :nohl<CR>
"dark: retrobox koehler, light: delek
set bg=dark
colo retrobox 
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
