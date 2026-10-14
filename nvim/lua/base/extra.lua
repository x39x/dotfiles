vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	group = vim.api.nvim_create_augroup("markdowntablemode", { clear = true }),
	callback = function()
		require("markdown-table-mode").setup()
	end,
	desc = "markdown table mode",
})
