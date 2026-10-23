local ignore_filetype = { "gitcommit", "gitrebase", "svn", "NvimTree", "fzf" }

local function restore_cursor()
	-- stop if not a normal buffer (common files buftyle is "")
	if vim.bo.buftype ~= "" then
		return
	end

	-- stop if filetype is ignored
	if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
		return
	end

	-- stop if line is already specified (like during start with `nvim file +num`)
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	if cursor_line > 1 then
		return
	end

	local mark_position = vim.api.nvim_buf_get_mark(0, '"')
	local mark_row, mark_col = mark_position[1], mark_position[2]

	-- stop if can't restore proper line for some reason
	local current_line_count = vim.api.nvim_buf_line_count(0)
	if not (1 <= mark_row and mark_row <= current_line_count) then
		return
	end
	-- normal! g`"zv
	vim.api.nvim_win_set_cursor(0, { mark_row, mark_col })
	vim.cmd.normal("zz")
end

-- create autocommand which runs once on `FileType` for every new buffer
-- file type is set after "BufReadPre", ignore_filetype need
vim.api.nvim_create_autocmd("BufReadPre", {
	group = vim.api.nvim_create_augroup("user.lastplace", { clear = true }),
	callback = function(args)
		vim.api.nvim_create_autocmd("FileType", {
			buffer = args.buf,
			once = true,
			callback = function()
				restore_cursor()
			end,
		})
	end,
})
