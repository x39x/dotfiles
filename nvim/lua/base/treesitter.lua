require("nvim-treesitter").install({
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
        "tsx",
        "html",
        "jsdoc",
        "svelte",
        "javascript",
        "typescript",

        "fish",
        "bash",
        "make",
        "cmake",
})
vim.api.nvim_create_autocmd("FileType", {
        pattern = {
                "help",
                "xml",
                "yaml",
                "toml",
                "json",
                "jsonc",
                "json5",
                "markdown",

                "c",
                "go",
                "cpp",
                "lua",
                "rust",
                "python",

                "css",
                "html",
                "svelte",
                "javascript",
                "typescript",
                "javascriptreact",
                "typescriptreact",

                "types",
                "fish",
                "bash",
                "make",
                "cmake",
        },
        group = vim.api.nvim_create_augroup("TREESITTER_HIGHLIGHT", { clear = true }),
        callback = function()
                vim.treesitter.start()
        end,
})

--PLUG: fold
require("ufo").setup({
        provider_selector = function(_, _, _)
                return { "treesitter", "indent" }
        end,
})

require("nvim-treesitter-textobjects").setup({
        select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                },
        },
})

local keymap_opts = require("utils.keymap_opts")
vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end, keymap_opts({ desc = "Treesitter function outer" }))

vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end, keymap_opts({ desc = "Treesitter function inner" }))

vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end, keymap_opts({ desc = "Treesitter class outer" }))

vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end, keymap_opts({ desc = "Treesitter class inner" }))
