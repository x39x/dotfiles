local function find_project_root(start_path)
	local marker = vim.fs.find({ "Makefile", ".git", "CMakeLists.txt" }, {
		path = start_path,
		upward = true,
		stop = vim.uv.os_homedir(),
	})[1]

	if not marker then
		return nil
	end

	return vim.fs.dirname(marker)
end

local function find_debug_executable()
	local current_file = vim.api.nvim_buf_get_name(0)

	-- no file
	if current_file == "" then
		local cwd = vim.fn.getcwd()

		return vim.fn.input("Path to executable: ", cwd .. "/", "file"), cwd
	end

	local start_dir = vim.fs.dirname(current_file)
	local root = find_project_root(start_dir)

	-- root/debug/dbg
	if root then
		local dbg_path = vim.fs.joinpath(root, "debug", "dbg")

		if vim.fn.filereadable(dbg_path) == 1 then
			return dbg_path, root
		end
	end

	-- ./debug/dbg
	local fallback_dbg = vim.fs.joinpath(start_dir, "debug", "dbg")

	if vim.fn.filereadable(fallback_dbg) == 1 then
		return fallback_dbg, start_dir
	end

	-- manual input
	local manual = vim.fn.input("Path to executable: ", start_dir .. "/", "file")

	return manual, start_dir
end

local cpp = {}
local program_path, project_root = find_debug_executable()

local lldb = {
	type = "executable",
	command = "/System/Volumes/Data/Library/Developer/CommandLineTools/usr/bin/lldb-dap",
	name = "lldb",
}

cpp[#cpp + 1] = {
	name = "Launch",
	type = "lldb",
	request = "launch",
	program = program_path,
	cwd = project_root,
	args = {},
}

return function()
	if vim.fn.executable(lldb.command) == 0 then
		vim.notify("LLDB binary not found: " .. lldb.command, vim.log.levels.WARN)
		return
	end
	local dap = require("dap")
	dap.adapters.lldb = lldb
	dap.configurations.cpp = cpp
end
