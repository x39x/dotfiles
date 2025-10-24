local M = {}

local function notify_err(msg)
        vim.notify(msg, vim.log.levels.ERROR)
end

-- get tmux session

--PLUG: send cmd to window
M.window = function()
        local session_result = vim.system({ "tmux", "display-message", "-p", "#S" }, { text = true }):wait()
        if session_result.code ~= 0 then
                notify_err("ERROR in tmux_run.lua: Failed to get tmux session")
                return
        end
        local session = vim.trim(session_result.stdout)
        -- list all tmux window
        local list_result = vim.system({ "tmux", "list-windows", "-F", "#{window_name}" }, { text = true }):wait()
        if list_result.code ~= 0 then
                notify_err("ERROR in tmux_run.lua: M.window 1")
                return
        end

        -- check if runner window exist
        local window_exists = false
        for line in list_result.stdout:gmatch("[^\r\n]+") do
                if vim.trim(line) == "runner" then
                        window_exists = true
                        break
                end
        end

        -- if runner doesn't exist, create a runner window
        if not window_exists then
                local new_result = vim.system({ "tmux", "new-window", "-n", "runner" }):wait()
                if new_result.code ~= 0 then
                        notify_err("ERROR in tmux_run.lua: M.window 2")
                        return
                end
        end

        -- send run cmd
        vim.system({ "tmux", "send-keys", "-t", session .. ":runner", "make", "C-j" }):wait()
        vim.system({ "tmux", "select-window", "-t", session .. ":runner" }):wait()
end

--PLUG: send cmd to pane
M.pane = function()
        local session_result = vim.system({ "tmux", "display-message", "-p", "#S" }, { text = true }):wait()
        if session_result.code ~= 0 then
                notify_err("ERROR in tmux_run.lua: Failed to get tmux session")
                return
        end
        local session = vim.trim(session_result.stdout)

        -- get current window id
        local window_result = vim.system({ "tmux", "display-message", "-p", "#I" }, { text = true }):wait()
        if window_result.code ~= 0 then
                notify_err("ERROR in tmux_run.lua: M.pane 1")
                return
        end
        local window = vim.trim(window_result.stdout)

        -- get current pane id
        local current_pane_result = vim.system({ "tmux", "display-message", "-p", "#{pane_index}" }, { text = true })
                :wait()
        if current_pane_result.code ~= 0 then
                notify_err("ERROR in tmux_run.lua: M.pane 2")
                return
        end
        local current_pane_index = vim.trim(current_pane_result.stdout)

        -- get current session, window
        local target_win = string.format("%s:%s", session, window)

        -- check if pane_1 exist
        local list_result = vim.system(
                { "tmux", "list-panes", "-t", target_win, "-F", "#{pane_index}" },
                { text = true }
        )
                :wait()
        if list_result.code ~= 0 then
                notify_err("ERROR in tmux_run.lua: M.pane 3")
                return
        end
        local panes = vim.split(vim.trim(list_result.stdout), "\n")
        local has_pane1 = vim.tbl_contains(panes, "1")

        -- if doesn't have pane_1, then create pane1
        if not has_pane1 then
                local split_result = vim.system({
                        "tmux",
                        "split-window",
                        "-h",
                        "-p",
                        "30",
                        "-t",
                        target_win,
                }, { text = true }):wait()
                if split_result.code ~= 0 then
                        notify_err("Failed to create new pane")
                        return
                end

                -- back to pane
                vim.system({ "tmux", "select-pane", "-t", current_pane_index }):wait()
        end

        -- send cmd to pane_1
        local send_result = vim.system({ "tmux", "send-keys", "-t", target_win .. ".1", "C-w", "make", "C-j" }):wait()
        if send_result.code ~= 0 then
                notify_err("Failed to send command to pane 1")
        end
end

return M
