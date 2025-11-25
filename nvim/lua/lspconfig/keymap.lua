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
        vim.keymap.del("", "grn")
        vim.keymap.del("", "gra")
        vim.keymap.del("", "grr")
        vim.keymap.del("", "gri")

        local keymap = vim.keymap.set
        local opts = {
                noremap = true,
                silent = true,
                buffer = bufnr,
        }

        keymap("n", "gl", function()
                vim.lsp.buf.hover({
                        border = "solid",
                })
        end, opts)
        keymap("n", "ga", function()
                vim.diagnostic.open_float({
                        border = "solid",
                })
        end, opts)
        keymap("n", "gd", require("fzf-lua").lsp_definitions, opts)
        keymap("n", "gD", vim.lsp.buf.declaration, opts)
        keymap("n", "gri", require("fzf-lua").lsp_implementations, opts)
        keymap("n", "grr", require("fzf-lua").lsp_references, opts)
        keymap("n", "grn", lsp_rename, opts)

        keymap("n", "gra", vim.lsp.buf.code_action, opts)
        keymap("n", "<leader>ga", vim.lsp.buf.workspace_diagnostics, opts)

        vim.api.nvim_buf_create_user_command(bufnr, "F", function()
                vim.lsp.buf.format({ async = true })
        end, {})
end
