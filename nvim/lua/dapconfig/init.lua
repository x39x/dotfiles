-- ===========================================================

--- go:
-- go install github.com/go-delve/delve/cmd/dlv@master
--------------------------------------------------------------
--- python
-- uv add --dev debugpy / pip3 install debugpy
--------------------------------------------------------------
--- c/cc
-- lldb
--------------------------------------------------------------
--- js vue react
-- mason js-debug-adapter

-- ===========================================================

vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/igorlfs/nvim-dap-view",
})

-- sign
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointHighlight", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "󰍷", texthl = "DapBreakpointHighlight", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointHighlight", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "󰰎", texthl = "DapBreakpointHighlight", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStoppedHighlight", linehl = "", numhl = "" })

-- Controls the behavior when jumping to a breakpoint. See :h switchbuf
local dap = require("dap")
dap.defaults.fallback.switchbuf = "usevisible,usetab,uselast"

-- my provider
-- 最终会聚合所有 provider
local resolved_path = vim.uv.cwd() .. "/.dap/launch.json"
dap.providers.configs["dap39"] = function()
	local ok, configs = pcall(require("dap.ext.vscode").getconfigs, resolved_path)
	if not ok then
		local msg = "Can't get configurations from .dap/launch.json:\n%s" .. configs
		vim.notify_once(msg, vim.log.levels.WARN, { title = "DAP" })
		return {}
	end
	return configs
end

local dapview = require("dap-view")
dapview.setup({
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

--- keymap
local keymap = vim.keymap.set
local keymap_opts = require("utils.keymap_opts")
local dap_keymaps = {
	{
		mode = "n",
		lhs = "r",
		rhs = function()
			dap.repl.open({ height = 10 })
		end,
		desc = "Dap REPL",
	},
	{
		mode = "n",
		lhs = "n",
		rhs = function()
			dap.continue()
		end,
		desc = "Dap Continue",
	},
	{
		mode = "n",
		lhs = "p",
		rhs = function()
			dap.toggle_breakpoint()
		end,
		desc = "Dap Toggle Breakpoint",
	},
}

local dapkeymap_set = function(buf)
	local opts = { noremap = true, silent = true, buffer = buf }
	for _, map in ipairs(dap_keymaps) do
		keymap(map.mode, map.lhs, map.rhs, vim.tbl_extend("force", opts, { desc = map.desc }))
	end
end

local dapkeymap_clear = function(buf)
	for _, map in ipairs(dap_keymaps) do
		pcall(vim.keymap.del, map.mode, map.lhs, { buffer = buf })
	end
end

local launch = function()
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.bo[buf].filetype
	if vim.tbl_contains({
		"vue",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
	}, ft) then
		ft = "js"
	end

	local ok, dap_config = pcall(require, "dapconfig.dap." .. ft)

	if ok then
		dap_config()
		dapkeymap_set(buf)
		vim.g.nvim_dap_enabled = true
		vim.notify("Launch DAP for " .. ft, vim.log.levels.INFO)
	else
		vim.notify("NO DAP for " .. ft, vim.log.levels.WARN)
	end
end

local terminate = function()
	if vim.g.nvim_dap_enabled ~= true then
		return
	end

	local buf = vim.api.nvim_get_current_buf()

	dap.terminate()
	dap.clear_breakpoints()
	dapkeymap_clear(buf)
	-- true: https://github.com/igorlfs/nvim-dap-view/blob/main/lua/dap-view.lua#L31
	dapview.close(true)
	vim.g.nvim_dap_enabled = nil
	vim.notify("Terminate DAP ", vim.log.levels.INFO)
end
local view = function()
	if vim.g.nvim_dap_enabled == true then
		dapview.toggle()
	end
end

keymap("n", "<leader>dl", launch, keymap_opts({ desc = "Dap launch" }))
keymap("n", "<leader>dt", terminate, keymap_opts({ desc = "Dap terminate" }))
keymap("n", "<leader>dv", view, keymap_opts({ desc = "Dap view toggle" }))
