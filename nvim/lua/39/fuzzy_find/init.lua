vim.pack.add({
        "https://github.com/ibhagwan/fzf-lua",
})

local nopreview = function(opts)
        opts = opts or {}
        local config = {
                winopts = {
                        preview = {
                                border = "none",
                                horizontal = "right:0%",
                        },
                },
        }
        return vim.tbl_deep_extend("force", config, opts)
end

local ivy = function(opts)
        opts = opts or {}
        local winopts = {
                title_flags = false,
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
        }
        return vim.tbl_deep_extend("force", winopts, opts)
end
local dropdown = function(opts)
        opts = opts or {}
        local winopts = {
                title_flags = false,
                height = 0.39,
                width = 0.5,
                row = 0.4,
                col = 0.5,
                backdrop = 100,
                border = { "─", "─", "─", " ", "─", "─", "─", " " },
        }
        return vim.tbl_deep_extend("force", winopts, opts)
end

require("fzf-lua").setup({
        winopts = ivy(),
        zoxide = nopreview(),
        files = {
                previewer = false,
                cwd_prompt = false,
        },
        oldfiles = { previewer = false },
        tmux_buffers = { previewer = false },
        builtin = { winopts = { width = 1, height = 0.39 } },
        colorschemes = {
                live_preview = false,
                winopts = dropdown(),
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
})

local keymap = vim.keymap.set
local key_opts = { noremap = true, silent = true }
keymap("n", "<leader>ff", FzfLua.files, key_opts)
keymap("n", "<leader>fh", FzfLua.oldfiles, key_opts)
keymap("n", "<leader>fp", FzfLua.zoxide, key_opts)
keymap("n", "<Leader>fr", FzfLua.builtin, key_opts)
keymap("n", "<leader>fl", FzfLua.live_grep, key_opts)
keymap("n", "<Leader>fs", FzfLua.colorschemes, key_opts)
keymap("n", "<Leader>fm", FzfLua.marks, key_opts)

require("fzf-lua").register_ui_select({
        winopts = dropdown(),
})
