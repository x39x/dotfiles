-- https://github.com/yioneko/vtsls

-- support TypeScript in .vue files
local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
	languages = { "vue" },
	configNamespace = "typescript",
}
-- NOTE: https://github.com/vuejs/language-tools/tree/master/packages/typescript-plugin

-- enables tsserver to understand .svelte files
local svelte_plugin = {
	name = "typescript-svelte-plugin",
	location = vim.fn.stdpath("data") .. "/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin",
	enableForWorkspaceTypeScriptVersions = true,
}

return {
	cmd = { "vtsls", "--stdio" },
	init_options = {
		hostInfo = "neovim",
	},
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					vue_plugin,
					svelte_plugin,
				},
			},
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},

	on_init = function(client, _)
		client.server_capabilities.semanticTokensProvider = nil -- turn off semantic tokens
		client.server_capabilities.documentFormattingProvider = false
	end,

	root_dir = function(bufnr, on_dir)
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })
		-- We fallback to the current working directory if no project root is found
		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

		on_dir(project_root)
	end,
}
