--PLUG:  mtm

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		require("markdown-table-mode").setup()
	end,
})

--PLUG:  leet
require("leetcode").setup({
	cn = {
		enabled = true,
		translator = false,
	},
	lang = "golang",
	description = {
		width = "43%",
		position = "right",
	},
	injector = {
		["cpp"] = {
			imports = function()
				return { "#include <bits/stdc++.h>", "using namespace std;" }
			end,
			after = "int main() {}",
		},
	},
	picker = { provider = "fzf-lua" },
	keys = {},
})
