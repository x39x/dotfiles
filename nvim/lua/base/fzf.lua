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
                        border = function(_, m)
                                if m.type == "fzf" then
                                        return "none"
                                else
                                        return { "─", "─", "─", " ", " ", " ", " ", " " }
                                end
                        end,
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
        actions = {
                files = {
                        true,
                },
        },
        winopts = ivy(),
        files = {
                previewer = false,
                cwd_prompt = false,
        },

        -- picker option
        zoxide = nopreview(),
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
local keymap_opts = require("utils.keymap_opts")
keymap("n", "<leader>ff", FzfLua.files, keymap_opts({ desc = "Fzflua files" }))
keymap("n", "<leader>fh", FzfLua.oldfiles, keymap_opts({ desc = "Fzflua oldfiles" }))
keymap("n", "<leader>fp", FzfLua.zoxide, keymap_opts({ desc = "Fzflua zoxide" }))
keymap("n", "<Leader>fr", FzfLua.builtin, keymap_opts({ desc = "Fzflua builtin" }))
keymap("n", "<leader>fl", FzfLua.live_grep, keymap_opts({ desc = "Fzflua live_grep" }))
keymap("n", "<Leader>fs", FzfLua.colorschemes, keymap_opts({ desc = "Fzflua colorschemes" }))
keymap("n", "<Leader>fm", FzfLua.marks, keymap_opts({ desc = "Fzflua marks" }))
keymap("n", "<Leader>fe", FzfLua.resume, keymap_opts({ desc = "Fzflua resume" }))

require("fzf-lua").register_ui_select({
        winopts = dropdown(),
})
