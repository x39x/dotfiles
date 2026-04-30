syn on
filetype plugin indent on
set nu si hls is ic scs
no H ^
no L $
ino jk <ESC>

colo retrobox "dark: retrobox evening  koehler, light: delek morning
set bg=dark
set et ts=8 sw=4
set nowrap ls=2 ru
set list lcs=tab:<·,trail:· fcs=eob:\ 
set ttimeout ttyfast ttimeoutlen=1 "esc delay
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

no J }
no K {
no { J
no } K
let mapleader = "\<Space>"
nno <leader>, :let @/ = '<c-r><c-w>' \| set hls<CR>
nno <backspace> :nohl<CR>
