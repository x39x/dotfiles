-- ===========================================================
--- go:
--  go install golang.org/x/tools/gopls@latest
--------------------------------------------------------------
--- python:
--  uv tool install ruff
--  uv tool install ty
-- mason ty ruff
--------------------------------------------------------------
--- sh
--  mason shfmt
--------------------------------------------------------------
--- c/cc:
--  clangd
--  mason neocmakelsp
--------------------------------------------------------------
--- rust:
--  rustup component add rust-analyzer
--------------------------------------------------------------
--- swift:
--  https://github.com/swiftlang/swiftly
--  https://github.com/swiftlang/sourcekit-lsp
--------------------------------------------------------------
--- javascript:
--  mason vtsls
--  mason oxfmt
--  mason vue-language-server
--  mason svelte-language-server
--  mason css-lsp
--  mason tailwindcss-language-server
--------------------------------------------------------------
--- lua:
--  mason stylua
--  mason lua-language-server
--------------------------------------------------------------
--- spell
--  mason codespell
-- ===========================================================

vim.pack.add({
        "https://github.com/williamboman/mason.nvim",
        "https://github.com/nvimtools/none-ls.nvim",
        "https://github.com/antosha417/nvim-lsp-file-operations", -- optional LSP integration
})

-- set lsp float window border
-- - "solid": Adds padding by a single whitespace cell. see h winborder
local vim_float_win = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "single"
        return vim_float_win(contents, syntax, opts, ...)
end

vim.keymap.del("", "grn")
vim.keymap.del("", "gra")
vim.keymap.del("", "grr")
vim.keymap.del("", "gri")

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
                border = "bold",
                source = "if_many",
                header = "",
                prefix = "",
        },
})

local servers = {
        "lua_ls",
        "gopls",
        "rust_analyzer",

        "cmake",
        "clangd",

        "ruff",
        "ty",

        "vtsls",
        "css",
        "tailwindcss",
        "vue_ls",
        "svelte",

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
                backdrop = 100,
                border = "double",
        },
})

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local u = require("null-ls.utils")

local FORMATTING = methods.internal.FORMATTING

local oxfmt = h.make_builtin({
        name = "oxfmt",
        method = FORMATTING,
        filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",

                "vue",
                "svelte",
                "astro",

                "html",
                "css",
                "scss",
                "less",

                "markdown",
                "yaml",
                "toml",
                "json",
                "jsonc",
                "json5",
        },
        factory = h.formatter_factory,
        generator_opts = {
                command = "oxfmt",
                args = { "$FILENAME" },
                to_temp_file = true,
                from_temp_file = true,
                timeout = 10000,
                cwd = h.cache.by_bufnr(function(params)
                        return u.root_pattern(".oxfmtrc.json")(params.bufname)
                end),
        },
})

null_ls.setup({
        debug = false,
        sources = {

                diagnostics.codespell.with({
                        extra_args = { "-L", "RIME,Rime,rime" },
                }),
                formatting.stylua.with({
                        extra_args = {
                                "--indent-width",
                                "8",
                                "--indent-type",
                                "Spaces",
                        },
                }),
                formatting.shfmt.with({
                        extra_filetypes = { "bash", "zsh" },
                        extra_args = {
                                "--indent",
                                "4",
                        },
                }),
                oxfmt,
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
