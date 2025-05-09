local M = {
        "nvim-telescope/telescope.nvim",
}

M.dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
        },
}

M.config = function()
        local tools = require("utils.telescope_tools")
        local theme = require("utils.telescope_tools").picker_theme
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local trouble = require("trouble.sources.telescope")
        local map = function(maps)
                maps = maps or {}
                local mappings = {
                        i = {
                                ["<c-t>"] = trouble.open,
                        },
                        n = {
                                ["<c-t>"] = trouble.open,
                        },
                }
                for mode, keys in pairs(maps) do
                        for key, value in pairs(keys) do
                                mappings[mode][key] = value
                        end
                end
                return mappings
        end
        telescope.setup({
                defaults = {
                        prompt_prefix = " ",
                        selection_caret = " ",
                        path_display = { "truncate" },
                        selection_strategy = "reset",
                        sorting_strategy = "ascending",
                        layout_strategy = "horizontal",

                        layout_config = {
                                horizontal = {
                                        prompt_position = "top",
                                        preview_width = 0.55,
                                        results_width = 0.8,
                                },
                                vertical = {
                                        mirror = false,
                                },
                                width = 0.87,
                                height = 0.80,
                                preview_cutoff = 120,
                        },
                        mappings = {
                                i = {
                                        ["<C-c>"] = actions.close,
                                        ["<C-b>"] = tools.move_left,
                                        ["<C-f>"] = tools.move_right,
                                },
                                n = {
                                        ["<C-c>"] = actions.close,
                                },
                        },
                },

                pickers = {
                        builtin = theme.simple_ivy({}),

                        colorscheme = theme.simple_ivy({
                                previewer = false,
                        }),

                        buffers = theme.simple_ivy({
                                initial_mode = "normal",
                                theme = "dropdown",
                                mappings = map({
                                        i = {
                                                ["<c-d>"] = "delete_buffer",
                                        },
                                        n = {
                                                ["<c-d>"] = "delete_buffer",
                                        },
                                }),
                                path_display = { "tail" },
                        }),

                        oldfiles = theme.simple_ivy({
                                previewer = false,
                                mappings = map(),
                        }),

                        find_files = theme.simple_ivy({
                                previewer = false,
                                find_command = { "fd", "-H" },
                                mappings = map(),
                        }),

                        live_grep = theme.simple_ivy({
                                find_command = { "rg" },
                                mappings = map(),
                        }),

                        current_buffer_fuzzy_find = theme.simple_ivy({
                                find_command = { "rg" },
                                mappings = map(),
                        }),
                        lsp_references = theme.simple_ivy({
                                mappings = map(),
                        }),

                        lsp_definitions = theme.simple_ivy({
                                mappings = map(),
                        }),
                },

                extensions = {
                        fzf = {
                                fuzzy = true,
                                override_generic_sorter = true,
                                override_file_sorter = true,
                        },
                        ["ui-select"] = {
                                require("telescope.themes").get_dropdown(theme.single_dropdown()),
                        },
                        live_grep_args = {
                                theme = require("telescope.themes").get_ivy(theme.simple_ivy()),
                        },
                },
        })
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        telescope.load_extension("live_grep_args")
end

return M
