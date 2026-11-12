-- ===========================================================
--- go:
--  go install golang.org/x/tools/gopls@latest
--------------------------------------------------------------
--- python:
--  uv tool install ruff
--  uv tool install ty
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
--  mason oxfmt
--  mason vtsls
--  mason css-lsp
--  mason tailwindcss-language-server
--  mason vue-language-server
--  mason svelte-language-server
--  todo: oxlint
--------------------------------------------------------------
--- lua:
--  mason stylua
--  mason lua-language-server
--------------------------------------------------------------
--- spell
--  mason typos
--  mason harper: grammar checker
-- ===========================================================

-- set lsp float window border
-- - "solid": Adds padding by a single whitespace cell. see h winborder
local lsp_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "single"
    return lsp_floating_preview(contents, syntax, opts, ...)
end

-- LSP config
vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    -- virtual_line = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    float = {
        header = "",
        prefix = "",
        -- source = "if_many",
        source = true,
        border = "single",
    },
    update_in_insert = false,
    severity_sort = true,
})

local servers = {
    -- "luals",
    "emmyluals",

    "gopls",
    "rust_analyzer",
    "clangd",
    "ruff",
    "ty",

    "vtsls",
    "cssls",

    -- "tailwindcss",
    -- "vuels",
    -- "jsonls",
}

vim.lsp.enable(servers)

local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
    desc = "lsp keymap",
    group = vim.api.nvim_create_augroup("lsp attach", { clear = true }),
    callback = function(ev)
        if not assert(vim.lsp.get_client_by_id(ev.data.client_id)) then
            return
        end

        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        if client and vim.tbl_contains({ "typos" }, client.config.name) then
            return
        end

        local bufnr = ev.buf

        -- see :h lsp-defaults
        keymap("n", "gD", vim.lsp.buf.declaration, { buf = bufnr })

        keymap("n", "gl", function()
            vim.lsp.buf.hover({ border = "double" })
        end, { buf = bufnr })

        keymap("n", "ga", function()
            vim.diagnostic.open_float({ border = "double" })
        end, { buf = bufnr })

        keymap("n", "gA", vim.diagnostic.setloclist, { buf = bufnr })

        keymap("n", "<leader>da", vim.lsp.buf.workspace_diagnostics, { buf = bufnr })

        keymap("n", "<leader>dt", function()
            vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { buf = bufnr, desc = "Toggle verbose diagnostics and inlay_hints." })

        if FzfLua then
            keymap("n", "gd", FzfLua.lsp_definitions, { buf = bufnr })
            keymap("n", "grr", FzfLua.lsp_references, { buf = bufnr })
        else
            -- lsp has default grr
            keymap("n", "gd", vim.lsp.buf.definition, { buf = bufnr })
        end

        -- :h lsp-semantic-highlght
        for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
            vim.api.nvim_set_hl(0, group, {})
        end
    end,
})
