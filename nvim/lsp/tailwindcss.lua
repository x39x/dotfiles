---@brief

return {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = {
                "css",
                "less",
                "sass",
                "scss",
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "vue",
        },
        root_markers = {
                "tailwind.config.js",
                "tailwind.config.cjs",
                "tailwind.config.mjs",
                "tailwind.config.ts",
                "postcss.config.js",
                "postcss.config.cjs",
                "postcss.config.mjs",
                "postcss.config.ts",
        },
        workspace_required = true,
        settings = {
                tailwindCSS = {
                        validate = true,
                        lint = {
                                cssConflict = "warning",
                                invalidApply = "error",
                                invalidScreen = "error",
                                invalidVariant = "error",
                                invalidConfigPath = "error",
                                invalidTailwindDirective = "error",
                                recommendedVariantOrder = "warning",
                        },
                        classAttributes = {
                                "class",
                                "className",
                                "class:list",
                                "classList",
                                "ngClass",
                        },
                        includeLanguages = {
                                eelixir = "html-eex",
                                eruby = "erb",
                                templ = "html",
                                htmlangular = "html",
                        },
                },
        },
        before_init = function(_, config)
                if not config.settings then
                        config.settings = {}
                end
                if not config.settings.editor then
                        config.settings.editor = {}
                end
                if not config.settings.editor.tabSize then
                        config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
                end
        end,
}
