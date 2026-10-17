-- ===========================================================
--- go:
--  go install golang.org/x/tools/gopls@latest
--------------------------------------------------------------
--- python:
--  uv tool install ruff
--  uv tool install ty
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
--  mason oxfmt
--  mason vtsls
--  mason css-lsp
--  mason tailwindcss-language-server
--  mason vue-language-server
--  mason svelte-language-server
--  todo: oxlint
--------------------------------------------------------------
--- lua:
--  mason stylua
--  mason lua-language-server
--------------------------------------------------------------
--- spell
--  mason typos/codespell
--  mason harper: grammar checker
-- ===========================================================

-- set lsp float window border
-- - "solid": Adds padding by a single whitespace cell. see h winborder
local lsp_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "single"
	return lsp_floating_preview(contents, syntax, opts, ...)
end

-- LSP config
vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			-- ▎ 󰌕      󰌶       ┃
			[vim.diagnostic.severity.ERROR] = "",
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
	"typos",
	"luals",

	"gopls",
	"rust_analyzer",
	"cmake",
	"clangd",
	"ruff",
	"ty",

	"vtsls",
	"cssls",
	"tailwindcss",

	-- "vuels",
	-- "jsonls",
}
vim.lsp.enable(servers)

local keymap = vim.keymap.set
local keymap_opts = require("utils.keymap_opts")
local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
	desc = "lsp keymap",
	group = vim.api.nvim_create_augroup("lsp attach", { clear = true }),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		local bufnr = ev.buf

		-- see :h lsp-defaults
		keymap("n", "gD", vim.lsp.buf.declaration, keymap_opts({ buffer = bufnr, desc = "Lsp declaration" }))
		keymap("n", "gl", function()
			vim.lsp.buf.hover({ border = "double" })
		end, keymap_opts({ buffer = bufnr, desc = "Lsp hover" }))
		keymap("n", "ga", function()
			vim.diagnostic.open_float({ border = "double" })
		end, keymap_opts({ buffer = bufnr, desc = "Lsp diagnostic" }))
		keymap("n", "gA", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
		keymap("n", "<leader>ga", vim.lsp.buf.workspace_diagnostics, keymap_opts({ buffer = bufnr, desc = "Lsp workspace diagnostics" }))

		local status, fzflua = pcall(require, "fzf-lua")
		if status then
			keymap("n", "gd", fzflua.lsp_definitions, keymap_opts({ buffer = bufnr, desc = "Lsp fzf definitions" }))
			-- vim.keymap.del("", "grr")
			keymap("n", "grr", fzflua.lsp_references, keymap_opts({ buffer = bufnr, desc = "Lsp fzf references" }))
		else
			keymap("n", "gd", vim.lsp.buf.definition, keymap_opts({ buffer = bufnr, desc = "Lsp default definitions" }))
		end

		if client:supports_method("textDocument/completion") then
			-- <C-e> dismiss the completion menu
			-- <C-x><C-o>  omnifunc.
			-- <C-o>s Inside a snippet, use backspace to remove the placeholder.

			local function feedkeys(keys)
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
			end
			keymap({ "i", "s" }, "<S-Tab>", function()
				if vim.snippet.active({ direction = -1 }) then
					vim.snippet.jump(-1)
				else
					feedkeys("<S-Tab>")
				end
			end, { buffer = bufnr })
		end

		-- :h lsp-semantic-highlght
		for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
			vim.api.nvim_set_hl(0, group, {})
		end
	end,
})
