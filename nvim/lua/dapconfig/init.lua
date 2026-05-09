-- ===========================================================

-- go:
-- go install github.com/go-delve/delve/cmd/dlv@master
--------------------------------------------------------------
-- python
-- uv add --dev debugpy / pip3 install debugpy
--------------------------------------------------------------
-- c/cc
-- lldb
--------------------------------------------------------------
-- js vue react
-- mason js-debug-adapter

-- ===========================================================

vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	{ src = "https://github.com/igorlfs/nvim-dap-view", version = "main" },
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

-- Controls the behavior when jumping to a breakpoint. See :h switchbuf
require("dap").defaults.fallback.switchbuf = "usevisible,usetab,uselast"

-- my provider
-- 最终会聚合所有 provider
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

require("dap-view").setup({
	virtual_text = {
		enabled = true,
		position = "eol",

		prefix = function(position, node, bufnr)
			if position == "eol" or position == "eol_right_align" then
				local name = vim.treesitter.get_node_text(node, bufnr)

				return "[[" .. name .. " ="
			end
		end,
		suffix = function(position, _, _, _, _)
			if position == "eol" or position == "eol_right_align" then
				return "]]"
			end
		end,
	},
})

-- keymap
local keymap = vim.keymap.set
local keymap_opts = require("utils.keymap_opts")
keymap("n", "<leader>dl", require("dapconfig.dap.handler").launch, keymap_opts({ desc = "Dap launch" }))
keymap("n", "<leader>dt", require("dapconfig.dap.handler").terminate, keymap_opts({ desc = "Dap terminate" }))
keymap("n", "<leader>dv", require("dapconfig.dap.handler").view, keymap_opts({ desc = "Dap view toggle" }))
