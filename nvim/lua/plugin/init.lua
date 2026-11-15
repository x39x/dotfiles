vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/folke/snacks.nvim",
    -- treesitter
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    -- ui
    "https://github.com/lewis6991/satellite.nvim",
    "https://github.com/folke/todo-comments.nvim",
    -- lsp
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    -- git
    "https://github.com/neogitorg/neogit",
    "https://github.com/lewis6991/gitsigns.nvim",
    --
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/mfussenegger/nvim-lint",
    "https://github.com/stevearc/overseer.nvim",
    "https://github.com/folke/flash.nvim",
    "https://github.com/nvim-mini/mini.align",
}, { confirm = false })

local keymap = vim.keymap.set

require("plugin.treesitter")
require("plugin.snacks")
require("plugin.lazy")
require("plugin.flt")
require("plugin.git")

--- align
require("mini.align").setup({
    mappings = {
        start = "<leader>a",
        start_with_preview = "<leader>A",
    },
})

--- mason
require("mason").setup({
    ui = {
        backdrop = 100,
        border = "double",
    },
})

--- flash
local flash = require("flash")
flash.setup({
    labels = "asdfghjkl;weruiopzxcvnm",
    modes = {
        char = {
            enabled = false,
        },
        search = {
            enabled = false,
        },
    },
    highlight = {
        backdrop = false,
    },
    prompt = {
        enabled = false,
    },
})
keymap({ "n" }, "f", flash.jump)
keymap({ "o", "x" }, "f", function()
    local prev_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    flash.jump({ jump = { register = true } })
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- backward jump, do nothing
    if prev_row > row then
        vim.fn.setreg("/", "")
        return
    end
    -- forward jump, move to prompt end
    -- setreg adds ad invisible "\V"
    ---@diagnostic disable-next-line
    local prompt_len = string.len(vim.fn.getreg("/"):gsub("^\\V", ""))
    vim.api.nvim_win_set_cursor(0, { row, col + prompt_len - 1 })
    vim.fn.setreg("/", "")
end)

--- todo
require("todo-comments").setup({
    keywords = {
        NOTE = { icon = "", color = "#10B981", alt = { "TIPS", "DONE" } },
        BUG = { icon = " ", color = "#DC2626", alt = { "XXX", "FIX", "ISSUE" } },
        TODO = { icon = " ", color = "#1957F3", alt = { "PASS" } },
        WARN = { icon = " ", color = "#FD971E", alt = { "WARNING", "PERF" } },
        HACK = { icon = " ", color = "#AF7AC5", alt = { "FUNC", "PLUG" } },
    },
    merge_keywords = false,
})

--- scrollbar
require("satellite").setup({
    winblend = 100,
    excluded_filetypes = {
        "quickfix",
        "snacks_picker_list",
    },
    handlers = {
        gitsigns = {
            enable = false,
        },
        marks = {
            key = "<Ignore>",
        },
    },
})
