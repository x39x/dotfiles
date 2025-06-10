local M = {}
local isdark_cache_file = vim.fn.stdpath("cache") .. "/is_dark"

local uv = vim.uv or vim.loop
local os_uname = uv.os_uname()
if string.match(os_uname.release, "WSL") then
        M.system = "WSL"
elseif string.match(os_uname.release, "orbstack") then
        M.system = "OrbStack"
else
        M.system = os_uname.sysname
end

local function get_mac_mode()
        local is_dark_mode = false
        local cmd = {
                "defaults",
                "read",
                "-g",
                "AppleInterfaceStyle",
        }
        if M.system == "OrbStack" then
                cmd = vim.list_extend({ "mac" }, cmd)
        end
        local result = vim.system(cmd):wait()

        if result.code ~= 0 then
                return is_dark_mode
        end

        local stdout = result.stdout and result.stdout:lower():gsub("%s+", "")
        if stdout == "dark" then
                is_dark_mode = true
        end
        return is_dark_mode
end

local function save_cache(is_dark)
        local f = io.open(isdark_cache_file, "w")
        if not f then
                return
        end
        local mode = is_dark and "true" or "false"
        f:write(mode)
        f:close()
end

M.cache = function()
        local is_dark = false

        if M.system == "Darwin" or M.system == "OrbStack" then
                is_dark = get_mac_mode()
        elseif M.system == "Linux" then
                is_dark = true
        elseif M.system == "Windows_NT" or M.system == "WSL" then
                is_dark = true
        end
        save_cache(is_dark)
end

local function load_cahce()
        local f = io.open(isdark_cache_file, "r")
        if not f then
                return ""
        end
        local content = f:read("*l")
        f:close()
        return content:lower():gsub("%s+", "")
end

local is_dark_mode = function()
        return load_cahce() == "true"
end

M.set = function()
        if is_dark_mode() == true then
                vim.cmd.colorscheme("39dark")
        else
                vim.cmd.colorscheme("39light")
        end
end
return M
