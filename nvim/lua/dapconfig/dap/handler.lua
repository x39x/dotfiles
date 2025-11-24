local M = {}

M.launch = function()
        local keymap = require("dapconfig.dap.keymap")
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype

        vim.notify("Launch DAP for " .. ft, vim.log.levels.INFO)

        local ok, dap_config = pcall(require, "dapconfig.dap." .. ft)
        if ok then
                dap_config()
                keymap.set(buf)
        else
                vim.notify("NO DAP for " .. ft, vim.log.levels.WARN)
        end
end

M.terminate = function()
        local dap = require("dap")
        local keymap = require("dapconfig.dap.keymap")
        local buf = vim.api.nvim_get_current_buf()

        dap.terminate()
        dap.clear_breakpoints()
        keymap.clear(buf)
        require("dap-view").close(true)
        vim.notify("Terminate DAP ", vim.log.levels.INFO)
end

return M
