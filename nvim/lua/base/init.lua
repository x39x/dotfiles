vim.pack.add({
	-- lib
	"https://github.com/nvim-tree/nvim-web-devicons",
	-- edit
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/junegunn/vim-easy-align",
	-- file explor / search
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
	-- treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/rafamadriz/friendly-snippets",
	-- tools
	"https://github.com/folke/flash.nvim",
	"https://github.com/nvim-mini/mini.bufremove",
	"https://github.com/Kicamon/markdown-table-mode.nvim",

	"https://github.com/NeogitOrg/neogit",
	"https://github.com/esmuellert/codediff.nvim",

	-- "https://github.com/kawre/leetcode.nvim",
	-- "https://github.com/MunifTanjim/nui.nvim",
	-- -- blink.cmp
	-- "https://github.com/saghen/blink.lib",
	-- {
	-- 	src = "https://github.com/saghen/blink.cmp",
	-- 	version = "main",
	-- },
})

local keymap = vim.keymap.set
local keymap_opts = require("utils.keymap_opts")

keymap({ "n", "v" }, "<leader>aa", "<Plug>(EasyAlign)", keymap_opts({ desc = "Align" }))

require("mini.bufremove").setup()

require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "fzf" },
	enable_check_bracket_line = false,
})
require("nvim-autopairs").get_rules("'")[1].not_filetypes = { "scheme", "lisp" }
require("nvim-autopairs").get_rules("`")[1].not_filetypes = { "typst" }

require("yazi").setup({
	open_for_directories = true,
	yazi_floating_window_border = "double",
	keymaps = {
		open_file_in_horizontal_split = "<c-s>",
		grep_in_directory = "<c-x>",
		replace_in_directory = false,
		change_working_directory = "<c-g>",
	},
	integrations = {
		grep_in_directory = "fzf-lua",
		grep_in_selected_files = "fzf-lua",
	},
})
keymap("n", "<leader>N", require("yazi").yazi, keymap_opts({ desc = "yazi" }))
keymap("n", "<leader>n", function()
	local cwd = vim.uv.cwd()
	if cwd ~= nil then
		require("yazi").yazi({}, cwd)
	end
end, keymap_opts({ desc = "yazi" }))

-- PLUG: deffview
require("codediff").setup({
	highlights = {
		line_insert = "DiffAdd",
		line_delete = "DiffDelete",
		char_insert = "CodeDiffCharInsert",
		char_delete = "CodeDiffCharDelete",
	},
})

-- PLUG: flash
local flash = require("flash")
flash.setup({
	labels = "asdfghjkl;weruiopzxcvnm",
	modes = {
		char = {
			enabled = false,
		},
		search = {
			enabled = false,
		},
	},
	highlight = {
		backdrop = false,
	},
	prompt = {
		enabled = false,
	},
})
keymap({ "n" }, "f", flash.jump, keymap_opts({ desc = "flash jump(n)" }))
keymap({ "o", "x" }, "f", function()
	local prev_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	flash.jump({ jump = { register = true } })
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))

	-- backward jump, do nothing
	if prev_row > row then
		vim.fn.setreg("/", "")
		return
	end
	-- forward jump, move to prompt end
	local prompt_len = string.len(vim.fn.getreg("/"):gsub("^\\V", ""))
	vim.api.nvim_win_set_cursor(0, { row, col + prompt_len - 1 })
	vim.fn.setreg("/", "")
end, keymap_opts({ desc = "flash jump(ov)" }))

require("base.treesitter")
require("base.fzf")
-- require("base.extra")
-- require("base.cmp")
