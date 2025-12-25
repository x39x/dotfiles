local lsp_keymaps = require("lspconfig.keymap")
local python_path = require("utils.python_path")

return {
        on_init = function(client)
                client.config.settings.python.pythonPath = python_path
        end,
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "pyrightconfig.json",
                ".git",
        },
        settings = {
                python = {
                        analysis = {
                                typeCheckingMode = "off",
                        },
                },
        },
        on_attach = function(_, bufnr)
                lsp_keymaps(bufnr)
        end,
}
