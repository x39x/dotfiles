local get_git_root = function(file_path)
	local file_dir = vim.fn.fnamemodify(file_path, ":h")

	local result = vim.system({ "git", "-C", file_dir, "rev-parse", "--show-toplevel" }, { text = true }):wait()

	if result.code ~= 0 then
		vim.notify("WARN in xdiff:get_git_root()", vim.log.levels.WARN)
		return nil
	end

	return result.stdout and vim.trim(result.stdout) or nil
end

-- git show
local get_revision_content = function(git_root, rev, file_path)
	local result = vim.system({
		"git",
		"-C",
		git_root,
		"show",
		("%s:%s"):format(rev, file_path),
	}, { text = true }):wait()

	if result.code ~= 0 then
		vim.notify("xdiff: git show failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
		return nil
	end

	local lines = vim.split(result.stdout or "", "\n", { plain = true })

	-- git show 输出最后会多一个空行
	if #lines > 0 and lines[#lines] == "" then
		table.remove(lines)
	end

	return lines
end

local xdiff = function(opts)
	local rev = opts.args ~= "" and vim.trim(opts.args) or "HEAD"

	local current_path = vim.fn.expand("%:p")
	local git_root = get_git_root(current_path)

	if not git_root then
		return
	end

	local relative_path = current_path:gsub("^" .. vim.pesc(git_root) .. "/", "")

	local content = get_revision_content(git_root, rev, relative_path)

	if not content then
		return
	end

	-- new tab
	vim.cmd("tab split")

	-- current buffer
	local left_buf = vim.api.nvim_get_current_buf()
	local left_win = vim.api.nvim_get_current_win()

	vim.cmd.diffthis()

	-- 右边 revision buffer
	vim.cmd.vnew()

	local right_buf = vim.api.nvim_get_current_buf()

	vim.bo[right_buf].filetype = vim.bo[left_buf].filetype or "txt"
	vim.bo[right_buf].modifiable = true

	vim.api.nvim_buf_set_lines(right_buf, 0, -1, false, content)

	vim.bo[right_buf].modifiable = false
	vim.bo[right_buf].buftype = "nofile"
	vim.bo[right_buf].bufhidden = "wipe"
	vim.bo[right_buf].swapfile = false
	vim.bo[right_buf].readonly = true

	vim.cmd.diffthis()

	vim.api.nvim_set_current_win(left_win)

	local function quit_diff()
		vim.cmd.diffoff()
		vim.cmd.tabclose()
	end

	vim.keymap.set("n", "q", quit_diff, {
		buffer = left_buf,
		silent = true,
	})

	vim.keymap.set("n", "q", quit_diff, {
		buffer = right_buf,
		silent = true,
	})
end

vim.api.nvim_create_user_command("Xdiff", xdiff, {
	nargs = "?",
})
