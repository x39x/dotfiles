local function root_markers_with_field(root_files, new_names, field, fname)
	local path = vim.fn.fnamemodify(fname, ":h")
	local found = vim.fs.find(new_names, { path = path, upward = true })

	for _, f in ipairs(found or {}) do
		for line in io.lines(f) do
			if line:find(field) then
				root_files[#root_files + 1] = vim.fs.basename(f)
				break
			end
		end
	end

	return root_files
end

local function insert_package_json(root_files, field, fname)
	return root_markers_with_field(root_files, { "package.json", "package.json5" }, field, fname)
end

return {
	cmd = function(dispatchers, config)
		local cmd = "tailwindcss-language-server"
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end,
	filetypes = {
		"css",
		"html",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"astro",
	},
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
	settings = {
		tailwindCSS = {
			validate = true,
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidScreen = "error",
				invalidVariant = "error",
				invalidConfigPath = "error",
				invalidTailwindDirective = "error",
				recommendedVariantOrder = "warning",
			},
			classAttributes = {
				"class",
				"className",
				"class:list",
				"classList",
				"ngClass",
			},
			includeLanguages = {
				eelixir = "html-eex",
				elixir = "phoenix-heex",
				eruby = "erb",
				heex = "phoenix-heex",
				htmlangular = "html",
				templ = "html",
			},
		},
	},
	before_init = function(_, config)
		config.settings = vim.tbl_deep_extend("keep", config.settings, {
			editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
		})
	end,
	workspace_required = true,
	root_dir = function(bufnr, on_dir)
		local root_files = {
			"tailwind.config.js",
			"tailwind.config.mjs",
			"tailwind.config.ts",
			-- Fallback for tailwind v4, where tailwind.config.* is not required anymore
			".git",
		}
		local fname = vim.api.nvim_buf_get_name(bufnr)
		root_files = insert_package_json(root_files, "tailwindcss", fname)
		root_files = root_markers_with_field(root_files, { "mix.lock", "Gemfile.lock" }, "tailwind", fname)
		on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
	end,
}
