local delve = function(callback, config)
        if config.mode == "remote" and config.request == "attach" then
                callback({
                        type = "server",
                        host = config.host or "127.0.0.1",
                        port = config.port or "38697",
                })
        else
                callback({
                        type = "server",
                        port = "${port}",
                        executable = {
                                command = "dlv",
                                args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
                                detached = vim.fn.has("win32") == 0,
                        },
                })
        end
end

local go = {}

-- {
--         type = "delve",
--         name = "Debug(without go.mod)",
--         request = "launch",
--         program = "${file}",
-- },

go[#go + 1] = {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "./${relativeFileDirname}",
}
go[#go + 1] = {
        type = "delve",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
}

return function()
        local dap = require("dap")
        dap.adapters.delve = delve
        dap.configurations.go = go
end
