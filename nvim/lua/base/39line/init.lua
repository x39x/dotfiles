local utils = require("heirline.utils")

local function setup_colors()
	return {
		heirline_diagnostic_error = utils.get_highlight("DiagnosticError").fg or "",
		heirline_diagnostic_warn = utils.get_highlight("DiagnosticWarn").fg or "",
		heirline_diagnostic_info = utils.get_highlight("DiagnosticInfo").fg or "",
		heirline_diagnostic_hint = utils.get_highlight("DiagnosticHint").fg or "",

		heirline_git_branch = utils.get_highlight("Keyword").fg or "",
		heirline_git_added = utils.get_highlight("diffAdded").fg or "",
		heirline_git_removed = utils.get_highlight("diffRemoved").fg or "",
		heirline_git_modified = utils.get_highlight("diffChanged").fg or "",

		heirline_filename = utils.get_highlight("Keyword").fg or "",
		heirline_workdir = utils.get_highlight("Keyword").fg or "",
		heirline_buftype = utils.get_highlight("Keyword").fg or "",
		heirline_A = utils.get_highlight("HeirlineA").fg or utils.get_highlight("Keyword").fg or "",
		heirline_B = utils.get_highlight("HeirlineB").fg or utils.get_highlight("Keyword").fg or "",
	}
end

local heirline = require("heirline")
heirline.load_colors(setup_colors)

local statusline = require("base.39line.statusline")
local tabline = require("base.39line.tabline")

heirline.setup({
	colors = setup_colors(),
	statusline = statusline,
	tabline = tabline,
})

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("ColorScheme", {
	group = augroup("heirline", { clear = true }),
	callback = function()
		utils.on_colorscheme(setup_colors)
	end,
})

autocmd("BufEnter", {
	group = augroup("matsu.heirline.git", { clear = true }),
	callback = function(args)
		local bufnr = args.buf

		if not vim.bo[bufnr].buflisted then
			return
		end
		if vim.tbl_contains({ "quickfix", "nofile", "terminal" }, vim.bo[bufnr].buftype) then
			vim.b[bufnr].is_git_repo = false
			return
		end
		if vim.tbl_contains({ "fzf" }, vim.bo[bufnr].filetype) then
			return
		end

		local file_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h")
		local result = vim.system({ "git", "-C", file_path, "rev-parse", "--is-inside-work-tree" }, { text = true }):wait()
		local git_status = result.stdout and vim.split(result.stdout, "\n")[1] or nil
		vim.b[bufnr].is_git_repo = git_status == "true"
	end,
})
