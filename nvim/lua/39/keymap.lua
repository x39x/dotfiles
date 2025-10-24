local keymap = vim.keymap.set
local cmd = vim.api.nvim_create_user_command
local key_opts = { noremap = true, silent = true }

--NOTE: mode
-- insert_mode       = "i",
-- normal_mode       = "n",
-- term_mode         = "t",
-- visual_mode       = "v",
-- visual_block_mode = "x",
-- command_mode      = "c",
-- operator_mode     = "o",
-- select_mode       = "s"

keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
keymap("i", "jk", "<esc>", key_opts)
keymap({ "n", "o" }, "L", "$", key_opts)
keymap({ "x" }, "L", "$h", key_opts)
keymap("", "H", "^", key_opts)
keymap("", "J", "2j", key_opts)
keymap("", "K", "2k", key_opts)
keymap("", "|", "J", key_opts)
keymap("", "q", "%", key_opts)
keymap("", "%", "q", key_opts)

--buffers
keymap({ "n" }, "<leader>l", "<cmd>bn<cr>", key_opts)
keymap({ "n" }, "<leader>h", "<cmd>bp<cr>", key_opts)
keymap({ "n" }, "<leader>w", "<cmd>bd<cr>", key_opts)
-- Resize pane
keymap({ "n", "x" }, "<M-Up>", "<cmd>resize +2<CR>", key_opts)
keymap({ "n", "x" }, "<M-Down>", "<cmd>resize -2<CR>", key_opts)
keymap({ "n", "x" }, "<M-Left>", "<cmd>vertical resize -2<CR>", key_opts)
keymap({ "n", "x" }, "<M-Right>", "<cmd>vertical resize +2<CR>", key_opts)
-- Move  line / code block
keymap({ "n", "i" }, "<M-->", "<cmd>m .+1<CR>==", key_opts)
keymap({ "n", "i" }, "<M-=>", "<cmd>m .-2<CR>==", key_opts)
keymap({ "x" }, "<M-->", ":m '>+1<cr>gv=gv", key_opts)
keymap({ "x" }, "<M-=>", ":m '<-2<cr>gv=gv", key_opts)
keymap({ "x" }, "<", "<gv", key_opts)
keymap({ "x" }, ">", ">gv", key_opts)

keymap("t", "<C-\\>", "<C-\\><C-N>", key_opts)
keymap("c", "<C-p>", "<Up>")
keymap("c", "<C-n>", "<Down>")
keymap("c", "<C-f>", "<Right>")
keymap("c", "<C-b>", "<Left>")
keymap("c", "<C-a>", "<Home>")

keymap({ "i", "n", "x" }, "<M-s>", function()
        vim.cmd("stopinsert")
        vim.cmd("w")
end, key_opts)
keymap("n", "<leader>s", function()
        local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_lines(0, row, row, true, { "" })
end, key_opts)

keymap("n", "<BackSpace>", "<cmd>nohl<CR>", key_opts)
keymap("n", "<leader>,", function()
        --":let @/ = expand('<cword>') | set hlsearch<cr>"
        vim.fn.setreg("/", vim.fn.expand("<cword>"))
        vim.opt.hlsearch = true
end, key_opts)

keymap("n", "<leader>rt", require("utils.tmux_run").window, { desc = "Send cmd to tmux window" })
keymap("n", "<leader>-", require("utils.tmux_run").pane, { desc = "Send cmd to tmux pane" })

--NOTE: user command
cmd("FormatJSON", "%!python3 -m json.tool", {})
cmd("Bpwd", function()
        print(vim.fn.expand("%:p"))
end, {})

cmd("CBpwd", function()
        local dir = vim.fn.expand("%:p:h")
        vim.api.nvim_set_current_dir(dir)
        print("change dir to " .. dir)
end, {})
