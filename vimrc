syn on
filetype plugin indent on

set nu
set si
set hls is ic scs
set et sts=-1 sw=4
set list lcs=tab:»··,trail:·
set fcs=eob:\ 
set bo=all " belloff
set bg=dark

colo retrobox "koehler delek
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let mapleader = "\<Space>"

no H ^
no L g_
no J j
no <bar> J
nn <C-l> :nohl<CR>
nn <leader>, :let @/ = '<c-r><c-w>' \| set hls<CR>
ino jk <ESC>
