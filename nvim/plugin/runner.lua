------------------------------------------------------------------
--- terminal cache
------------------------------------------------------------------

local terminal_channel

local function cache_current_terminal()
    local channel = vim.bo.channel
    if not channel or channel <= 0 then
        vim.notify("Current buffer has no terminal channel", vim.log.levels.WARN)
        return
    end

    terminal_channel = channel
    vim.notify("channel: " .. tostring(channel), vim.log.levels.INFO)
end

local function run_cached_terminal()
    if not terminal_channel then
        return false
    end

    local keys = vim.api.nvim_replace_termcodes("<C-u><C-p><CR>", true, false, true)
    local ok, err = pcall(vim.api.nvim_chan_send, terminal_channel, keys)
    if ok then
        return true
    end

    terminal_channel = nil
    vim.notify("Cached terminal is unavailable; cache cleared: " .. tostring(err), vim.log.levels.WARN)
    return false
end

local function clear_cache()
    terminal_channel = nil
    vim.notify("Runner cache cleared", vim.log.levels.INFO)
end

------------------------------------------------------------------
--- runners
------------------------------------------------------------------

local function overseer_run()
    local ok, overseer = pcall(require, "overseer")
    if not ok then
        vim.notify("Overseer is unavailable", vim.log.levels.WARN)
        return
    end

    local task_list = require("overseer.task_list")
    local tasks = overseer.list_tasks({
        status = {
            overseer.STATUS.SUCCESS,
            overseer.STATUS.FAILURE,
            overseer.STATUS.CANCELED,
        },
        sort = task_list.sort_finished_recently,
    })

    if #tasks > 0 then
        overseer.run_action(tasks[1], "restart")
    else
        vim.cmd.OverseerRun()
    end
end

local function open_in_browser()
    local file = vim.api.nvim_buf_get_name(0)
    if file ~= "" then
        vim.cmd("silent !open -a firefox " .. vim.fn.shellescape(file))
    end
end

local function run()
    if vim.bo.buftype == "terminal" then
        cache_current_terminal()
        return
    end

    if run_cached_terminal() then
        return
    end

    local ft = vim.bo.filetype
    if ft == "lua" then
        vim.cmd.source("%")
    elseif ft == "markdown" or ft == "html" then
        open_in_browser()
    else
        overseer_run()
    end
end

------------------------------------------------------------------
--- keymaps
------------------------------------------------------------------

local keymap = vim.keymap.set

keymap("n", "<leader>-", run)
keymap("n", "<leader>_", clear_cache)
keymap("n", "<C-,>", function()
    local ok, overseer = pcall(require, "overseer")
    if not ok then
        vim.notify("Overseer is unavailable", vim.log.levels.WARN)
        return
    end

    local tasks = overseer.list_tasks()

    if #tasks > 0 then
        require("overseer.commands")._toggle({ bang = true, direction = "bottom" })
    end
end)
