vim.pack.add({
        "https://github.com/ibhagwan/fzf-lua",
})
require("fzf-lua").setup({
        winopts = {
                height = 0.37,
                width = 1,
                row = 1,
                col = 0,
                backdrop = 100,
                border = { "─", "─", "─", " ", " ", " ", " ", " " },
                preview = {
                        border = { "─", "─", "─", " ", " ", " ", " ", " " },
                        horizontal = "right:50%",
                        title = false,
                        scrollbar = false,
                        winopts = {
                                number = false,
                        },
                },
        },
        files = { previewer = false },
        oldfiles = { previewer = false },
})
