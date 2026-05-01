vim.pack.add({
        "https://github.com/Kicamon/markdown-table-mode.nvim",

        "https://github.com/NeogitOrg/neogit",

        "https://github.com/MunifTanjim/nui.nvim",
        "https://github.com/kawre/leetcode.nvim",
})

-- --PLUG: deffview
require("codediff").setup({
        -- Highlight configuration
        highlights = {
                -- Line-level: accepts highlight group names or hex colors (e.g., "#2ea043")
                line_insert = "DiffAdd", -- Line-level insertions
                line_delete = "DiffDelete", -- Line-level deletions

                char_insert = "CodeDiffCharInsert",
                char_delete = "CodeDiffCharDelete",
        },
})
local cmd = vim.api.nvim_create_user_command
local del_cmd = vim.api.nvim_del_user_command

cmd("Mtm", function()
        del_cmd("Mtm")
        require("markdown-table-mode").setup()
        vim.cmd("Mtm")
end, {})

cmd("Leet", function()
        del_cmd("Leet")
        require("leetcode").setup({
                cn = {
                        enabled = true,
                },
                injector = {
                        ["python3"] = {
                                before = true,
                        },
                        ["cpp"] = {
                                before = { "#include <bits/stdc++.h>" },
                        },
                },
                picker = { provider = "fzf-lua" },
        })
        vim.cmd("Leet")
end, {})
