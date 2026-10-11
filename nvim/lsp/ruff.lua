--NOTE: config: https://docs.astral.sh/ruff/editors/settings/
return {
	-- cmd = { "uv", "run", "ruff", "server" },
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
	settings = {
		organizeImports = true,
		lint = {
			enable = true,
		},
	},
	init_options = {
		settings = {
			fixAll = false,
		},
	},
}
