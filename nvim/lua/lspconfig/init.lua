vim.pack.add({
        "https://github.com/williamboman/mason.nvim",
        "https://github.com/nvimtools/none-ls.nvim",
        "https://github.com/antosha417/nvim-lsp-file-operations", -- optional LSP integration
})
local lsp_keymaps = require("lspconfig.keymap")

-- LSP config
vim.diagnostic.config({
        virtual_text = false,
        signs = {
                text = {
                        -- ▎  󰌕  ✎           
                        [vim.diagnostic.severity.ERROR] = "▎",
                        [vim.diagnostic.severity.WARN] = "▎",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = "",
                },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
                focusable = false,
                style = "minimal",
                border = "single",
                source = "if_many",
                header = "",
                prefix = "",
        },
})
-- set lsp float window border
-- - "solid": Adds padding by a single whitespace cell. see h winborder
local vim_float_win = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "solid"
        return vim_float_win(contents, syntax, opts, ...)
end

local servers = {
        "lua_ls",
        "gopls",
        "rust_analyzer",

        "cmake",
        "clangd",

        "ruff",
        "pyright",

        "vtsls",
        "vue_ls",
        "tailwindcss",

        -- "ts_ls",
        -- "racket_langserver",
        -- "jsonls",
}

require("mason").setup({

        max_concurrent_installers = 10,
        ui = {
                icons = {
                        package_installed = "",
                        package_pending = "",
                        package_uninstalled = "",
                },
        },
        border = "single",
})

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
null_ls.setup({
        debug = false,
        sources = {

                diagnostics.codespell.with({
                        extra_args = { "-L", "RIME,Rime,rime" },
                }),
                -- To increase speed, try prettierd.
                formatting.prettier.with({
                        extra_args = { "--tab-width", "4" },
                        extra_filetypes = { "jsonc", "json5", "toml" },
                }),
                formatting.stylua.with({
                        extra_args = {
                                "--indent-width",
                                "8",
                                "--indent-type",
                                "Spaces",
                        },
                }),
        },
        on_attach = function(_, bufnr)
                vim.api.nvim_buf_create_user_command(bufnr, "F", function()
                        vim.lsp.buf.format({ async = true })
                end, {})
        end,
})

-- must after nvimtree
require("lsp-file-operations").setup()
vim.lsp.config("*", {
        on_attach = function(_, bufnr)
                lsp_keymaps(bufnr)
        end,
        capabilities = require("lsp-file-operations").default_capabilities(),
})

vim.lsp.enable(servers)
