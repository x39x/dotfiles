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
                --val c:2 a:7
                { type = "padding", val = 7 },
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

require("heirline").setup({
        require("39.ui.39line"),
})

--PLUG: todo
require("todo-comments").setup({
        keywords = {
                FIX = { icon = "󰨰 ", color = "#DC2626", alt = { "BUG" } },
                TEST = { icon = " ", color = "#AF7AC5", alt = { "FUNC", "PLUG" } },
                WARN = { icon = " ", color = "#C0392B" },
                TODO = { icon = " ", color = "#DC2626", alt = { "XXX" } },
                DONE = { icon = " ", color = "#1957F3" },
                NOTE = { icon = "", color = "#10B981", alt = { "INFO", "TIPS" } },
        },
        merge_keywords = false,
})

require("nvim-highlight-colors").setup()

require("39.ui.colorscheme").set()
