-- ===========================================================
--- go:
--  mason gople
--  go install golang.org/x/tools/gopls@latest
--------------------------------------------------------------
--- python:
--  uv tool install ruff
--  uv tool install ty
--  mason ty ruff
--------------------------------------------------------------
--- sh
--  mason shfmt
--------------------------------------------------------------
--- c/cc:
--  clangd
--  mason neocmakelsp
--------------------------------------------------------------
--- rust:
--  rustup component add rust-analyzer
--------------------------------------------------------------
--- swift:
--  https://github.com/swiftlang/swiftly
--  https://github.com/swiftlang/sourcekit-lsp
--------------------------------------------------------------
--- javascript:
--  mason vtsls
--  mason oxfmt
--  mason vue-language-server
--  mason svelte-language-server
--  mason css-lsp
--  mason tailwindcss-language-server
--------------------------------------------------------------
--- lua:
--  mason stylua
--  mason lua-language-server
--------------------------------------------------------------
--- spell
--  mason codespell
-- ===========================================================

vim.pack.add({
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/nvimtools/none-ls.nvim",
})

-- set lsp float window border
-- - "solid": Adds padding by a single whitespace cell. see h winborder
local vim_float_win = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "single"
	return vim_float_win(contents, syntax, opts, ...)
end

vim.keymap.del("", "grn")
vim.keymap.del("", "gra")
vim.keymap.del("", "grr")
vim.keymap.del("", "gri")

local lsp_keymaps = require("lspconfig.keymap")

-- LSP config
vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			-- ▎ 󰌕  󰚍 󰧟   󰌶  ⚡    󰋽    ┃
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "󰌶",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "bold",
		source = "if_many",
		header = "",
		prefix = "",
	},
})

local servers = {
	"lua_ls",
	"stylua",

	"gopls",
	"rust_analyzer",

	"cmake",
	"clangd",

	"ruff",
	"ty",

	"vtsls",
	"vue_ls",
	"css",
	"tailwindcss",

	-- "jsonls",
}

require("mason").setup({

	max_concurrent_installers = 10,
	ui = {
		icons = {
			package_installed = "",
			package_pending = "",
			package_uninstalled = "",
		},
		backdrop = 100,
		border = "double",
	},
})

require("lspconfig.null")

vim.lsp.config("*", {
	on_attach = function(_, bufnr)
		lsp_keymaps(bufnr)
	end,
})
vim.lsp.enable(servers)
