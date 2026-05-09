local M = {}

M.launch = function()
	local keymap = require("dapconfig.dap.keymap")
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.bo[buf].filetype
	if
		vim.tbl_contains({
			"vue",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		}, ft)
	then
		ft = "js"
	end

	local ok, dap_config = pcall(require, "dapconfig.dap." .. ft)

	if ok then
		dap_config()
		keymap.set(buf)
		vim.g.nvim_dap_enabled = true
		vim.notify("Launch DAP for " .. ft, vim.log.levels.INFO)
	else
		vim.notify("NO DAP for " .. ft, vim.log.levels.WARN)
	end
end

M.terminate = function()
	local dap = require("dap")

	if vim.g.nvim_dap_enabled ~= true then
		return
	end

	local keymap = require("dapconfig.dap.keymap")
	local buf = vim.api.nvim_get_current_buf()

	dap.terminate()
	dap.clear_breakpoints()
	keymap.clear(buf)
	-- true: https://github.com/igorlfs/nvim-dap-view/blob/main/lua/dap-view.lua#L31
	require("dap-view").close(true)
	vim.g.nvim_dap_enabled = nil
	vim.notify("Terminate DAP ", vim.log.levels.INFO)
end

M.view = function()
	if vim.g.nvim_dap_enabled == true then
		require("dap-view").toggle()
	end
end

return M
