--NOTE: options
local o = vim.o

-- NVIMTREE: disable netrw at the very start of your config
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- rust fmt
vim.g.rust_recommended_style = 0

vim.filetype.add({
        pattern = {
                [".*.typ"] = "typst",
                [".*.mdx"] = "markdown",
                [".*profile"] = "bash",
        },
})

o.backup = false
o.swapfile = false
o.autochdir = false
o.splitright = true
o.splitbelow = true
o.number = true
o.numberwidth = 3
o.smartindent = true
o.copyindent = true -- 自动缩进时，复制已有的行的缩进结构
o.ignorecase = true
o.smartcase = true
--
o.wrap = false --no wrap
o.linebreak = true -- wrap don't break words
o.scrolloff = 5
o.showtabline = 2 -- tabline,0:no
o.laststatus = 3 --  global statusline
o.signcolumn = "yes" -- sign colume
o.list = true
o.listchars = "tab:  ,extends:⟩,precedes:⟨,trail:·" --("eol:↴,tab:»·,trail:·")
o.fillchars = "eob: " -- hide  "~"
--set fold
o.foldenable = true
o.foldcolumn = "0" --show fold in line number
o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
o.foldlevelstart = 99
--
o.expandtab = true -- tab->spaces
o.shiftwidth = 4
o.tabstop = 8
o.cursorline = false
o.conceallevel = 0 -- Hide * ..., 0: no ,1: leave space, 2:hide space

require("39.basic")
require("39.fuzzy_find")
require("39.lspconfig")
require("39.dapconfig")
require("39.ui")
require("39.extras")
require("39.keymap")
require("39.autocmd")
