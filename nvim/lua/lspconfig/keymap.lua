local lsp_rename = function()
        local current_word = vim.fn.expand("<cword>")
        local prompt = "New name for '" .. current_word .. "': "
        vim.ui.input({ prompt = prompt, default = "" }, function(new_name)
                if new_name and new_name ~= "" and new_name ~= current_word then
                        vim.lsp.buf.rename(new_name)
                end
        end)
end
-- see :h lsp-defaults
return function(bufnr)
        local keymap = vim.keymap.set
        local opts = require("utils.keymap_opts")

        keymap("n", "gl", function()
                vim.lsp.buf.hover({ border = "solid" })
        end, opts({ buffer = bufnr, desc = "Lsp hover" }))

        keymap("n", "ga", function()
                vim.diagnostic.open_float({ border = "solid" })
        end, opts({ buffer = bufnr, desc = "Lsp diagnostic" }))

        keymap("n", "gd", require("fzf-lua").lsp_definitions, opts({ buffer = bufnr, desc = "Lsp fzf definitions" }))
        keymap(
                "n",
                "gri",
                require("fzf-lua").lsp_implementations,
                opts({ buffer = bufnr, desc = "Lsp fzf implementations" })
        )
        keymap("n", "grr", require("fzf-lua").lsp_references, opts({ buffer = bufnr, desc = "Lsp fzf references" }))
        keymap("n", "gD", vim.lsp.buf.declaration, opts({ buffer = bufnr, desc = "Lsp declaration" }))
        keymap("n", "grn", lsp_rename, opts({ buffer = bufnr, desc = "Lsp rename" }))
        keymap("n", "gra", vim.lsp.buf.code_action, opts({ buffer = bufnr, desc = "Lsp code action" }))
        keymap(
                "n",
                "<leader>ga",
                vim.lsp.buf.workspace_diagnostics,
                opts({ buffer = bufnr, desc = "Lsp workspace diagnostics" })
        )

        vim.api.nvim_buf_create_user_command(bufnr, "F", function()
                vim.lsp.buf.format({ async = true })
        end, { desc = "lsp format" })
end
