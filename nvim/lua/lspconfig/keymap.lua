local lsp_rename = function()
	local current_word = vim.fn.expand("<cword>")
	local prompt = "New name for '" .. current_word .. "': "
	vim.ui.input({ prompt = prompt, default = "" }, function(new_name)
		if new_name and new_name ~= "" and new_name ~= current_word then
			vim.lsp.buf.rename(new_name)
		end
	end)
end

local keymap = vim.keymap.set
local opts = require("utils.keymap_opts")
local M = {}
-- see :h lsp-defaults
M.default = function(bufnr)
	keymap("n", "gl", function()
		vim.lsp.buf.hover({ border = "double" })
	end, opts({ buffer = bufnr, desc = "Lsp hover" }))

	keymap("n", "ga", function()
		vim.diagnostic.open_float({ border = "double" })
	end, opts({ buffer = bufnr, desc = "Lsp diagnostic" }))
	keymap("n", "gA", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

	keymap("n", "gd", require("fzf-lua").lsp_definitions, opts({ buffer = bufnr, desc = "Lsp fzf definitions" }))
	keymap(
		"n",
		"gri",
		require("fzf-lua").lsp_implementations,
		opts({ buffer = bufnr, desc = "Lsp fzf implementations" })
	)
	keymap("n", "grr", require("fzf-lua").lsp_references, opts({ buffer = bufnr, desc = "Lsp fzf references" }))
	keymap("n", "gD", vim.lsp.buf.declaration, opts({ buffer = bufnr, desc = "Lsp declaration" }))
	keymap("n", "grn", lsp_rename, opts({ buffer = bufnr, desc = "Lsp rename" }))
	keymap(
		"n",
		"<leader>ga",
		vim.lsp.buf.workspace_diagnostics,
		opts({ buffer = bufnr, desc = "Lsp workspace diagnostics" })
	)
end

local function feedkeys(keys)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end
local function pumvisible()
	return tonumber(vim.fn.pumvisible()) ~= 0
end
M.complete_keymap = function(client, bufnr)
	--C-e    : dismiss the completion menu.
	--C-x C-n: Trigger LSP completion.
	--C-x C-o: If there's no one, fallback to vanilla omnifunc.
	-- <C-o>s: Inside a snippet, use backspace to remove the placeholder.
	if client:supports_method("textDocument/completion") then
		vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

		keymap("i", "<C-l>", function()
			return pumvisible() and "<C-y>" or "<C-l>"
		end, opts({ buffer = bufnr, expr = true }))
		keymap({ "i", "s" }, "<S-Tab>", function()
			if vim.snippet.active({ direction = -1 }) then
				vim.snippet.jump(-1)
			else
				feedkeys("<S-Tab>")
			end
		end, {})
	end
end
return M
