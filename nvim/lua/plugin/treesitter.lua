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
    "javascript",
    "typescript",

    "bash",
    "make",
    "cmake",
}

require("nvim-treesitter").install(parsers)

local filetype = {
    "go",
    "lua",
    "rust",
    "make",
    "cmake",
    "c",
    "cpp",
    "python",

    "css",
    "html",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",

    "sh",
    "bash",

    "xml",
    "yaml",
    "toml",
    "json",
    "jsonc",
    "json5",
    "help",
    "markdown",
}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
autocmd("FileType", {
    group = augroup("matsu.treesitter.start", { clear = true }),
    pattern = filetype,
    callback = function(args)
        local winid = vim.api.nvim_get_current_win()
        vim.treesitter.start()
        vim.wo[winid][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[winid][0].foldmethod = "expr"
        if args.match ~= "make" then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true, -- Automatically jump forward to textobj
    },
})

vim.keymap.set({ "x", "o" }, "af", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)

vim.keymap.set({ "x", "o" }, "if", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)

vim.keymap.set({ "x", "o" }, "ac", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)

vim.keymap.set({ "x", "o" }, "ic", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
