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
	auto_install = false,
	highlight = true,
	languages = {
		asciidoc = {
			install_info = {
				url = "https://github.com/cathaysia/tree-sitter-asciidoc",
				location = "tree-sitter-asciidoc",
				use_repo_queries = true,
			},
		},
	},
})

--BUG: treesitter.get_filetypes can't get all when startup
local patterns = { "typescriptreact" }
local seen = {}
for _, parser in ipairs(parsers) do
	local parser_patterns = vim.treesitter.language.get_filetypes(parser) or {}

	for _, ft in ipairs(parser_patterns) do
		if not seen[ft] then
			seen[ft] = true
			table.insert(patterns, ft)
		end
	end
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
