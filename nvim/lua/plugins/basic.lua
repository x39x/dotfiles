local M = {}

-- PLUG: surround
M[#M + 1] = {
        "kylechui/nvim-surround",
        version = "*",
        opts = {},
        event = "VeryLazy",
}

-- PLUG: autopairs
M[#M + 1] = {
        "windwp/nvim-autopairs",
        config = function()
                require("nvim-autopairs").setup({
                        disable_filetype = { "TelescopePrompt", "fzf" },
                        enable_check_bracket_line = false,
                })
                require("nvim-autopairs").get_rules("'")[1].not_filetypes = { "scheme", "lisp" }
                require("nvim-autopairs").get_rules("`")[1].not_filetypes = { "typst" }
        end,
        event = "VeryLazy",
}

-- -- PLUG: ts-comments
M[#M + 1] = {
        "folke/ts-comments.nvim",
        config = true,
        event = "VeryLazy",
}

--PLUG: todo
M[#M + 1] = {
        "folke/todo-comments.nvim",
        opts = {
                keywords = {
                        FIX = { icon = "󰨰 ", color = "#DC2626", alt = { "BUG", "ISSUE" } },
                        TEST = { icon = " ", color = "#AF7AC5", alt = { "FUNC", "PLUG" } },
                        WARN = { icon = " ", color = "#C0392B" },
                        TODO = { icon = " ", color = "#DC2626" },
                        DONE = { icon = " ", color = "#1957F3" },
                        NOTE = { icon = "", color = "#10B981", alt = { "INFO", "TIPS" } },
                },
                merge_keywords = false,
        },
        event = "VeryLazy",
}

--PLUG: deffview
M[#M + 1] = {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "DiffviewOpen",
}

--PLUG: trouble
M[#M + 1] = {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
                focus = true,
                auto_preview = false,
                win = { position = "right" },
                preview = {
                        type = "float",
                        relative = "editor",
                        border = "single",
                        position = { 0, -2 },
                        size = { width = 0.3, height = 0.3 },
                        zindex = 200,
                },
                modes = {
                        symbols = {
                                auto_preview = false,
                                focus = true,
                        },
                },
        },
        event = "VeryLazy",
}

--PLUG:  motion
M[#M + 1] = {
        "folke/flash.nvim",
        opts = {
                labels = "asdfghjkl;weruiopzxcvnm",
                modes = {

                        char = {
                                enabled = false,
                        },
                        search = {
                                enabled = false,
                        },
                },
                highlight = {
                        backdrop = false,
                },
                jump = {
                        forward = true,
                        wrap = true,
                },
                prompt = {
                        enabled = false,
                },
        },
        event = "VeryLazy",
}

--PLUG: fold
M[#M + 1] = {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        opts = {
                provider_selector = function(_, _, _)
                        return { "treesitter", "indent" }
                end,
        },
        event = "VeryLazy",
}

--PLUG: treesitter
M[#M + 1] = {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
                require("nvim-treesitter.configs").setup({
                        ensure_installed = {
                                "regex",
                                "diff",
                                "printf",

                                "xml",
                                "yaml",
                                "toml",
                                "json",
                                "jsonc",
                                "json5",
                                "vimdoc",
                                "markdown",
                                "markdown_inline",

                                "c",
                                "go",
                                "cpp",
                                "lua",
                                "rust",
                                "python",

                                "css",
                                "html",
                                "tsx",
                                "jsdoc",
                                "javascript",
                                "typescript",

                                "typst",
                                "fish",
                                "bash",
                        },
                        sync_install = false,
                        highlight = {
                                enable = true,
                        },
                        indent = {
                                enable = true,
                        },
                        incremental_selection = {
                                enable = true,
                                keymaps = {
                                        node_incremental = "v",
                                        node_decremental = "<BS>",
                                        init_selection = false,
                                        scope_incremental = false,
                                },
                        },
                })
        end,

        event = "VeryLazy",
}

M[#M + 1] = {
        "RRethy/nvim-treesitter-textsubjects",
        dependencies = {
                "nvim-treesitter/nvim-treesitter",
        },

        config = function()
                require("nvim-treesitter-textsubjects").configure({
                        prev_selection = ".",
                        keymaps = {
                                [","] = "textsubjects-smart",
                                -- [";"] = "textsubjects-container-outer",
                                -- ["i;"] = "textsubjects-container-inner",
                        },
                })
        end,
}
M[#M + 1] = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
                "nvim-treesitter/nvim-treesitter",
        },

        config = function()
                require("nvim-treesitter.configs").setup({
                        textobjects = {
                                enable = true,
                                select = {
                                        enable = true,
                                        -- Automatically jump forward to textobj, similar to targets.vim
                                        lookahead = true,

                                        keymaps = {
                                                ["af"] = "@function.outer",
                                                ["if"] = "@function.inner",
                                                ["ac"] = "@class.outer",
                                                ["ic"] = "@class.inner",
                                        },
                                },
                        },
                })
        end,
}
--PLUG: align
M[#M + 1] = {
        "junegunn/vim-easy-align",
        config = function()
                local set = vim.keymap.set
                set({ "n", "v" }, ";a", "<Plug>(EasyAlign)", { noremap = true, silent = true })
        end,
        event = "VeryLazy",
}

--PLUG: table,
M[#M + 1] = {
        "Kicamon/markdown-table-mode.nvim",
        opts = {},
        ft = "markdown",
}

return M
