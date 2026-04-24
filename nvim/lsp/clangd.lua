--NOTE: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/clangd.lua
return {
        cmd = {
                "clangd",
                "--background-index", -- 后台索引
                "--clang-tidy", -- 静态代码检查
                "--header-insertion=iwyu", -- include What You Use
                "--completion-style=detailed",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_markers = {
                ".clangd",
                ".clang-tidy",
                ".clang-format",
                "compile_flags.txt",
                "configure.ac",
                "Makefile",
                ".git",
        },
        capabilities = {
                textDocument = {
                        completion = {
                                editsNearCursor = true,
                        },
                },
                offsetEncoding = { "utf-8", "utf-16" },
        },
        on_init = function(client, init_result)
                client.server_capabilities.semanticTokensProvider = nil -- turn off semantic tokens
                if init_result.offsetEncoding then
                        client.offset_encoding = init_result.offsetEncoding
                end
        end,
}
