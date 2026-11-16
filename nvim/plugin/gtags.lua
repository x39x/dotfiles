local M = {}

local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.WARN)
end

-- Parse global -ax / -axr output.
local function parse_output(stdout)
    local results = {}

    for line in stdout:gmatch("[^\r\n]+") do
        local symbol, lnum, file, text = line:match("^(%S+)%s+(%d+)%s+(%S+)%s*(.*)$")

        if symbol and lnum and file then
            results[#results + 1] = {
                symbol = symbol,
                lnum = tonumber(lnum),
                filename = file,
                text = text,
            }
        end
    end

    return results
end

-- Run global and parse results.
local function search(args, word, callback)
    vim.system({ "global", unpack(args), word }, { text = true }, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                notify("global failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
                return
            end

            local results = parse_output(result.stdout or "")

            if #results == 0 then
                notify("No results found for: " .. word)
                return
            end

            callback(results)
        end)
    end)
end

-- Open a location.
local function open_location(item)
    vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
    vim.api.nvim_win_set_cursor(0, { item.lnum, 0 })
end

-- Show results in Snacks Picker.
local function picker_results(results, title)
    local entries = {}

    for _, item in ipairs(results) do
        entries[#entries + 1] = {
            file = item.filename,
            filename = item.filename,
            pos = { item.lnum, 0 },
            line = item.text,
            text = string.format("%s:%d: %s", item.filename, item.lnum, item.text),
        }
    end

    if #entries == 1 then
        open_location(entries[1])
        return
    end

    Snacks.picker.pick({
        title = title,
        prompt = title .. "> ",
        items = entries,
        format = "file",
        preview = "file",
        confirm = function(picker, item)
            picker:close()

            if item then
                vim.schedule(function()
                    open_location(item)
                end)
            end
        end,
    })
end

function M.goto_definition()
    local word = vim.fn.expand("<cword>")

    if word == "" then
        return
    end

    search({ "-ax" }, word, function(results)
        if #results == 1 then
            open_location(results[1])
        else
            picker_results(results, "Definitions")
        end
    end)
end

function M.goto_references()
    local word = vim.fn.expand("<cword>")

    if word == "" then
        return
    end

    search({ "-axr" }, word, function(results)
        picker_results(results, "References")
    end)
end

return M
