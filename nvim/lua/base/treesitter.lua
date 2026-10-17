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
	"asciidoc",

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

	"fish",
	"bash",
	"make",
	"cmake",
}

vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = function()
		require("nvim-treesitter.parsers").asciidoc = {
			install_info = {
				url = "https://github.com/cathaysia/tree-sitter-asciidoc",
				branch = "master",
				location = "tree-sitter-asciidoc",
				queries = "tree-sitter-asciidoc/queries",
			},
		}
	end,
})
require("nvim-treesitter").install(parsers)

local patterns = {
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
	"fish",

	"xml",
	"yaml",
	"toml",
	"json",
	"jsonc",
	"json5",
	"help",
	"markdown",
	"asciidoc",
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = patterns,
	callback = function()
		local winid = vim.api.nvim_get_current_win()
		vim.treesitter.start()
		vim.wo[winid][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[winid][0].foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
	group = vim.api.nvim_create_augroup("TREESITTER_HIGHLIGHT", { clear = true }),
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true, -- Automatically jump forward to textobj
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
