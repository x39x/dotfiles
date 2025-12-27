--NOTE: config: https://docs.astral.sh/ruff/editors/settings/
local lsp_keymaps = require("lspconfig.keymap")
return {
        cmd = { "uv", "run", "ruff", "server" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
        settings = {
                organizeImports = true,
                lint = {
                        enable = true,
                },
        },
        init_options = {
                settings = {
                        fixAll = false,
                },
        },
        on_attach = function(_, bufnr)
                vim.api.nvim_buf_create_user_command(bufnr, "F", function()
                        vim.lsp.buf.format({ async = true })
                end, {})

                lsp_keymaps(bufnr)
        end,
}
