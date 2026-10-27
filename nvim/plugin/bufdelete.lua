---@class bufutils.BufdeleteOpt
---@field buf? number
---@field filter? boolean|fun(buf: number): boolean

---@param opts? bufutils.BufdeleteOpt
local function bufdelete(opts)
	opts = opts or {}
	if type(opts.filter) == "function" then
		for _, b in ipairs(vim.tbl_filter(opts.filter, vim.api.nvim_list_bufs())) do
			if vim.bo[b].buflisted then
				bufdelete({ buf = b, filter = false })
			end
		end
		return
	end

	local bufnr = opts.buf or vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_valid(bufnr) then
		vim.notify("bufremove: invalid bufnr", vim.log.levels.WARN)
		return
	end

	if vim.bo[bufnr].modified then
		vim.notify(string.format("bufremove: buffer %d has unsaved changes!", bufnr), vim.log.levels.WARN)
		return
	end

	-- Get the most recently used listed buffer that is not the one being deleted,
	local info = vim.fn.getbufinfo({ buflisted = 1 })
	info = vim.tbl_filter(function(b)
		return b.bufnr ~= bufnr
	end, info)
	table.sort(info, function(a, b)
		return a.lastused > b.lastused
	end)
	local new_buf = info[1] and info[1].bufnr or vim.api.nvim_create_buf(true, false)

	-- replace the buffer in all windows showing it,
	-- trying to use the alternate buffer if possible
	vim.tbl_map(function(winnr)
		if not vim.api.nvim_win_is_valid(winnr) then
			vim.notify("bufremove: invalid winnr", vim.log.levels.WARN)
			return false
		end

		local win_buf = new_buf

		vim.api.nvim_win_call(winnr, function() -- Try using alternate buffer
			local alt = vim.fn.bufnr("#")
			win_buf = alt >= 0 and alt ~= bufnr and vim.bo[alt].buflisted and alt or win_buf
		end)
		vim.api.nvim_win_set_buf(winnr, win_buf)
		return true
	end, vim.fn.win_findbuf(bufnr))

	if vim.api.nvim_buf_is_valid(bufnr) then
		local ei = vim.o.eventignore
		vim.o.eventignore = "DiagnosticChanged"
		-- bdelete  保留 ctrl-o 跳转列表等缓存
		-- bwipeout 完全弹出
		---@diagnostic disable-next-line
		pcall(vim.cmd, "bwipeout! " .. bufnr)
		vim.o.eventignore = ei
	end
end

vim.api.nvim_create_user_command("Bufdelete", function(opts)
	local filters = {
		a = function() -- all
			return true
		end,
		o = function(b) -- others: except the current one
			return b ~= vim.api.nvim_get_current_buf()
		end,
		invisible = function(b) -- delete all invisible buffers
			return vim.fn.bufwinnr(b) == -1
		end,
	}
	bufdelete({ filter = filters[opts.args] or false })
end, {
	nargs = "?",
	complete = function()
		return { "a", "o", "invisible" }
	end,
})

vim.keymap.set({ "n" }, "<leader>w", bufdelete, { noremap = true, silent = true })
