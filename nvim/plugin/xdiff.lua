-- TODO: vim.ui.tree https://github.com/neovim/neovim/issues/33914

local get_git_root = function(file_path)
	local result = vim.system({ "git", "-C", vim.fs.dirname(file_path), "rev-parse", "--show-toplevel" }, { text = true }):wait()

	if result.code ~= 0 then
		vim.notify("[xdiff]: error in get_git_root()", vim.log.levels.WARN)
		vim.notify((result.stderr or ""), vim.log.levels.WARN)
		return nil
	end

	return result.stdout and vim.trim(result.stdout) or nil
end

-- git show
local get_revision_content = function(git_root, rev, relative_path)
	local result = vim.system({
		"git",
		"-C",
		git_root,
		"--no-pager",
		"show",
		("%s:%s"):format(rev, relative_path),
	}, { text = true }):wait()

	if result.code ~= 0 then
		vim.notify("[xdiff]: error in get_revision_content()", vim.log.levels.WARN)
		vim.notify((result.stderr or ""), vim.log.levels.WARN)
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

	local file_path = vim.api.nvim_buf_get_name(0)
	local git_root = get_git_root(file_path)

	if not git_root then
		return
	end

	local relative_path = file_path:gsub("^" .. vim.pesc(git_root) .. "/", "")
	local content = get_revision_content(git_root, rev, relative_path)

	if not content then
		return
	end

	-- original buf
	local original_buf = vim.api.nvim_get_current_buf()

	-- new tab
	vim.api.nvim_open_tabpage(original_buf, true, { after = -1 })

	-- original buf_win
	local original_win = vim.api.nvim_get_current_win()
	vim.cmd.diffthis()

	-- diff_buf
	local diff_buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_name(diff_buf, "Xdiff://" .. rev .. ":" .. relative_path)
	vim.bo[diff_buf].filetype = vim.bo[original_buf].filetype or "txt"

	vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, content)

	-- wipe: wipeout buf after close win
	vim.bo[diff_buf].buftype = "nowrite"
	vim.bo[diff_buf].bufhidden = "wipe"
	vim.bo[diff_buf].modifiable = false
	vim.bo[diff_buf].readonly = true
	vim.bo[diff_buf].swapfile = false

	-- diff_win
	local diff_win = vim.api.nvim_open_win(diff_buf, true, { split = "right" })
	vim.wo[diff_win].listchars = vim.wo[original_win].listchars
	vim.cmd.diffthis()

	-- back to original win
	vim.api.nvim_set_current_win(original_win)

	local function quit()
		vim.keymap.del("n", "q", { buffer = diff_buf })
		vim.keymap.del("n", "q", { buffer = original_buf })
		vim.api.nvim_win_close(diff_win, false)
		vim.cmd.diffoff()
		vim.cmd.tabclose()
	end

	vim.keymap.set("n", "q", quit, {
		buffer = original_buf,
	})

	vim.keymap.set("n", "q", quit, {
		buffer = diff_buf,
	})
end

vim.api.nvim_create_user_command("Xdiff", xdiff, {
	nargs = "?",
})
