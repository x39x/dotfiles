local M = {}

local dark_mode_cache = vim.fn.expand("~/.cache/39sys/dark_mode")

local function load_cache()
        local f = io.open(dark_mode_cache, "r")
        if not f then
                return ""
        end
        local content = f:read("*l")
        f:close()
        return content:lower():gsub("%s+", "")
end

local is_dark_mode = function()
        return load_cache() == "true"
end

M.set = function()
        if is_dark_mode() then
                vim.cmd.colorscheme("39dark")
        else
                vim.cmd.colorscheme("39light")
        end
end

return M
