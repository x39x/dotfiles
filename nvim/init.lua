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
o.showtabline = 2 -- tabline,0:no
o.laststatus = 3 --  global statusline
o.showmode = true
o.signcolumn = "yes" -- sign column
o.number = true
o.numberwidth = 3
o.list = true
o.listchars = "tab:··󰁔,extends:❯,precedes:❮,trail:·" -- "eol:↴" │»·
o.fillchars = "eob: ,msgsep:─,fold: ,diff:╱" -- eob: hide "~"
o.cursorline = true
o.cursorlineopt = "number"
o.conceallevel = 0 -- Hide * ..., 0: no ,1: leave space, 2:hide space
o.guicursor = ""
--
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
o.foldtext = "v:lua.require'utils.foldtext'()"
o.pumborder = "solid"
o.wildignorecase = true
--
o.autocomplete = false
-- o.completeopt = "menu,menuone,noinsert,popup"
o.completeopt = "popup"

o.complete = ".,w,b,i,t,o"
--o.previewpopup = "height:10,width:60,border:bold"

-- see :h map-table :h default-mappings
local keymap = vim.keymap.set
local keymap_opts = require("utils.keymap_opts")

-- local function pumvisible()
-- 	return tonumber(vim.fn.pumvisible()) ~= 0
-- end
-- keymap("i", "<C-l>", function()
-- 	return pumvisible() and "<C-y>" or "<C-l>"
-- end, keymap_opts({ expr = true }))

keymap("", "<Space>", "<Nop>", keymap_opts())
keymap("i", "jk", "<esc>", keymap_opts())

-- better  ^ $
keymap("", "L", "g_", keymap_opts())
keymap("", "H", "^", keymap_opts())

-- swap some key
keymap({ "n", "x" }, "q", "%", keymap_opts())
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		keymap("n", "%", "q", keymap_opts())
	end,
})
keymap({ "n", "x" }, "{", "J", keymap_opts())
keymap({ "n", "x" }, "}", "K", keymap_opts())
keymap({ "n", "x" }, "J", "}", keymap_opts())
keymap({ "n", "x" }, "K", "{", keymap_opts())
keymap({ "n", "x" }, "<leader>[", "<ScrollWheelUp>", keymap_opts())
keymap({ "n", "x" }, "<leader>]", "<ScrollWheelDown>", keymap_opts())

-- useless 's/S'
keymap({ "n", "v" }, "s", '"_d', keymap_opts())
keymap("o", "s", "d", keymap_opts()) -- ss -> _dd
keymap("", "S", '"_D', keymap_opts())

--buffers
keymap({ "n" }, "<leader>l", vim.cmd.bnext, keymap_opts())
keymap({ "n" }, "<leader>h", vim.cmd.bprevious, keymap_opts())

-- Resize pane
keymap({ "n", "x" }, "<M-Up>", "<cmd>resize +2<CR>", keymap_opts({ desc = "resize window" }))
keymap({ "n", "x" }, "<M-Down>", "<cmd>resize -2<CR>", keymap_opts({ desc = "resize window" }))
keymap({ "n", "x" }, "<M-Left>", "<cmd>vertical resize -2<CR>", keymap_opts({ desc = "resize window" }))
keymap({ "n", "x" }, "<M-Right>", "<cmd>vertical resize +2<CR>", keymap_opts({ desc = "resize window" }))

-- Move  line / code block
keymap({ "n", "i" }, "<M-->", "<cmd>m .+1<CR>==", keymap_opts({ desc = "move line down" }))
keymap({ "n", "i" }, "<M-=>", "<cmd>m .-2<CR>==", keymap_opts({ desc = "move line up" }))
keymap({ "x" }, "<M-->", ":m '>+1<CR>gv=gv", keymap_opts({ desc = "move line down" }))
keymap({ "x" }, "<M-=>", ":m '<-2<CR>gv=gv", keymap_opts({ desc = "move line up" }))
keymap({ "x" }, "<", "<gv", keymap_opts())
keymap({ "x" }, ">", ">gv", keymap_opts())

keymap("c", "<C-p>", "<Up>")
keymap("c", "<C-n>", "<Down>")
keymap("c", "<C-f>", "<Right>")
keymap("c", "<C-b>", "<Left>")
keymap("c", "<C-a>", "<Home>")

-- save
keymap({ "n", "x" }, "<M-s>", vim.cmd.write, keymap_opts({ desc = "save file" }))
keymap("i", "<M-s>", function()
	vim.cmd.stopinsert()
	vim.cmd.write()
end, keymap_opts({ desc = "save file" }))

-- highlight current word
keymap("n", "<leader>,", function()
	--":let @/ = expand('<cword>') | set hlsearch<cr>"
	vim.fn.setreg("/", vim.fn.expand("<cword>"))
	o.hlsearch = true
end, keymap_opts({ desc = "highlight cword" }))
-- keymap("n", "<BackSpace>", vim.cmd.nohl, keymap_opts({ desc = "nohl" }))

--NOTE: user command
local cmd = vim.api.nvim_create_user_command

cmd("FormatJSON", "%!python3 -m json.tool", {})

cmd("Bpwd", function()
	print(vim.fn.expand("%:p"))
end, {})

cmd("CBpwd", function()
	local dir = vim.fn.expand("%:p:h")
	vim.api.nvim_set_current_dir(dir)
	print("change dir to " .. dir)
end, {})

local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- tc: text/comment,qwn2j:format,mM] cjk
		-- ro: <enter>/oO auto comment leader
		-- see :h 'formatoptions'
		o.formatoptions = "tcr/qwn2jvlmM]"
	end,
	group = vim.api.nvim_create_augroup("formatoptions", { clear = true }),
	desc = "formatoptions",
})

autocmd("TextYankPost", {
	callback = function()
		vim.hl.hl_op({ higroup = "Visual", timeout = 139 })
	end,
	group = vim.api.nvim_create_augroup("highlight yank text", { clear = true }),
})

local switch_im
if vim.fn.has("linux") == 1 and vim.fn.executable("fcitx5-remote") == 1 then
	switch_im = { "fcitx5-remote", "-c" }
elseif vim.fn.has("macunix") == 1 and vim.fn.executable("iswitch") == 1 then
	switch_im = { "iswitch", "-i", "com.apple.keylayout.ABC" }
end
if switch_im then
	autocmd("InsertLeave", {
		group = vim.api.nvim_create_augroup("imswitch", { clear = true }),
		callback = function()
			vim.system(switch_im)
		end,
	})
end

autocmd("FileType", {
	pattern = { "markdown" },
	callback = function(args)
		local winid = vim.api.nvim_get_current_win()
		vim.bo[args.buf].textwidth = 120
		vim.wo[winid][0].wrap = true
		keymap({ "x", "n" }, "j", "gj", { silent = true, buf = args.buf })
		keymap({ "x", "n" }, "k", "gk", { silent = true, buf = args.buf })
		keymap("", "H", "g^", { silent = true, buf = args.buf })
		keymap("", "L", "g$", { silent = true, buf = args.buf })
	end,
	group = vim.api.nvim_create_augroup("markdown", { clear = true }),
})

autocmd("FileType", {
	pattern = { "c", "cpp", "go" },
	callback = function(args)
		vim.bo[args.buf].shiftwidth = 8
	end,
	group = vim.api.nvim_create_augroup("indet8", { clear = true }),
	desc = "indent 8",
})

autocmd("FileType", {
	pattern = { "lua", "go", "c", "cpp", "rust" },
	callback = function(args)
		vim.bo[args.buf].expandtab = false
		local winid = vim.api.nvim_get_current_win()
		vim.wo[winid].listchars = "tab:  ,extends:❯,precedes:❮,trail:·"
		local indet_4 = { "lua", "rust" }
		if vim.tbl_contains(indet_4, vim.bo[args.buf].filetype) then
			vim.bo[args.buf].tabstop = 4
		end
	end,
	group = vim.api.nvim_create_augroup("tab", { clear = true }),
	desc = "TAB",
})

autocmd("FileType", {
	pattern = "qf",
	callback = function(args)
		local winid = vim.api.nvim_get_current_win()
		vim.wo[winid].listchars = "tab:  ,extends:❯,precedes:❮,trail:·"
		vim.bo[args.buf].buflisted = false
		keymap("n", "J", "j<Cmd>cn<CR><C-w><C-P>", { buffer = args.buf, silent = true })
		keymap("n", "K", "k<Cmd>cp<CR><C-w><C-P>", { buffer = args.buf, silent = true })
	end,
	group = vim.api.nvim_create_augroup("qfbufline", { clear = true }),
	desc = "Do't show qf in bufline",
})

local function load_cache()
	local f = io.open(vim.fn.expand("$HOME/.local/state/user/dark_mode"), "r")
	if not f then
		return ""
	end
	local content = f:read("*l")
	f:close()
	return content:lower():gsub("%s+", "")
end

if load_cache() == "true" then
	-- vim.cmd.colorscheme("39dark")
	vim.cmd.colorscheme("monokai")
else
	vim.cmd.colorscheme("39light")
end

require("base")
require("lspconfig")
require("dapconfig")
