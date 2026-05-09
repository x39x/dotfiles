--PLUG:  mtm
local cmd = vim.api.nvim_create_user_command
local del_cmd = vim.api.nvim_del_user_command
cmd("Mtm", function()
	del_cmd("Mtm")
	require("markdown-table-mode").setup()
	vim.cmd("Mtm")
end, {})

--PLUG:  leet
cmd("Leet", function()
	del_cmd("Leet")
	require("leetcode").setup({
		cn = {
			enabled = true,
		},
		injector = {
			["python3"] = {
				before = true,
			},
			["cpp"] = {
				before = { "#include <bits/stdc++.h>" },
			},
		},
		picker = { provider = "fzf-lua" },
	})
	vim.cmd("Leet")
end, {})
