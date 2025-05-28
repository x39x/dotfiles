--- https://github.com/yioneko/vtsls
local lsp_keymaps = require("utils.lsp_keymaps")
local vue_language_server_path = vim.fn.expand("$MASON/packages")
        .. "/vue-language-server"
        .. "/node_modules/@vue/language-server"

return {
        cmd = { "vtsls", "--stdio" },
        filetypes = {
                "vue",
                "javascript",
                "typescript",
                "javascriptreact",
                "javascript.jsx",
                "typescriptreact",
                "typescript.tsx",
        },
        root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
        settings = {
                vtsls = { tsserver = { globalPlugins = {} } },
        },
        before_init = function(_, config)
                local vuePluginConfig = {
                        name = "@vue/typescript-plugin",
                        location = vue_language_server_path,
                        languages = { "vue" },
                        configNamespace = "typescript",
                        enableForWorkspaceTypeScriptVersions = true,
                }
                table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
        end,

        on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
                lsp_keymaps(bufnr)
        end,
}
