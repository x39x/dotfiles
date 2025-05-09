local M = {}
local opts = {}
local make_picker = require("utils.telescope_tools").custom_picker

opts.title = "Zoxide"
opts.cmd = "zoxide query -ls"
opts.entry_maker = function(item)
        local trimmed = string.gsub(item, "^%s*(.-)%s*$", "%1")
        local item_path = string.gsub(trimmed, "^[^%s]* (.*)$", "%1")
        local score = tonumber(string.gsub(trimmed, "^([^%s]*) .*$", "%1"), 10)

        return {
                value = item_path,
                ordinal = item_path,
                display = item_path,
                z_score = score,
                path = item_path,
        }
end

opts.default_mappings = {
        action = function(selection)
                vim.schedule(function()
                        if vim.fn.isdirectory(selection.path) == 1 then
                                vim.cmd.cd(selection.path)
                                vim.notify(selection.path, vim.log.levels.INFO)
                        else
                                vim.notify(selection.path .. " ERROR", vim.log.levels.WARN)
                        end
                end)
        end,
}
opts.extra_mappings = {
        ["<C-o>"] = {
                keepinsert = true,
                action = function(selection)
                        require("telescope.builtin").find_files({ cwd = selection.path })
                end,
        },
        ["<C-t>"] = {
                action = function(selection)
                        vim.schedule(function()
                                if vim.fn.isdirectory(selection.path) == 1 then
                                        vim.cmd.lcd(selection.path)
                                        vim.notify(selection.path, vim.log.levels.INFO)
                                else
                                        vim.notify(selection.path .. " ERROR", vim.log.levels.WARN)
                                end
                        end)
                end,
        },
}

M.zoxide = function()
        make_picker(opts)
end
return M
