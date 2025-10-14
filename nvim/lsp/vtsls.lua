--- https://github.com/yioneko/vtsls
return {
        cmd = { "vtsls", "--stdio" },
        init_options = {
                hostInfo = "neovim",
        },
        filetypes = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
        },
        root_dir = function(bufnr, on_dir)
                local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
                -- Give the root markers equal priority by wrapping them in a table
                root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
                        or vim.list_extend(root_markers, { ".git" })
                -- We fallback to the current working directory if no project root is found
                local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

                on_dir(project_root)
        end,
}
