--NOTE: config

-- https://youtu.be/Ul_WPhS2bis
-- https://youtu.be/DVG3m7rNFKc
-- https://www.reddit.com/r/neovim/comments/1n31441/comment/nbdu0qb/

local js_debug = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
                command = "js-debug-adapter",
                args = { "${port}" },
        },
}

local node_launch = {
        type = "pwa-node",
        request = "launch",
        name = "[DAP] Launch file using Node.js",
        program = "${file}",
        cwd = "${workspaceFolder}",
}

-- requires ts-node to be installed globally or locally
local node_ts_launch = {
        type = "pwa-node",
        request = "launch",
        name = "[DAP] Launch file using Node.js with ts-node/register",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runtimeArgs = { "-r", "ts-node/register" },
}

local node_attach = {
        type = "pwa-node",
        request = "attach",
        name = "[DAP] Attach to process using Node.js",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
}

-- NODE_OPTIONS='--inspect' && pnpm run dev
local chrome_launch = {
        type = "pwa-chrome", --"pwa-msedge"
        request = "launch",
        name = "[DAP] Launch Chrome",
        url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                        vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:" }, function(url)
                                if url == nil or url == "" then
                                        return
                                else
                                        coroutine.resume(co, url)
                                end
                        end)
                end)
        end,
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
}

return function()
        local dap = require("dap")

        for _, adapterType in ipairs({ "node", "chrome", "msedge" }) do
                local pwaType = "pwa-" .. adapterType

                if not dap.adapters[pwaType] then
                        dap.adapters[pwaType] = js_debug
                end

                -- Define adapters without the "pwa-" prefix for VSCode compatibility
                if not dap.adapters[adapterType] then
                        dap.adapters[adapterType] = function(cb, config)
                                local nativeAdapter = dap.adapters[pwaType]

                                config.type = pwaType

                                if type(nativeAdapter) == "function" then
                                        nativeAdapter(cb, config)
                                else
                                        cb(nativeAdapter)
                                end
                        end
                end
        end

        for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }) do
                dap.configurations[language] = {
                        node_launch,
                        node_attach,
                        node_ts_launch,
                        chrome_launch,
                }
        end
end
