-- Enables the experimental Lua module loader
vim.loader.enable()

-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.editorconfig = false

-- leader key
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = "\\"

-- rust fmt
vim.g.rust_recommended_style = 0

vim.filetype.add({
	pattern = {
		[".*profile"] = "bash",
	},
	extension = {
		typ = "typst",
		mdx = "markdown",
	},
})

--NOTE: options
local o = vim.o

o.backup = false
o.swapfile = false
o.autochdir = false
o.splitright = true
o.splitbelow = true
o.smoothscroll = true
o.ignorecase = true
o.smartcase = true
o.scrolloff = 5
o.sidescrolloff = 5
o.exrc = true -- exrc config
o.quickfixtextfunc = "v:lua.require'utils.qftf'" --  quickfix textfunc
o.virtualedit = "block"
--
o.wrap = false
o.linebreak = true -- wrap don't break words
o.showtabline = 2 -- tabline,0:no
o.laststatus = 3 --  global statusline
o.showmode = false
o.signcolumn = "yes" -- sign column
o.number = true
o.numberwidth = 3
o.list = true
o.listchars = "tab:  ,extends:❯,precedes:❮,trail:·" -- "eol:↴" │»·
o.fillchars = "eob: ,msgsep:─,fold: " -- eob: hide "~"
o.cursorline = true
o.cursorlineopt = "number"
o.conceallevel = 0 -- Hide * ..., 0: no ,1: leave space, 2:hide space
--
o.smartindent = true
o.copyindent = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 8
--
o.foldlevel = 99
o.foldlevelstart = 99
o.foldcolumn = "0" -- don't show fold in line number
o.foldmethod = "manual"
o.foldtext = "v:lua.require'utils.foldtext'()"
o.pumborder = "solid"
-- o.pumheight = 15
-- o.pummaxwidth = 30
o.wildignorecase = true
--
o.autocomplete = false
o.completeopt = "menu,menuone,noinsert,popup"
o.complete = ".,b,w,i,t,o"
--o.previewpopup = "height:10,width:60,border:bold"

require("base")
require("lspconfig")
require("dapconfig")
require("ui")
require("keymap")
require("autocmd")
