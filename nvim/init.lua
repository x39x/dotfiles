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

o.exrc = true -- exrc config
vim.o.qftf = "v:lua.require'utils.qftf'" --  quickfix textfunc

require("base")
require("lspconfig")
require("dapconfig")
require("ui")
require("keymap")
require("autocmd")

-- Disable LSP semantic token highlighting
-- NOTE: https://www.reddit.com/r/neovim/comments/1jilkjs/comment/mjlpumh/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
end
