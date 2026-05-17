local function find_project_root(start_path)
	local root_file = vim.fs.find({ "uv.lock", "pyproject.toml", ".git" }, {
		path = start_path,
		upward = true,
		stop = vim.uv.os_homedir(),
	})[1]

	if not root_file then
		return nil
	end

	return vim.fs.dirname(root_file)
end

local function find_debug_file()
	local current_file = vim.api.nvim_buf_get_name(0)

	if current_file == "" then
		return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
	end

	local start_dir = vim.fs.dirname(current_file)

	-- project root/main.py
	local root = find_project_root(start_dir)

	if root then
		local dbg_path = vim.fs.joinpath(root, "main.py")

		if vim.fn.filereadable(dbg_path) == 1 then
			return dbg_path
		end
	end

	-- current dir/main.py
	local fallback_dbg = vim.fs.joinpath(start_dir, "main.py")

	if vim.fn.filereadable(fallback_dbg) == 1 then
		return fallback_dbg
	end

	-- manual input
	return vim.fn.input("Path to executable: ", start_dir .. "/", "file")
end

--NOTE: config
local python = {}
local python_path = require("utils.python_path")
local debug_file = find_debug_file()

local debugpy = {
	command = python_path,
	type = "executable",
	args = { "-m", "debugpy.adapter" },
	name = "debugpy",
}

python[#python + 1] = {
	type = "debugpy",
	name = "Launch File",
	request = "launch",
	console = "integratedTerminal",
	program = debug_file,
	pythonPath = python_path,
}

return function()
	local dap = require("dap")
	dap.adapters.debugpy = debugpy
	dap.configurations.python = python
end
