local M = {}
M[#M + 1] = {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
                winopts = {
                        height = 0.37,
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
                files = { previewer = false },
                oldfiles = { previewer = false },
        },
        event = "VeryLazy",
}

--PLUG: oil
M[#M + 1] = {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = {
                default_file_explorer = false,
                delete_to_trash = true,
                skip_confirm_for_simple_edits = true,
                watch_for_changes = true,
                use_default_keymaps = false,
                keymaps = {
                        ["g?"] = { "actions.show_help", mode = "n" },
                        ["L"] = "actions.select",
                        ["H"] = { "actions.parent", mode = "n" },
                        ["q"] = { "actions.close", mode = "n" },
                        [","] = { "actions.open_cwd", mode = "n" },
                        ["`"] = { "actions.cd", mode = "n" },
                        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                        ["="] = "actions.open_external",
                        ["gs"] = { "actions.change_sort", mode = "n" },
                        ["g."] = { "actions.toggle_hidden", mode = "n" },
                        ["<C-p>"] = { "actions.preview", mode = "n" },
                        ["<C-R>"] = { "actions.refresh", mode = "n" },
                        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
                        ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
                        ["<C-t>"] = { "actions.select", opts = { tab = true } },
                },
                view_options = {
                        show_hidden = true,
                },
                float = {
                        padding = 0,
                        border = "single",
                        get_win_title = nil,
                        preview_split = "auto",
                        override = function(conf)
                                local ui = vim.api.nvim_list_uis()[1]
                                local sidebar_width = math.floor(ui.width * 0.17)

                                -- send to nvim_open_win.
                                conf = {
                                        relative = "editor",
                                        width = sidebar_width,
                                        height = ui.height,
                                        row = 0,
                                        col = ui.width - sidebar_width,
                                        style = "minimal",
                                        border = "single",
                                }

                                return conf
                        end,
                },
        },
        event = "VeryLazy",
}

M[#M + 1] = {
        "NeogitOrg/neogit",
        dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope.nvim",
        },
        config = true,
}
M[#M + 1] = {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        dependencies = {
                "nvim-telescope/telescope.nvim",
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
        },
        opts = {
                cn = {
                        enabled = true,
                },
                injector = {
                        ["python3"] = {
                                before = true,
                        },
                        ["cpp"] = {
                                before = { "#include <bits/stdc++.h>" },
                        },
                },
                picker = { provider = "telescope" },
        },
}

return M
