vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/junegunn/vim-easy-align",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/ibhagwan/fzf-lua",
	-- treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	-- file explor
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/mikavilpas/yazi.nvim",
	-- ui
	"https://github.com/lukas-reineke/indent-blankline.nvim",
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
}, { confirm = false })

local keymap = vim.keymap.set
local usercmd = vim.api.nvim_create_user_command

------------------------------------------------------------------
--- search / format  / treesitter
------------------------------------------------------------------

require("plugin.conform")
require("plugin.treesitter")
require("plugin.fzf")

------------------------------------------------------------------
--- tools
------------------------------------------------------------------

--- align
keymap({ "n", "x" }, "<leader>aa", "<Plug>(EasyAlign)", { desc = "Align" })

--- autopairs
require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "fzf" },
	enable_check_bracket_line = false,
})

--- mason
require("mason").setup({
	ui = {
		backdrop = 100,
		border = "double",
	},
})

--- yazi
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

--- flash
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
	-- setreg adds ad invisible "\V"
	local prompt_len = string.len(vim.fn.getreg("/"):gsub("^\\V", ""))
	vim.api.nvim_win_set_cursor(0, { row, col + prompt_len - 1 })
	vim.fn.setreg("/", "")
end)

--- gitsigns
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
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			keymap(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)
		map("n", "<leader>gq", gitsigns.setqflist)
		map("n", "<leader>gQ", function()
			gitsigns.setqflist("all")
		end)
		map("n", "<leader>gp", gitsigns.preview_hunk_inline)
		map("n", "<leader>gb", gitsigns.toggle_current_line_blame)

		map("n", "<leader>gl", gitsigns.toggle_signs)
		map("n", "<leader>gL", gitsigns.toggle_linehl)
	end,
})

------------------------------------------------------------------
--- ui
------------------------------------------------------------------

--- indent line
require("ibl").setup({
	indent = {
		char = "│",
		tab_char = "│",
		highlight = "Whitespace",
	},
	scope = { enabled = false },
})

--- todo
require("todo-comments").setup({
	keywords = {
		NOTE = { icon = "", color = "#10B981", alt = { "TIPS" } },
		TODO = { icon = " ", color = "#DC2626", alt = { "XXX", "FIX" } },
		TEST = { icon = " ", color = "#1957F3", alt = { "DONE", "PASS" } },
		WARN = { icon = " ", color = "#FD971E", alt = { "WARNING", "PERF" } },
		HACK = { icon = " ", color = "#AF7AC5", alt = { "FUNC", "PLUG" } },
	},
	merge_keywords = false,
})

--- scrollbar
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

--- show color
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

------------------------------------------------------------------
--- dap
------------------------------------------------------------------

vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/igorlfs/nvim-dap-view",
}, { load = false, confirm = false })

usercmd("PaDap", function()
	vim.cmd.packadd("nvim-dap-view")
	vim.cmd.packadd("nvim-dap")
	require("plugin.dapconfig")
end, {})

------------------------------------------------------------------
--- unload
------------------------------------------------------------------
vim.pack.add({
	"https://github.com/windwp/nvim-ts-autotag",
	-- "https://github.com/saghen/blink.lib",
	-- "https://github.com/saghen/blink.cmp",
}, { load = false, confirm = false })

usercmd("PaAutotag", function()
	vim.cmd.packadd("nvim-ts-autotag")
	require("nvim-ts-autotag").setup()
end, {})

-- usercmd("PaBlink", function()
-- 	vim.cmd.packadd("blink.lib")
-- 	vim.cmd.packadd("blink.cmp")
-- 	require("plugin.cmp")
-- end, {})
