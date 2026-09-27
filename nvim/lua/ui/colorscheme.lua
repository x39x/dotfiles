local M = {}

local dark_mode_cache = vim.fn.expand("$HOME/.local/state/user/dark_mode")

local function load_cache()
	local f = io.open(dark_mode_cache, "r")
	if not f then
		return ""
	end
	local content = f:read("*l")
	f:close()
	return content:lower():gsub("%s+", "")
end

M.set = function()
	if load_cache() == "true" then
		-- vim.cmd.colorscheme("39dark")
		vim.cmd.colorscheme("monokai")
	else
		vim.cmd.colorscheme("39light")
	end
end

return M
