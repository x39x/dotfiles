vim.pack.add({
        "https://github.com/ibhagwan/fzf-lua",
})

local nopreview = {
        winopts = {
                preview = {
                        border = "none",
                        horizontal = "right:0%",
                },
        },
}

require("fzf-lua").setup({
        builtin = { winopts = { width = 1, height = 0.39 } },
        colorscheme = { winopts = { width = 1, height = 0.39 } },
        winopts = {
                height = 0.39,
                width = 1,
                row = 1,
                col = 0,
                backdrop = 100,
                border = { "─", "─", "─", " ", " ", " ", " ", " " },
                preview = {
                        border = { "─", "─", "─", " ", " ", " ", " ", " " },
                        horizontal = "right:50%",
                        title = false,
                        scrollbar = false,
                        winopts = {
                                number = false,
                        },
                },
        },
        grep = {
                rg_glob = true,
                rg_glob_fn = function(query, _)
                        local regex, flags = query:match("^(.-)%s%-%-(.*)$")
                        return (regex or query), flags
                end,
                winopts = {
                        title = "",
                },
        },
        files = { previewer = false },
        oldfiles = { previewer = false },
        tmux_buffers = { previewer = false },
        zoxide = nopreview,
})

local keymap = vim.keymap.set
local key_opts = { noremap = true, silent = true }
keymap("n", "<leader>ff", require("fzf-lua").files, key_opts)
keymap("n", "<leader>fh", require("fzf-lua").oldfiles, key_opts)
keymap("n", "<leader>fp", require("fzf-lua").zoxide, key_opts)
keymap("n", "<Leader>fr", require("fzf-lua").builtin, key_opts)
keymap("n", "<leader>fl", require("fzf-lua").live_grep, key_opts)
keymap("n", "<Leader>fs", require("fzf-lua").colorschemes, key_opts)
keymap("n", "<Leader>fm", require("fzf-lua").marks, key_opts)

require("fzf-lua").register_ui_select({

        winopts = {
                height = 0.39,
                width = 0.5,
                row = 0.4,
                col = 0.5,
                backdrop = 100,
                border = { "─", "─", "─", " ", "─", "─", "─", " " },
        },
})
