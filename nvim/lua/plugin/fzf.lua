local fzflua = require("fzf-lua")
local keymap = vim.keymap.set

local ivy = {
	title = false,
	title_flags = false,
	height = 0.39,
	width = 1,
	row = 1,
	col = 0,
	backdrop = 100,
	border = { "─", "─", "─", " ", " ", " ", " ", " " },
	treesitter = { enabled = false },
	preview = {
		border = function(_, m)
			if m.type == "fzf" then
				-- see man fzf，none 会无边距，设置border并将颜色设置为背景色
				return "sharp"
			else
				return { "─", "─", "─", " ", " ", " ", " ", " " }
			end
		end,
		layout = "horizontal",
		horizontal = "right:50%",
		title = false,
		scrollbar = false,
		winopts = {
			cursorline = false,
		},
	},
}
local dropdown = function(opts)
	opts = opts or {}
	local winopts = {
		title_flags = false,
		height = 0.39,
		width = 0.5,
		row = 0.4,
		col = 0.5,
		backdrop = 100,
		border = { "─", "─", "─", " ", "─", "─", "─", " " },
		treesitter = { enabled = false },
		preview = {
			border = function(_, m)
				if m.type == "fzf" then
					-- see man fzf，none 会无边距，设置border并将颜色设置为背景色
					return "sharp"
				else
					return { "─", "─", "─", " ", "─", "─", "─", " " }
				end
			end,
			layout = "horizontal",
			horizontal = "right:45%",
			winopts = {

				number = false,
			},
		},
	}
	return vim.tbl_deep_extend("force", winopts, opts)
end

fzflua.setup({
	--:h fzf-lua-available-profiles
	{ "hide" },
	actions = {
		files = {
			true,
		},
	},
	winopts = ivy,
	fzf_colors = {
		["border"] = { "bg", "Normal" },
		["fg+"] = { "fg", "FzfSelectedFg" },
		["bg+"] = { "bg", "FzfSelectedBg" },
		-- ["hl"] = { "fg", "FzfMatched" },
		-- ["hl+"] = { "fg", "FzfMatched" },
		-- ["marker"] = { "fg", "FzfMatched" },
	},
	hls = {
		live_prompt = "Normal",
		live_sym = "DiagnosticError",
	},

	--  disable default config
	tmux_buffers = {
		previewer = false,
	},
	highlights = {
		fzf_colors = false,
	},
	search_history = {
		fzf_colors = false,
	},
	command_history = {
		fzf_colors = false,
	},
	zoxide = {
		winopts = dropdown({
			preview = {
				border = "none",
				horizontal = "right:0%",
				vertical = "down:0%",
			},
		}),
	},

	--  my picker config
	builtin = {
		winopts = dropdown(),
	},
	files = {
		git_icons = true,
		previewer = false,
		cwd_prompt = false,
	},
	oldfiles = {
		previewer = false,
	},
	colorschemes = {
		live_preview = false,
		winopts = dropdown(),
	},
	buffers = {
		previewer = false,
		winopts = dropdown(),
	},
	keymaps = {
		winopts = {
			preview = { layout = "horizontal" },
		},
	},

	grep = {
		rg_glob = true,
		glob_flag = "",
		glob_separator = "",
		rg_opts = table.concat({
			"--no-heading",
			"--line-number",
			"--column",
			"--max-columns=4096",
			"--smart-case",
			"--color=always",
			"--colors='match:fg:190,0,47'",
			"-e ",
		}, " "),
		rg_glob_fn = function(query, _)
			local regex, flags = query:match("^(.-)%s%-%-%s(.*)$")
			return (regex or query), flags
		end,
		winopts = {
			preview = {
				winopts = {
					number = true,
				},
			},
		},
	},
})

keymap("n", "<leader>ff", FzfLua.files)
keymap("n", "<leader>fh", FzfLua.oldfiles)
keymap("n", "<leader>fp", FzfLua.zoxide)
keymap("n", "<Leader>fr", FzfLua.builtin)
keymap("n", "<leader>fl", FzfLua.live_grep)
keymap("n", "<Leader>fs", FzfLua.colorschemes)
keymap("n", "<Leader>fm", FzfLua.marks)
keymap("n", "<Leader>fe", FzfLua.resume)
keymap("n", "<Leader>b", FzfLua.buffers)

fzflua.register_ui_select({ winopts = dropdown() })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("matsu.fzflua", { clear = true }),
	callback = function()
		if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "FzfSelectedFg" })) then
			vim.api.nvim_set_hl(0, "FzfLuaTitle", { link = "Whitespace" })
			vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "Whitespace" })
			vim.api.nvim_set_hl(0, "FzfSelectedFg", { link = "Added" })
			vim.api.nvim_set_hl(0, "FzfSelectedBg", { link = "Normal" })
		end
	end,
})
