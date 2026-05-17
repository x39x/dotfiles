local Path = require("plenary.path")

local M = {}
local CMD_STORE_PATH = Path:new(vim.fn.stdpath("state"), "user", "run_cmd.json")
local tmux_run = {}

--==========================
--NOTE: tmux
--==========================
local function notify_err(msg)
	vim.notify(msg, vim.log.levels.ERROR)
end

-- send cmd to window
tmux_run.window = function(root, cmd)
	local session_result = vim.system({ "tmux", "display-message", "-p", "#S" }, { text = true }):wait()
	if session_result.code ~= 0 then
		notify_err("ERROR in tmux_run.lua: Failed to get tmux session")
		return
	end
	local session = vim.trim(session_result.stdout)
	-- list all tmux window
	local list_result = vim.system({ "tmux", "list-windows", "-F", "#{window_name}" }, { text = true }):wait()
	if list_result.code ~= 0 then
		notify_err("ERROR in tmux_run.lua: M.window 1")
		return
	end

	-- check if runner window exist
	local window_exists = false
	for line in list_result.stdout:gmatch("[^\r\n]+") do
		if vim.trim(line) == "runner" then
			window_exists = true
			break
		end
	end

	-- if runner doesn't exist, create a runner window
	if not window_exists then
		local new_result = vim.system({ "tmux", "new-window", "-n", "runner" }):wait()
		if new_result.code ~= 0 then
			notify_err("ERROR in tmux_run.lua: M.window 2")
			return
		end
	end

	-- check if in root dir
	local win_pwd_result = vim.system({
		"tmux",
		"display-message",
		"-p",
		"-F",
		"#{pane_current_path}",
		"-t",
		session .. ":runner",
	}):wait()
	local win_pwd = vim.trim(win_pwd_result.stdout)
	local cd_cmd = "cd " .. root .. " && "
	if win_pwd == root then
		cd_cmd = ""
	end
	-- send run cmd
	vim.system({ "tmux", "send-keys", "-t", session .. ":runner", "C-w", cd_cmd .. cmd, "C-j" }):wait()
	vim.system({ "tmux", "select-window", "-t", session .. ":runner" }):wait()
end

-- send cmd to pane
tmux_run.pane = function(root, run_cmd)
	local session_result = vim.system({ "tmux", "display-message", "-p", "#S" }, { text = true }):wait()
	if session_result.code ~= 0 then
		notify_err("ERROR in tmux_run.lua: Failed to get tmux session")
		return
	end
	local session = vim.trim(session_result.stdout)

	-- get current window id
	local window_result = vim.system({ "tmux", "display-message", "-p", "#I" }, { text = true }):wait()
	if window_result.code ~= 0 then
		notify_err("ERROR in tmux_run.lua: M.pane 1")
		return
	end
	local window = vim.trim(window_result.stdout)

	-- get current pane id
	local current_pane_result = vim.system({ "tmux", "display-message", "-p", "#{pane_index}" }, { text = true }):wait()
	if current_pane_result.code ~= 0 then
		notify_err("ERROR in tmux_run.lua: M.pane 2")
		return
	end
	local current_pane_index = vim.trim(current_pane_result.stdout)

	-- get current session, window
	local target_win = string.format("%s:%s", session, window)

	-- check if pane_1 exist
	local list_result = vim.system({ "tmux", "list-panes", "-t", target_win, "-F", "#{pane_index}" }, { text = true })
		:wait()
	if list_result.code ~= 0 then
		notify_err("ERROR in tmux_run.lua: M.pane 3")
		return
	end
	local panes = vim.split(vim.trim(list_result.stdout), "\n")
	local has_pane1 = vim.tbl_contains(panes, "1")

	-- if doesn't have pane_1, then create pane1
	if not has_pane1 then
		local split_result = vim.system({
			"tmux",
			"split-window",
			"-h",
			"-p",
			"30",
			"-t",
			target_win,
		}, { text = true }):wait()
		if split_result.code ~= 0 then
			notify_err("Failed to create new pane")
			return
		end

		-- back to pane
		vim.system({ "tmux", "select-pane", "-t", current_pane_index }):wait()
	end

	-- check if in root dir
	local pane_pwd_result = vim.system({
		"tmux",
		"display-message",
		"-p",
		"-F",
		"#{pane_current_path}",
		"-t",
		target_win .. ".1",
	}):wait()
	local pane_pwd = vim.trim(pane_pwd_result.stdout)

	local cd_cmd = "cd " .. root .. " && "
	if pane_pwd == root then
		cd_cmd = ""
	end

	-- send cmd to pane_1
	local send_result = vim.system({ "tmux", "send-keys", "-t", target_win .. ".1", "C-w", cd_cmd .. run_cmd, "C-j" })
		:wait()
	if send_result.code ~= 0 then
		notify_err("Failed to send command to pane 1")
	end
end

--==========================
--NOTE: cmd
--==========================

-- load JSON
local function load_cmd_store()
	if not CMD_STORE_PATH:exists() then
		return {}
	end

	local ok, content = pcall(function()
		return CMD_STORE_PATH:read()
	end)

	if not ok or not content or content == "" then
		return {}
	end

	local decoded = vim.fn.json_decode(content)
	return decoded or {}
end

-- save JSON
local function save_cmd_store(data)
	CMD_STORE_PATH:parent():mkdir({ parents = true })
	CMD_STORE_PATH:write(vim.fn.json_encode(data), "w")
end

-- get project root
local function detect_project_root()
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

	local current = Path:new(vim.fn.expand("%:p")):parent()

	for _, marker in ipairs(markers) do
		local found = current:find_upwards(marker)
		if found then
			return Path:new(found):parent():absolute()
		end
	end

	-- fallback
	return current:parent():absolute()
end

-- 加载已保存的命令
local function get_project_entry()
	local all_cmds = load_cmd_store()
	local root = detect_project_root()
	if not all_cmds[root] then
		all_cmds[root] = { last = nil, all = {} }
	end
	return all_cmds, root, all_cmds[root]
end

-- select form all
local function select_existing_cmd(callback)
	local _, root, entry = get_project_entry()

	if not entry.all or #entry.all == 0 then
		vim.notify("No saved commands for project: " .. root, vim.log.levels.INFO)
		return nil
	end

	vim.ui.select(entry.all, { prompt = "Select a command to run:" }, function(selected_cmd)
		if selected_cmd then
			entry.last = selected_cmd
			local all_cmds = load_cmd_store()
			all_cmds[root] = entry
			save_cmd_store(all_cmds)
			callback(root, selected_cmd)
		end
	end)
end

-- add new cmd
local function add_new_cmd()
	local all_cmds, root, entry = get_project_entry()

	vim.ui.input({ prompt = "Enter new command to run: " }, function(input)
		if not input or input == "" then
			vim.notify("Cancelled", vim.log.levels.INFO)
			return
		end

		if not vim.tbl_contains(entry.all, input) then
			table.insert(entry.all, input)
		end
		entry.last = input
		all_cmds[root] = entry
		save_cmd_store(all_cmds)
	end)
	-- add and return new cmd
	return root, entry.last
end

local function get_command()
	local _, root, entry = get_project_entry()
	local cmd = entry.last

	if not cmd then
		vim.notify("No last command found, please add one.", vim.log.levels.WARN)
		_, cmd = add_new_cmd()
	end
	return root, cmd
end

--==========================
-- NOTE: RUNNER
--==========================

function M.run_in_tmux_pane()
	local root, cmd = get_command()
	if cmd then
		tmux_run.pane(root, cmd)
	end
end

function M.run_in_tmux_window()
	local root, cmd = get_command()
	if cmd then
		tmux_run.window(root, cmd)
	end
end

function M.add_and_run()
	local root, cmd = add_new_cmd()

	local methods = { "tmux pane", "tmux window" }
	vim.ui.select(methods, { prompt = "Run in:" }, function(choice)
		if choice == "tmux pane" then
			tmux_run.pane(root, cmd)
		elseif choice == "tmux window" then
			tmux_run.window(root, cmd)
		end
	end)
end

function M.select_and_run()
	local methods = { "tmux pane", "tmux window" }
	vim.ui.select(methods, { prompt = "Run in:" }, function(choice)
		if choice == nil then
			return
		end
		select_existing_cmd(function(root, cmd)
			if choice == "tmux pane" then
				tmux_run.pane(root, cmd)
			elseif choice == "tmux window" then
				tmux_run.window(root, cmd)
			end
		end)
	end)
end

-- ------------------------------
-- clean cmd
-- ------------------------------

function M.clear_project_cmds()
	local all_cmds = load_cmd_store()
	local root = detect_project_root()

	vim.ui.input({ prompt = "Clear commands for <" .. root .. ">? (y/N): " }, function(answer)
		if answer and answer:lower() == "y" then
			all_cmds[root] = nil
			save_cmd_store(all_cmds)
			vim.notify("Cleared commands for " .. root)
		else
			vim.notify("Cancelled")
		end
	end)
end

function M.clear_all_cmds()
	save_cmd_store({})
	vim.notify("Cleared all project commands.")
end

-- run code
local keymap = vim.keymap.set
local keymap_opts = require("utils.keymap_opts")
keymap("n", "<leader>rw", M.run_in_tmux_window, keymap_opts({ desc = "Send cmd to tmux window" }))
keymap("n", "<leader>-", M.run_in_tmux_pane, keymap_opts({ desc = "Send cmd to tmux pane" }))
keymap("n", "<leader>ra", M.add_and_run, keymap_opts({ desc = "add cmd and run" }))
keymap("n", "<leader>rs", M.select_and_run, keymap_opts({ desc = "select cmd and run" }))
keymap("n", "<leader>rc", M.clear_project_cmds, keymap_opts({ desc = "clear current cmd" }))
keymap("n", "<leader>rA", M.clear_all_cmds, keymap_opts({ desc = "clear all cmd" }))

-- "silent! !open %"
-- "silent! !open -a Skim.app %:p:r.pdf"
