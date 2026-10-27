return {
	cmd = { "emmylua_ls" },
	filetypes = { "lua" },

	root_markers = {
		".emmyrc.json",
		".emmyrc.lua",
		".luarc.json",
		".luarc.jsonc",
		".stylua.toml",
		"stylua.toml",
		".git",
	},
	workspace_required = false,
	settings = {
		emmylua = {

			runtime = { version = "LuaJIT" },
			codeLens = { enable = true },
			hint = { enable = true },
			workspace = {

				library = {
					vim.env.VIMRUNTIME,
				},
				-- or pull in all of vim 'runtimepath'
				-- library = vim.api.nvim_get_runtime_file("", true),
			},
			completion = {
				callSnippet = true,
			},
			semanticTokens = {
				enable = false,
			},
			format = {
				externalTool = {
					program = "stylua",
					args = {
						"-",
						"--stdin-filepath",
						"${file}",
					},
				},
			},

			diagnostics = {
				globals = { "FzfLua" },
				disable = { "unnecessary-if" },
			},
		},
	},

	on_init = function(client)
		-- If the workspace has its own emmylua_ls/lua_ls config file, defer to it.
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.emmyrc.json") or vim.uv.fs_stat(path .. "/.luarc.json"))
			then
				client.config.settings = {}
			end
		end
	end,
}
