return {
	cmd = { "oxfmt", "--lsp" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",

		"html",
		"css",
		"scss",
		"less",

		"vue",
		"svelte",
		"astro",

		"markdown",
		"toml",
		"yaml",
		"json",
		"jsonc",
		"json5",
	},
	workspace_required = true,
	root_markers = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts", ".git" },
}
