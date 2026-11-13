------------------------------------------------------------------
--- cache
------------------------------------------------------------------

local CACHE = {
    channel = 0,
}

local function remember(cmd, target)
    CACHE.all = type(CACHE.all) == "table" and CACHE.all or {}

    if not vim.tbl_contains(CACHE.all, cmd) then
        table.insert(CACHE.all, cmd)
    end

    CACHE.last = {
        cmd = cmd,
        target = target,
    }
end
------------------------------------------------------------------
--- tmux
------------------------------------------------------------------

local function tmux(args)
    local result = vim.system(vim.list_extend({ "tmux" }, args), {
        text = true,
    }):wait()

    if result.code ~= 0 then
        vim.notify(vim.trim(result.stderr or "") ~= "" and result.stderr or "tmux command failed", vim.log.levels.ERROR)
        return nil
    end

    return vim.trim(result.stdout or "")
end

local function tmux_win(target_name, cmd)
    local windows = tmux({
        "list-windows",
        "-F",
        "#{window_name}",
    })

    if not windows then
        return false
    end

    if not vim.tbl_contains(vim.split(windows, "\n"), "runner") then
        if not tmux({ "new-window", "-n", "runner" }) then
            return false
        end
        -- 第一次不运行，确认目录
        return true
    end

    local status = tmux({
        "send-keys",
        "-t",
        target_name,
        "C-u",
        cmd,
        "Enter",
    })

    tmux({ "select-window", "-t", target_name })

    return status ~= nil
end

local function run_tmux(cmd, target)
    local session = tmux({ "display-message", "-p", "#{session_id}" })
    if not session then
        return false
    end

    local target_name = session .. ":runner"

    if target == "window" then
        return tmux_win(target_name, cmd)
    end

    -- pane: send command to pane 1 of the current window
    local window = tmux({ "display-message", "-p", "#{window_id}" })
    if not window then
        return false
    end

    local panes = tmux({
        "list-panes",
        "-t",
        window,
        "-F",
        "#{pane_index}",
    })

    if not panes then
        return false
    end

    -- bug: 有时会 focus 到 runner pane
    local nvim_paneid = tmux({ "display-message", "-p", "#{pane_index}" })
    if not nvim_paneid then
        return false
    end

    if not vim.tbl_contains(vim.split(panes, "\n"), "1") then
        if
            not tmux({
                "split-window",
                "-h",
                "-p",
                "30",
                "-t",
                window,
            })
        then
            return false
        end

        -- back to nvim pane
        tmux({ "select-pane", "-t", nvim_paneid })
        -- 第一次不运行，确认目录
        return true
    end

    local pane_target = window .. ".1"

    local status = tmux({
        "send-keys",
        "-t",
        pane_target,
        "C-u",
        cmd,
        "Enter",
    })

    -- back to nvim pane
    tmux({ "select-pane", "-t", nvim_paneid })

    return status ~= nil
end

local Tmux = {}

local function choose_target(callback)
    vim.ui.select({ "pane", "window" }, {
        prompt = "Run in: ",
    }, function(target)
        if target then
            callback(target)
        end
    end)
end

local function execute(cmd, target)
    if run_tmux(cmd, target) then
        remember(cmd, target)
    end
end

function Tmux.add()
    vim.ui.input({ prompt = "Runner add: " }, function(cmd)
        if not cmd or cmd == "" then
            return
        end

        choose_target(function(target)
            execute(cmd, target)
        end)
    end)
end

function Tmux.select()
    if not CACHE.all or #CACHE.all == 0 then
        vim.notify("No commands found", vim.log.levels.INFO)
        return
    end

    vim.ui.select(CACHE.all, {
        prompt = "Runner: ",
    }, function(cmd)
        if not cmd then
            return
        end

        choose_target(function(target)
            execute(cmd, target)
        end)
    end)
end

function Tmux.run()
    local last = CACHE.last

    if not last then
        return Tmux.add()
    end

    execute(last.cmd, last.target)
end

function Tmux.clear()
    CACHE = {}
    vim.notify("Cleared all commands", vim.log.levels.INFO)
end

--==========================
-- Commands & keymaps
--==========================

vim.api.nvim_create_user_command("Tmux", function(opts)
    local action = opts.args

    if action == "" then
        Tmux.run()
    elseif action == "add" then
        Tmux.add()
    elseif action == "select" then
        Tmux.select()
    elseif action == "clear" then
        Tmux.clear()
    else
        vim.notify("Usage: Runner [add|select|clear]", vim.log.levels.ERROR)
    end
end, {
    nargs = "?",
    ---@diagnostic disable-next-line
    complete = function(arglead, cmdline, cursorpos)
        local actions = { "add", "select", "clear" }
        return vim.tbl_filter(function(action)
            return action:find("^" .. vim.pesc(arglead)) ~= nil
        end, actions)
    end,
})
