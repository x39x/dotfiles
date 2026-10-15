local on_init = function(client)
	if client.workspace_folders then
		local path = client.workspace_folders[1].name
		if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
			return
		end
	end

	client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
		runtime = {
			version = "LuaJIT",
			-- Tell the language server how to find Lua modules same way as Neovim
			path = {
				"lua/?.lua",
				"lua/?/init.lua",
			},
		},
		diagnostics = {
			globals = { "vim", "FzfLua", "MiniBufremove" },
		},
		-- Make the server aware of Neovim runtime files
		workspace = {
			checkThirdParty = false,
			library = {
				vim.env.VIMRUNTIME,
				-- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
				vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
			},
		},
	})
end

return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},

	settings = {
		Lua = {
			codeLens = { enable = true },
			hint = { enable = true, semicolon = "Disable" },
			diagnostics = {
				disable = { "missing-fields", "undefined-field", "duplicate-set-field" },
			},
			format = {
				enable = false,
			},
			-- highlight
			semantic = {
				enable = false,
			},
		},
	},
	on_init = on_init,
}
