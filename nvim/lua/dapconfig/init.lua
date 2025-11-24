vim.pack.add({
        "https://github.com/mfussenegger/nvim-dap",
        "https://github.com/theHamsta/nvim-dap-virtual-text",
        "https://github.com/igorlfs/nvim-dap-view",
})

-- sign
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointHighlight", linehl = "", numhl = "" })
vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "󰍷", texthl = "DapBreakpointHighlight", linehl = "", numhl = "" }
)
vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpointHighlight", linehl = "", numhl = "" }
)
vim.fn.sign_define("DapLogPoint", { text = "󰰎", texthl = "DapBreakpointHighlight", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStoppedHiglight", linehl = "", numhl = "" })

-- config
require("dap").defaults.fallback.switchbuf = "usevisible,usetab,uselast"

-- my provider
local resolved_path = vim.fn.getcwd() .. "/.dap/launch.json"
local dap = require("dap")
dap.providers.configs["dap39"] = function()
        local ok, configs = pcall(require("dap.ext.vscode").getconfigs, resolved_path)
        if not ok then
                local msg = "Can't get configurations from .dap/launch.json:\n%s" .. configs
                vim.notify_once(msg, vim.log.levels.WARN, { title = "DAP" })
                return {}
        end
        return configs
end

--  UI
require("nvim-dap-virtual-text").setup({
        virt_text_pos = "eol",
        all_frames = true,
})

-- keymap
local keymap = vim.keymap.set
local key_opts = { noremap = true, silent = true }
keymap("n", "<leader>dl", require("dapconfig.dap.handler").launch, key_opts)
keymap("n", "<leader>dt", require("dapconfig.dap.handler").terminate, key_opts)
keymap("n", "<leader>dv", require("dap-view").open, key_opts)
