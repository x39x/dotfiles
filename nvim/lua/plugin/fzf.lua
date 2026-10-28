local ivy = {
	title = false,
	title_flags = false,
	height = 0.39,
	width = 1,
	row = 1,
	col = 0,
	backdrop = 100,
	border = { "─", "─", "─", " ", " ", " ", " ", " " },
	preview = {
		border = function(_, m)
			if m.type == "fzf" then
				return "none"
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

local fzflua = require("fzf-lua")
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

	-- picker option
	builtin = { winopts = dropdown() },
	oldfiles = { previewer = false },
	tmux_buffers = { previewer = false },

	keymaps = {
		winopts = { preview = { layout = "horizontal" } },
	},

	files = {
		git_icons = true,
		previewer = false,
		cwd_prompt = false,
	},

	colorschemes = {
		live_preview = false,
		winopts = dropdown(),
	},

	buffers = {
		previewer = false,
		winopts = dropdown(),
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

	grep = {
		rg_glob = true,
		glob_flag = "",
		glob_separator = "",
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

local keymap = vim.keymap.set
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
			vim.api.nvim_set_hl(0, "FzfLuaPreviewBorder", { link = "Whitespace" })
			-- vim.api.nvim_set_hl(0, "FzfSelectedFg", { link = "Added" })
			-- vim.api.nvim_set_hl(0, "FzfSelectedBg", { link = "Normal" })
		end
	end,
})
