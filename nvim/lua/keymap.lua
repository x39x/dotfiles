--NOTE: mode
-- see :h map-table

local keymap = vim.keymap.set
local keymap_opts = require("utils.keymap_opts")

keymap("", "<Space>", "<Nop>", keymap_opts())
keymap("i", "jk", "<esc>", keymap_opts())

-- better  ^ $
keymap("", "L", "g_", keymap_opts())
keymap("", "H", "^", keymap_opts())

-- swap some key
keymap("", "q", "%", keymap_opts())
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		keymap("", "%", "q", keymap_opts())
	end,
})
-- keymap("", "J", "}", keymap_opts())
-- keymap("", "K", "{", keymap_opts())
keymap("", "{", "J", keymap_opts())
keymap("", "}", "K", keymap_opts())
keymap({ "n", "v" }, "K", "<ScrollWheelUp>", keymap_opts())
keymap({ "n", "v" }, "J", "<ScrollWheelDown>", keymap_opts())

-- useless 's/S'
keymap({ "n", "v" }, "s", '"_d', keymap_opts())
-- keymap("o", "s", "d", keymap_opts())
keymap("", "S", '"_D', keymap_opts())

--buffers
keymap({ "n" }, "<leader>l", "<cmd>bn<CR>", keymap_opts())
keymap({ "n" }, "<leader>h", "<cmd>bp<CR>", keymap_opts())
keymap({ "n" }, "<leader>w", MiniBufremove.delete, keymap_opts())

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

-- save file
keymap("", "<M-s>", function()
	vim.cmd("stopinsert")
	vim.cmd("w")
end, keymap_opts({ desc = "save file" }))

-- new line
keymap("n", "<leader>s", function()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_buf_set_lines(0, row, row, true, { "" })
end, keymap_opts({ desc = "add new line below" }))

-- highlight current word
keymap("n", "<leader>,", function()
	--":let @/ = expand('<cword>') | set hlsearch<cr>"
	vim.fn.setreg("/", vim.fn.expand("<cword>"))
	vim.o.hlsearch = true
end, keymap_opts({ desc = "highlight cword" }))
keymap("n", "<BackSpace>", "<cmd>nohl<CR>", keymap_opts({ desc = "nohl" }))

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
