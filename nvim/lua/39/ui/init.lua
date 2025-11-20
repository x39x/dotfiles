vim.pack.add({
        "https://github.com/goolord/alpha-nvim",
        "https://github.com/nvimdev/indentmini.nvim",
        "https://github.com/rebelot/heirline.nvim",
        "https://github.com/folke/todo-comments.nvim",
        "https://github.com/brenoprata10/nvim-highlight-colors",
})

--PLUG: alpha
require("alpha").setup({
        layout = {
                --val c:2 a:6
                { type = "padding", val = 6 },
                {
                        type = "text",
                        val = require("39.ui.header").a,
                        opts = {
                                position = "center",
                                hl = "AlphaHeader",
                        },
                },
        },
        opts = {
                margin = 5,
        },
})

require("indentmini").setup({
        exclude = {
                "help",
                "Trouble",
                "alpha",
                "typst",
                "markdown",
        },
})

--PLUG: todo
require("todo-comments").setup({
        keywords = {
                FIX = { icon = "󰨰 ", color = "#DC2626", alt = { "BUG" } },
                TEST = { icon = " ", color = "#AF7AC5", alt = { "FUNC", "PLUG" } },
                WARN = { icon = " ", color = "#C0392B", alt = { "ISSUE" } },
                TODO = { icon = " ", color = "#DC2626", alt = { "XXX" } },
                DONE = { icon = " ", color = "#1957F3" },
                NOTE = { icon = "", color = "#10B981", alt = { "INFO", "TIPS" } },
        },
        merge_keywords = false,
})

require("nvim-highlight-colors").setup()

require("39.ui.39line")
require("39.ui.colorscheme").set()
