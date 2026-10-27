return {
	cmd = { "typos-lsp" },
	cmd_env = { RUST_LOG = "typos_lsp=off" },
	root_markers = { "typos.toml", "_typos.toml", ".typos.toml", "pyproject.toml", "Cargo.toml" },
	settings = {},
}
