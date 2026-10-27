local M = {}

local store_path = vim.fs.joinpath(vim.fn.stdpath("state"), "user", "run_cmd.json")
local keymap = vim.keymap.set

--==========================
-- Storage
--==========================

local function load()
	if vim.fn.filereadable(store_path) == 0 then
		return {}
	end

	local ok, content = pcall(vim.fn.readfile, store_path)
	if not ok or #content == 0 then
		return {}
	end

	local ok, data = pcall(vim.json.decode, table.concat(content, "\n"))
	return ok and type(data) == "table" and data or {}
end

local function save(data)
	vim.fn.mkdir(vim.fs.dirname(store_path), "p")
	vim.fn.writefile({ vim.json.encode(data) }, store_path)
end

local function get_root()
	local markers = {
		"go.mod",
		"Cargo.toml",
		"pyproject.toml",
		"setup.py",
		"CMakeLists.txt",
		"Makefile",
		"package.json",
		".git",
	}

	local file = vim.api.nvim_buf_get_name(0)
	return vim.fs.root(file, markers) or vim.fs.dirname(file)
end

local function get_entry()
	local data = load()
	local root = get_root()

	data[root] = data[root] or { all = {} }

	local entry = data[root]
	entry.all = type(entry.all) == "table" and entry.all or {}

	return root, entry
end

local function remember(root, cmd, target)
	local data = load()
	local entry = data[root] or { all = {} }

	entry.all = type(entry.all) == "table" and entry.all or {}

	if not vim.tbl_contains(entry.all, cmd) then
		table.insert(entry.all, cmd)
	end

	entry.last = {
		cmd = cmd,
		target = target,
	}

	data[root] = entry
	save(data)
end

--==========================
-- tmux
--==========================

local function tmux(args)
	local result = vim.system(vim.list_extend({ "tmux" }, args), {
		text = true,
	}):wait()

	if result.code ~= 0 then
		vim.notify(vim.trim(result.stderr or "") ~= "" and result.stderr or "tmux command failed", vim.log.levels.ERROR)
		return nil
	end

	return vim.trim(result.stdout or "")
end

local function tmux_win(target_name, root, cmd)
	local windows = tmux({
		"list-windows",
		"-F",
		"#{window_name}",
	})

	if not windows then
		return false
	end

	if not vim.tbl_contains(vim.split(windows, "\n"), "runner") then
		if not tmux({ "new-window", "-n", "runner", "-c", root }) then
			return false
		end
	end

	local pwd = tmux({
		"display-message",
		"-p",
		"-t",
		target_name,
		"#{pane_current_path}",
	})

	if not pwd then
		return false
	end

	local command = pwd == root and cmd or ("cd " .. vim.fn.shellescape(root) .. " && " .. cmd)

	if not tmux({
		"send-keys",
		"-t",
		target_name,
		"C-u",
		command,
		"Enter",
	}) then
		return false
	end

	if true then
		-- change focus to runner
		tmux({ "select-window", "-t", target_name })
	else
		vim.notify("Runner: done", vim.log.INFO)
	end
	return true
end

local function run_tmux(root, cmd, target)
	local session = tmux({ "display-message", "-p", "#{session_id}" })
	if not session then
		return false
	end

	local target_name = session .. ":runner"

	if target == "window" then
		return tmux_win(target_name, root, cmd)
	end

	-- pane: send command to pane 1 of the current window
	local window = tmux({ "display-message", "-p", "#{window_id}" })
	if not window then
		return false
	end

	local panes = tmux({
		"list-panes",
		"-t",
		window,
		"-F",
		"#{pane_index}",
	})

	if not panes then
		return false
	end
	-- bug: 有时会 focus 到 runner pane
	local current_paneid = tmux({ "display-message", "-p", "#{pane_index}" })
	if not current_paneid then
		return false
	end

	if not vim.tbl_contains(vim.split(panes, "\n"), "1") then
		if not tmux({
			"split-window",
			"-h",
			"-p",
			"30",
			"-t",
			window,
			"-c",
			root,
		}) then
			return false
		end
	end

	local pane_target = window .. ".1"
	local pwd = tmux({
		"display-message",
		"-p",
		"-t",
		pane_target,
		"#{pane_current_path}",
	})

	if not pwd then
		return false
	end

	local command = pwd == root and cmd or ("cd " .. vim.fn.shellescape(root) .. " && " .. cmd)

	local status
	tmux({
		"send-keys",
		"-t",
		pane_target,
		"C-u",
		command,
		"Enter",
	})

	-- back to nvim pane
	tmux({ "select-pane", "-t", current_paneid })

	return status ~= nil
end

--==========================
-- Runner
--==========================

local function choose_target(callback)
	vim.ui.select({ "pane", "window" }, {
		prompt = "Run in:",
	}, function(target)
		if target then
			callback(target)
		end
	end)
end

local function execute(root, cmd, target)
	if run_tmux(root, cmd, target) then
		remember(root, cmd, target)
	end
end

function M.add()
	local root = get_entry()

	vim.ui.input({ prompt = "Runner add:" }, function(cmd)
		if not cmd or cmd == "" then
			return
		end

		choose_target(function(target)
			execute(root, cmd, target)
		end)
	end)
end

function M.select()
	local root, entry = get_entry()

	if #entry.all == 0 then
		vim.notify("No saved commands for project: " .. root, vim.log.levels.INFO)
		return
	end

	vim.ui.select(entry.all, {
		prompt = "Runner:",
	}, function(cmd)
		if not cmd then
			return
		end

		choose_target(function(target)
			execute(root, cmd, target)
		end)
	end)
end

function M.run()
	local root, entry = get_entry()
	local last = entry.last

	if not last or not last.cmd then
		return M.add()
	end

	execute(root, last.cmd, last.target or "pane")
end

function M.clear(all)
	local data = load()

	if all then
		save({})
		vim.notify("Cleared all project commands.", vim.log.levels.INFO)
		return
	end

	local root = get_root()
	data[root] = nil
	save(data)

	vim.notify("Cleared commands for " .. root, vim.log.levels.INFO)
end

--==========================
-- Commands & keymaps
--==========================

vim.api.nvim_create_user_command("Runner", function(opts)
	local action = opts.args

	if action == "" then
		M.run()
	elseif action == "add" then
		M.add()
	elseif action == "select" then
		M.select()
	elseif action == "clear" then
		M.clear()
	elseif action == "clearall" then
		M.clear(true)
	else
		vim.notify("Usage: Runner [add|select|clear|clearall]", vim.log.levels.ERROR)
	end
end, {
	nargs = "?",
	complete = function()
		return { "add", "select", "clear", "clearall" }
	end,
})

keymap("n", "<leader>-", function()
	local ft = vim.bo.filetype
	if ft == "lua" then
		vim.cmd.source("%")
	else
		M.run()
	end
end, { desc = "Runner" })
keymap("n", "<leader>rs", M.select, { desc = "Runner select" })

return M
