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
					return "none"
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

require("fzf-lua").setup({
	{ "hide" },
	actions = {
		files = {
			true,
		},
	},
	winopts = ivy,
	fzf_colors = {
		["fg+"] = { "fg", "FzfFgPlus" },
		["bg+"] = { "bg", "FzfBgPlus" },
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
local keymap_opts = require("utils.keymap_opts")
keymap("n", "<leader>ff", FzfLua.files, keymap_opts({ desc = "Fzflua files" }))
keymap("n", "<leader>fh", FzfLua.oldfiles, keymap_opts({ desc = "Fzflua oldfiles" }))
keymap("n", "<leader>fp", FzfLua.zoxide, keymap_opts({ desc = "Fzflua zoxide" }))
keymap("n", "<Leader>fr", FzfLua.builtin, keymap_opts({ desc = "Fzflua builtin" }))
keymap("n", "<leader>fl", FzfLua.live_grep, keymap_opts({ desc = "Fzflua live_grep" }))
keymap("n", "<Leader>fs", FzfLua.colorschemes, keymap_opts({ desc = "Fzflua colorschemes" }))
keymap("n", "<Leader>fm", FzfLua.marks, keymap_opts({ desc = "Fzflua marks" }))
keymap("n", "<Leader>fe", FzfLua.resume, keymap_opts({ desc = "Fzflua resume" }))

require("fzf-lua").register_ui_select({
	winopts = dropdown(),
})
