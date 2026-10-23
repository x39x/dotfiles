vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/junegunn/vim-easy-align",
	"https://github.com/ibhagwan/fzf-lua",
	-- treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	-- file explor
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
	-- ui
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/rebelot/heirline.nvim",
	"https://github.com/lewis6991/satellite.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	-- lsp
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	-- tools
	"https://github.com/folke/flash.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",

	"https://github.com/esmuellert/codediff.nvim",
	-- "https://github.com/windwp/nvim-autopairs",
	-- "https://github.com/windwp/nvim-ts-autotag",
	-- "https://github.com/saghen/blink.lib",
	-- "https://github.com/saghen/blink.cmp"
})
local keymap = vim.keymap.set

-- align
keymap({ "n", "x" }, "<leader>aa", "<Plug>(EasyAlign)", { desc = "Align" })
-- mason
require("mason").setup({
	ui = {
		backdrop = 100,
		border = "double",
	},
})

-- "<buffer>", "<nowait>", "<silent>", "<script>", "<expr>" and
-- "<unique>" can be used in any order.  They must appear right after the

-- require("nvim-autopairs").setup({
-- 	disable_filetype = { "TelescopePrompt", "fzf" },
-- 	enable_check_bracket_line = false,
-- })
-- require("nvim-ts-autotag").setup()

-- yazi
require("yazi").setup({
	open_for_directories = true,
	yazi_floating_window_border = "double",
	highlight_hovered_buffers_in_same_directory = false,
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
keymap("n", "<leader>m", require("yazi").yazi)
keymap("n", "<leader>n", function()
	local cwd = vim.uv.cwd()
	if cwd ~= nil then
		require("yazi").yazi({}, cwd)
	end
end)

-- flash
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
keymap({ "n" }, "f", flash.jump)
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
end)

-- gitsigns
require("gitsigns").setup({
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
	},
	signs_staged = {
		add = { text = "┃" },
		change = { text = "┃" },
	},
	signs_staged_enable = true,
	-- signcolumn = false,
})

-- diff
require("codediff").setup({
	highlights = {
		line_insert = "DiffAdd",
		line_delete = "DiffDelete",
		char_insert = "CodeDiffCharInsert",
		char_delete = "CodeDiffCharDelete",
	},
})
vim.api.nvim_create_autocmd("User", {
	pattern = "CodeDiffOpen",
	group = vim.api.nvim_create_augroup("codediffopen", { clear = true }),
	callback = function()
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			vim.wo[win].cursorline = false
		end
	end,
	desc = "Disable cursorline in diff windows",
})

-- indent
require("ibl").setup({
	indent = {
		char = "│",
		tab_char = "│",
		highlight = "Whitespace",
	},
	scope = { enabled = false },
})

-- todo
require("todo-comments").setup({
	keywords = {
		FIX = { icon = "󰨰 ", color = "#DC2626", alt = { "BUG" } },
		TEST = { icon = " ", color = "#AF7AC5", alt = { "FUNC", "PLUG" } },
		WARN = { icon = " ", color = "#C0392B", alt = { "ISSUE" } },
		TODO = { icon = " ", color = "#DC2626", alt = { "XXX", "DEBUG" } },
		DONE = { icon = " ", color = "#1957F3" },
		NOTE = { icon = "", color = "#10B981", alt = { "INFO", "TIPS" } },
	},
	merge_keywords = false,
})

-- scrollbar
require("satellite").setup({
	winblend = 100,
	excluded_filetypes = {
		"quickfix",
	},
	handlers = {
		gitsigns = {
			enable = false,
		},
	},
})

require("nvim-highlight-colors").setup({
	render = "background",
	enable_named_colors = false,
	enable_tailwind = true,

	exclude_buffer = function(bufnr)
		local allowed = {
			"lua",
			"css",
			"html",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		}
		return not vim.tbl_contains(allowed, vim.bo[bufnr].filetype)
	end,
})

require("base.conform")
require("base.treesitter")
require("base.fzf")
require("base.39line")
-- require("base.cmp")
