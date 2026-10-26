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
o.cursorline = true
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
-- o.completeopt = "menu,menuone,noinsert,popup"
o.completeopt = "menu,popup"
o.complete = ".,w,b,o,Fv:lua.snippet_complete"
o.completefunc = "v:lua.snippet_complete"
-- o.previewpopup = "height:10,width:60,border:bold" -- doesn't work

-- see :h map-table :h default-mappings
local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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
autocmd("VimEnter", {
	group = augroup("matsu.keymap.percent_sign", { clear = true }),
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

-- NOTE: autocmd/user_comman

local user_command = vim.api.nvim_create_user_command

user_command("Bufpwd", function()
	vim.notify("Bufpwd: " .. vim.fn.expand("%:p"))
end, {})

user_command("Bufcpwd", function()
	local dir = vim.fn.expand("%:p:h")
	vim.api.nvim_set_current_dir(dir)
	vim.notify("Bufcpwd: " .. dir)
end, {})

user_command("Fjson", "%!python3 -m json.tool", {})

autocmd("FileType", {
	pattern = "*",
	group = augroup("matsu.formatoptions", { clear = true }),
	callback = function()
		-- tc: text/comment,qwn2j:format,mM] cjk
		-- ro: <enter>/oO auto comment leader
		-- see :h 'formatoptions'
		o.formatoptions = "tcr/qwn2jvlmM]"
	end,
})

autocmd("TextYankPost", {
	group = augroup("matsu.highlight.yank", { clear = true }),
	callback = function()
		if not vim.v.event.visual then
			vim.hl.on_yank({ higroup = "Visual", timeout = 139 })
			-- 0.13
			-- vim.hl.hl_op({ higroup = "Visual", timeout = 139 })
		end
	end,
})

-- 0.13
-- autocmd("TextPutPost", {
-- 	group = augroup("matsu.highlight.remove", { clear = true }),
-- 	callback = function()
-- 		vim.hl.hl_op({ higroup = "Visual", timeout = 139 })
-- 	end,
-- })
--
local switch_im
if vim.fn.has("linux") == 1 and vim.fn.executable("fcitx5-remote") == 1 then
	switch_im = { "fcitx5-remote", "-c" }
elseif vim.fn.has("macunix") == 1 and vim.fn.executable("iswitch") == 1 then
	switch_im = { "iswitch", "-i", "com.apple.keylayout.ABC" }
end
if switch_im then
	autocmd("InsertLeave", {
		group = augroup("matsu.imswitch", { clear = true }),
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
	group = augroup("matsu.markdown", { clear = true }),
})

autocmd("FileType", {
	pattern = { "c", "cpp", "go" },
	callback = function(args)
		vim.bo[args.buf].shiftwidth = 8
	end,
	group = augroup("matsu.indet", { clear = true }),
})

autocmd("FileType", {
	pattern = { "lua", "go", "c", "cpp", "rust" },
	callback = function(args)
		vim.bo[args.buf].expandtab = false
		if vim.tbl_contains({ "lua", "rust" }, args.match) then
			vim.bo[args.buf].tabstop = 4
		end
		local winid = vim.api.nvim_get_current_win()
		if not vim.api.nvim_win_is_valid(winid) then
			return
		end
		vim.wo[winid].listchars = "tab:··,extends:,precedes:,trail:·,nbsp:󰌎"
	end,
	group = augroup("matsu.tab", { clear = true }),
})

autocmd("FileType", {
	pattern = "qf",
	callback = function(args)
		local winid = vim.api.nvim_get_current_win()
		vim.wo[winid].listchars = "tab:··,extends:,precedes:,trail:·,nbsp:󰌎"
		vim.bo[args.buf].buflisted = false
		keymap("n", "J", "j<Cmd>cn<CR><C-w><C-P>", { buf = args.buf })
		keymap("n", "K", "k<Cmd>cp<CR><C-w><C-P>", { buf = args.buf })
	end,
	group = augroup("matsu.qfbufline", { clear = true }),
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
