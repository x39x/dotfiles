vim.pack.add({
	"https://github.com/goolord/alpha-nvim",
	"https://github.com/nvimdev/indentmini.nvim",
	"https://github.com/rebelot/heirline.nvim",
	"https://github.com/lewis6991/satellite.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/lewis6991/gitsigns.nvim",
})

-- --PLUG: alpha
require("alpha").setup({
	layout = {
		{ type = "padding", val = 6 },
		{
			type = "text",
			val = require("ui.header").a,
			opts = {
				position = "center",
				hl = "AlphaHeader",
			},
		},
	},
	opts = {
		margin = 5,
	},
})

require("indentmini").setup({
	exclude = {
		"help",
		"Trouble",
		"alpha",
		"typst",
		"markdown",
	},
})

--PLUG: todo
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

require("nvim-highlight-colors").setup()

require("ui.39line")
require("ui.colorscheme").set()
