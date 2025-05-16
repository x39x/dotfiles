local M = {}

--PLUG: alpha
M[#M + 1] = {
        "goolord/alpha-nvim",
        opts = {
                layout = {
                        --val c:2 a:7
                        { type = "padding", val = 7 },
                        {
                                type = "text",
                                val = require("utils.header").a,
                                opts = {
                                        position = "center",
                                        hl = "AlphaHeader",
                                },
                        },
                },
                opts = {
                        margin = 5,
                },
        },
}
M[#M + 1] = {
        "nvimdev/indentmini.nvim",
        opts = {
                exclude = {
                        "help",
                        "Trouble",
                        "alpha",
                        "typst",
                        "markdown",
                },
        },
}

M[#M + 1] = {
        "rebelot/heirline.nvim",
        dependencies = {
                "nvim-tree/nvim-web-devicons",
        },
        opts = require("utils.39line"),
}

M[#M + 1] = {
        "brenoprata10/nvim-highlight-colors",
        opts = {},
}

return M
