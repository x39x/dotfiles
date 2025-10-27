local Path = require("plenary.path")
local tmux_run = require("utils.tmux_run")
local M = {}
local CMD_STORE_PATH = Path:new(vim.fn.stdpath("data"), "run_cmd.json")

-- load JSON
local function load_cmd_store()
        if not CMD_STORE_PATH:exists() then
                return {}
        end

        local ok, content = pcall(function()
                return CMD_STORE_PATH:read()
        end)

        if not ok or not content or content == "" then
                return {}
        end

        local decoded = vim.fn.json_decode(content)
        return decoded or {}
end

-- save JSON
local function save_cmd_store(data)
        CMD_STORE_PATH:parent():mkdir({ parents = true })
        CMD_STORE_PATH:write(vim.fn.json_encode(data), "w")
end

-- get project root
local function detect_project_root()
        local markers = {
                "go.mod",
                "Cargo.toml",
                "pyproject.toml",
                "setup.py",
                "CMakeLists.txt",
                "Makefile",
                "package.json",
                ".git",
        }

        local current = Path:new(vim.fn.expand("%:p")):parent()

        for _, marker in ipairs(markers) do
                local found = current:find_upwards(marker)
                if found then
                        return Path:new(found):parent():absolute()
                end
        end

        -- fallback
        return current:parent():absolute()
end

-- 加载已保存的命令
local function get_project_entry()
        local all_cmds = load_cmd_store()
        local root = detect_project_root()
        if not all_cmds[root] then
                all_cmds[root] = { last = nil, all = {} }
        end
        return all_cmds, root, all_cmds[root]
end

-- select form all
local function select_existing_cmd(callback)
        local _, root, entry = get_project_entry()

        if not entry.all or #entry.all == 0 then
                vim.notify("No saved commands for project: " .. root, vim.log.levels.INFO)
                return nil
        end

        vim.ui.select(entry.all, { prompt = "Select a command to run:" }, function(selected_cmd)
                if selected_cmd then
                        entry.last = selected_cmd
                        local all_cmds = load_cmd_store()
                        all_cmds[root] = entry
                        save_cmd_store(all_cmds)
                        callback(root, selected_cmd)
                end
        end)
end

-- add new cmd
local function add_new_cmd()
        local all_cmds, root, entry = get_project_entry()

        vim.ui.input({ prompt = "Enter new command to run: " }, function(input)
                if not input or input == "" then
                        vim.notify("Cancelled", vim.log.levels.INFO)
                        return
                end

                if not vim.tbl_contains(entry.all, input) then
                        table.insert(entry.all, input)
                end
                entry.last = input
                all_cmds[root] = entry
                save_cmd_store(all_cmds)
        end)
        -- add and return new cmd
        return root, entry.last
end

local function get_command()
        local _, root, entry = get_project_entry()
        local cmd = entry.last

        if not cmd then
                vim.notify("No last command found, please add one.", vim.log.levels.WARN)
                cmd = add_new_cmd()
        end
        return root, cmd
end

-- ------------------------------
-- RUNNER
-- ------------------------------

function M.run_in_tmux_pane()
        local root, cmd = get_command()
        if cmd then
                tmux_run.pane(root, cmd)
        end
end

function M.run_in_tmux_window()
        local root, cmd = get_command()
        if cmd then
                tmux_run.window(root, cmd)
        end
end

function M.add_and_run()
        local root, cmd = add_new_cmd()

        local methods = { "tmux pane", "tmux window" }
        vim.ui.select(methods, { prompt = "Run in:" }, function(choice)
                if choice == "tmux pane" then
                        tmux_run.pane(root, cmd)
                elseif choice == "tmux window" then
                        tmux_run.window(root, cmd)
                end
        end)
end

function M.select_and_run()
        local methods = { "tmux pane", "tmux window" }
        vim.ui.select(methods, { prompt = "Run in:" }, function(choice)
                if choice == nil then
                        return
                end
                select_existing_cmd(function(root, cmd)
                        if choice == "tmux pane" then
                                tmux_run.pane(root, cmd)
                        elseif choice == "tmux window" then
                                tmux_run.window(root, cmd)
                        end
                end)
        end)
end

-- ------------------------------
-- clean cmd
-- ------------------------------

function M.clear_project_cmds()
        local all_cmds = load_cmd_store()
        local root = detect_project_root()

        vim.ui.input({ prompt = "Clear commands for <" .. root .. ">? (y/N): " }, function(answer)
                if answer and answer:lower() == "y" then
                        all_cmds[root] = nil
                        save_cmd_store(all_cmds)
                        vim.notify("Cleared commands for " .. root)
                else
                        vim.notify("Cancelled")
                end
        end)
end

function M.clear_all_cmds()
        save_cmd_store({})
        vim.notify("Cleared all project commands.")
end

return M
-- "silent! !open %"
-- "silent! !open -a Skim.app %:p:r.pdf"
