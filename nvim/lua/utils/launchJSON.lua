local Path = require("plenary.path")

local M = {}

function M.create_launch_json(launch_path)
        launch_path = launch_path or ".vscode/launch.json"

        local path = Path:new(launch_path)

        --  mkdir
        Path:new(path:parent()):mkdir({ parents = true })

        local tbl = {
                ["$schema"] = "https://raw.githubusercontent.com/mfussenegger/dapconfig-schema/master/dapconfig-schema.json",
                version = "0.2.0",
                configurations = {
                        {
                                name = "",
                                type = "",
                                request = "launch",
                                mode = "debug",
                                program = "",
                                console = "integratedTerminal",
                                args = {},
                        },
                },
        }

        local json = vim.json.encode(tbl, { indent = "    " })

        path:write(json, "w")

        vim.notify("launch.json created at: " .. launch_path)
end

return M
