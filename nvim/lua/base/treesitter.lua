local parsers = {
        "regex",
        "diff",
        "printf",

        "xml",
        "yaml",
        "toml",
        "json",
        "json5",
        "vimdoc",
        "markdown",
        "markdown_inline",

        "c",
        "go",
        "cpp",
        "lua",
        "rust",
        "python",

        "css",
        "tsx",
        "html",
        "jsdoc",
        "svelte",
        "javascript",
        "typescript",

        "fish",
        "bash",
        "make",
        "cmake",
}
require("tree-sitter-manager").setup({
        ensure_installed = parsers,
        border = "single",
        auto_install = false, -- if enabled, install missing parsers when editing a new file
        highlight = true, -- treesitter highlighting is enabled by default
})

-- Not every tree-sitter parser is the same as the file type detected
-- So the patterns need to be registered more cleverly
local patterns = {}
for _, parser in ipairs(parsers) do
        local parser_patterns = vim.treesitter.language.get_filetypes(parser)
        vim.list_extend(patterns, parser_patterns)
end

vim.api.nvim_create_autocmd("FileType", {
        pattern = patterns,
        callback = function()
                vim.treesitter.start()
        end,
        group = vim.api.nvim_create_augroup("TREESITTER_HIGHLIGHT", { clear = true }),
})

--PLUG: fold
require("ufo").setup({
        provider_selector = function(_, _, _)
                return { "treesitter", "indent" }
        end,
})

require("nvim-treesitter-textobjects").setup({
        select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                },
        },
})

local keymap_opts = require("utils.keymap_opts")
vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end, keymap_opts({ desc = "Treesitter function outer" }))

vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end, keymap_opts({ desc = "Treesitter function inner" }))

vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end, keymap_opts({ desc = "Treesitter class outer" }))

vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end, keymap_opts({ desc = "Treesitter class inner" }))
