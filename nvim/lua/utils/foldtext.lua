return function()
	local start_line = vim.v.foldstart
	local end_line = vim.v.foldend
	local lines = end_line - start_line + 1

	local text = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, true)[1] or ""
	text = text:gsub("\t", string.rep(" ", vim.bo[0].tabstop))
	return text .. "   󰁂 " .. lines .. " lines "
end
