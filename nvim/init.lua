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

-- filetype
vim.filetype.add({
	pattern = {
		[".*profile"] = "bash",
	},
	extension = {
		typ = "typst",
		mdx = "markdown",
	},
})

local keymap = vim.keymap.set
local o = vim.o
local command = vim.api.nvim_create_user_command

------------------------------------------------------------------------------
-- options
------------------------------------------------------------------------------

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
o.quickfixtextfunc = "v:lua.matsu_qftf" --  quickfix textfunc
o.virtualedit = "block"
--
o.showtabline = 2 -- tabline,0:no
o.laststatus = 3 --  global statusline
o.showmode = false
o.signcolumn = "yes" -- sign column
o.number = true
o.numberwidth = 3
o.list = true
o.listchars = "tab:··,extends:,precedes:,trail:·,nbsp:󰌎"
o.fillchars = "eob: ,msgsep:─,fold: ,diff:╱" -- eob: hide "~"
o.cursorline = false
-- o.cursorlineopt = "number"
o.conceallevel = 0 -- Hide * ..., 0: no ,1: leave space, 2:hide space

o.wrap = false
o.linebreak = true -- wrap don't break words
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
o.foldtext = "v:lua.matsu_foldtext()"
--
o.pumborder = "solid"
o.autocomplete = false
o.completeopt = "menu,menuone,noinsert,popup"
-- o.completeopt = "menu,popup"
o.complete = "o,Fv:lua.snippet_complete,.,w"
o.completefunc = "v:lua.snippet_complete"
-- o.previewpopup = "height:10,width:60,border:bold" -- doesn't work

------------------------------------------------------------------------------
-- keymap
------------------------------------------------------------------------------
-- see :h map-table :h default-mappings

-- <C-e>:  dismiss the completion menu
keymap("i", "<C-l>", function()
	return tonumber(vim.fn.pumvisible()) ~= 0 and "<C-y>" or "<C-l>"
end, { expr = true })

keymap("", "<Space>", "<Nop>")
keymap("i", "jk", "<esc>")

-- better  ^ $
keymap("", "L", "g_")
keymap("", "H", "^")

-- swap some key
keymap({ "n", "v" }, "q", "%")
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("matsu.keymapq", { clear = true }),
	callback = function()
		keymap("n", "%", "q")
	end,
})
keymap("", "{", "J")
keymap("", "}", "K")
keymap("", "J", "}")
keymap("", "K", "{")
keymap({ "n", "x" }, "<leader>[", "<ScrollWheelUp>")
keymap({ "n", "x" }, "<leader>]", "<ScrollWheelDown>")

-- useless 's/S'
keymap({ "n", "v" }, "s", '"_d')
keymap("o", "s", "d") -- ss -> _dd
keymap("", "S", '"_D')

--buffers
keymap({ "n" }, "<leader>l", vim.cmd.bnext)
keymap({ "n" }, "<leader>h", vim.cmd.bprevious)

-- Move  line / code block
keymap({ "n", "i" }, "<M-->", "<cmd>m .+1<CR>")
keymap({ "n", "i" }, "<M-=>", "<cmd>m .-2<CR>")
keymap("x", "<M-->", ":m '>+1<CR>gv=gv")
keymap("x", "<M-=>", ":m '<-2<CR>gv=gv")
keymap("x", "<", "<gv")
keymap("x", ">", ">gv")

-- cmdline mode
keymap("c", "<C-p>", "<Up>")
keymap("c", "<C-n>", "<Down>")
keymap("c", "<C-f>", "<Right>")
keymap("c", "<C-b>", "<Left>")
keymap("c", "<C-a>", "<Home>")

-- save
keymap({ "n", "v" }, "<M-s>", vim.cmd.write)
keymap("i", "<M-s>", function()
	vim.cmd.stopinsert()
	vim.cmd.write()
end)

-- highlight current word
keymap("n", "<leader>,", function()
	--":let @/ = expand('<cword>') | set hlsearch<cr>"
	vim.fn.setreg("/", vim.fn.expand("<cword>"))
	o.hlsearch = true
end)

--- command

command("Bufpwd", function(args)
	local file = vim.api.nvim_buf_get_name(0)
	local message = "Bufpwd: " .. file
	if args.bang then
		local dir = vim.fs.dirname(file)
		message = "cd: " .. dir
		vim.api.nvim_set_current_dir(dir)
	end

	vim.notify(message, vim.log.levels.WARN)
end, { bang = true })

command("Fjson", "%!python3 -m json.tool", {})

------------------------------------------------------------------------------
-- plugin/lsp/colorscheme
------------------------------------------------------------------------------

require("plugin")
require("lspconfig")

ok, _ = pcall(vim.cmd.so, vim.fs.normalize("$HOME/.local/state/matsu/colo.vim"))

if not ok then
	vim.cmd.colo("retrobox")
end
