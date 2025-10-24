vim.pack.add({
        "https://github.com/rafamadriz/friendly-snippets",
        "https://github.com/L3MON4D3/LuaSnip",
        -- build = "make install_jsregexp",

        {
                src = "https://github.com/Saghen/blink.cmp",
                version = vim.version.range("1.*"),
        },
})

local cmp_border = { " ", " ", " ", " ", " ", " ", " ", " " }

local luasnip = require("luasnip")
luasnip.filetype_extend("javascriptreact", { "html" })
luasnip.filetype_extend("typescriptreact", { "html" })
luasnip.config.set_config({
        enable_autosnippets = true,
})
require("luasnip/loaders/from_vscode").lazy_load({
        include = {
                "c",
                "go",
                "zig",
                "lua",
                "cpp",
                "rust",
                "python",

                "css",
                "html",
                "vue",
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
        },
})
require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
})

require("blink.cmp").setup({

        snippets = { preset = "luasnip" },
        signature = {
                enabled = true,
                window = { border = cmp_border, scrollbar = false },
        },

        completion = {
                keyword = { range = "prefix" },
                menu = {
                        border = cmp_border,
                        scrollbar = false,
                },
                documentation = { window = { border = "single", scrollbar = false }, auto_show = false },
        },
        keymap = {
                ["<C-space>"] = {},
                ["<C-l>"] = { "select_and_accept", "fallback" },
                ["<C-y>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
        },
        cmdline = {
                keymap = { preset = "inherit" },
        },
})
