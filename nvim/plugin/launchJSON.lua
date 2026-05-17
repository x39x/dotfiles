local create_launch_json = function(opts)
	local launch_path = opts.args ~= "" and vim.trim(opts.args) or ".vscode/launch.json"

	local abs_path = vim.fs.joinpath(vim.fn.getcwd(), launch_path)

	vim.fn.mkdir(vim.fs.dirname(abs_path), "p")

	local tbl = {
		["$schema"] = "https://raw.githubusercontent.com/mfussenegger/dapconfig-schema/master/dapconfig-schema.json",
		version = "0.2.0",
		configurations = {
			{
				name = "",
				type = "",
				request = "launch",
				mode = "debug",
				program = "",
				console = "integratedTerminal",
				args = {},
			},
		},
	}

	local json = vim.json.encode(tbl, { indent = "    " })

	vim.fn.writefile(vim.split(json, "\n"), abs_path)

	vim.notify("launch.json created at: " .. abs_path)
end

vim.api.nvim_create_user_command("LaunchJSON", create_launch_json, {
	nargs = "?",
})
