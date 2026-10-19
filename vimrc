syn on
ino jk <ESC>
set nu si hls is ic scs
filetype plugin indent on
set ttimeout ttyfast ttimeoutlen=1 "esc delay
set et ts=8 sw=4 ls=2 ru
set list lcs=tab:»··,trail:· fcs=eob:\ 
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let mapleader = "\<Space>"
nno <leader>, :let @/ = '<c-r><c-w>' \| set hls<CR>
nno <C-l> :nohl<CR>
no H ^
no L g_
no J }
no K {
no { J
no } K
"dark: retrobox evening  koehler, light: delek morning
set bg=dark
colo retrobox 
