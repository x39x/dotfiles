local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {

		diagnostics.codespell.with({
			extra_args = { "-L", "RIME,Rime,rime" },
		}),

		formatting.shfmt.with({
			extra_filetypes = { "bash", "zsh" },
			extra_args = {
				"--indent",
				"4",
			},
		}),
	},

	on_attach = function(_, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "F", function()
			vim.lsp.buf.format({ async = true })
		end, {})
	end,
})
