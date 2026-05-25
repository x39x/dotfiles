local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local u = require("null-ls.utils")

local FORMATTING = methods.internal.FORMATTING

local oxfmt = h.make_builtin({
	name = "oxfmt",
	method = FORMATTING,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",

		"vue",
		"svelte",
		"astro",

		"html",
		"css",
		"scss",
		"less",

		"markdown",
		"yaml",
		"toml",
		"json",
		"jsonc",
		"json5",
	},
	factory = h.formatter_factory,
	generator_opts = {
		command = "oxfmt",
		args = { "$FILENAME" },
		to_temp_file = true,
		from_temp_file = true,
		timeout = 10000,
		cwd = h.cache.by_bufnr(function(params)
			return u.root_pattern(".oxfmtrc.json")(params.bufname)
		end),
	},
})

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

		oxfmt,
	},

	on_attach = function(_, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "F", function()
			vim.lsp.buf.format({ async = true })
		end, {})
	end,
})
