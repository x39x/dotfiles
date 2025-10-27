--NOTE: mode
-- insert_mode       = "i",
-- normal_mode       = "n",
-- term_mode         = "t",
-- visual_mode       = "v",
-- visual_block_mode = "x",
-- command_mode      = "c",
-- operator_mode     = "o",
-- select_mode       = "s"

local keymap = vim.keymap.set
local key_opts = { noremap = true, silent = true }

keymap("", "<Space>", "<Nop>", key_opts)
keymap("i", "jk", "<esc>", key_opts)
keymap({ "n" }, "<leader>m", ":", { noremap = true })
keymap({ "n", "o" }, "L", "$", key_opts)
keymap({ "x" }, "L", "$h", key_opts)
keymap("", "H", "^", key_opts)
keymap("", "J", "2j", key_opts)
keymap("", "K", "2k", key_opts)
keymap("", "|", "J", key_opts)
keymap("", "q", "%", key_opts)
keymap("", "%", "q", key_opts)

--buffers
keymap({ "n" }, "<leader>l", "<cmd>bn<CR>", key_opts)
keymap({ "n" }, "<leader>h", "<cmd>bp<CR>", key_opts)
keymap({ "n" }, "<leader>w", "<cmd>bd<CR>", key_opts)
-- Resize pane
keymap({ "n", "x" }, "<M-Up>", "<cmd>resize +2<CR>", key_opts)
keymap({ "n", "x" }, "<M-Down>", "<cmd>resize -2<CR>", key_opts)
keymap({ "n", "x" }, "<M-Left>", "<cmd>vertical resize -2<CR>", key_opts)
keymap({ "n", "x" }, "<M-Right>", "<cmd>vertical resize +2<CR>", key_opts)
-- Move  line / code block
keymap({ "n", "i" }, "<M-->", "<cmd>m .+1<CR>==", key_opts)
keymap({ "n", "i" }, "<M-=>", "<cmd>m .-2<CR>==", key_opts)
keymap({ "x" }, "<M-->", ":m '>+1<CR>gv=gv", key_opts)
keymap({ "x" }, "<M-=>", ":m '<-2<CR>gv=gv", key_opts)
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

keymap("n", "<leader>,", function()
        --":let @/ = expand('<cword>') | set hlsearch<cr>"
        vim.fn.setreg("/", vim.fn.expand("<cword>"))
        vim.opt.hlsearch = true
end, key_opts)
keymap("n", "<BackSpace>", "<cmd>nohl<CR>", key_opts)

-- run code
local runner = require("utils.runner")
keymap("n", "<leader>rt", runner.run_in_tmux_window, { desc = "Send cmd to tmux window", noremap = true })
keymap("n", "<leader>-", runner.run_in_tmux_pane, { desc = "Send cmd to tmux pane", noremap = true, silent = true })
keymap("n", "<leader>ra", runner.add_and_run, { desc = "add cmd and run", noremap = true, silent = true })
keymap("n", "<leader>rs", runner.select_and_run, { desc = "select cmd and run", noremap = true, silent = true })
keymap("n", "<leader>rc", runner.clear_project_cmds, { desc = "clear current cmd", noremap = true, silent = true })
keymap("n", "<leader>rA", runner.clear_all_cmds, { desc = "clear all cmd", noremap = true, silent = true })

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
