vim.pack.add({
        "https://github.com/Kicamon/markdown-table-mode.nvim",

        "https://github.com/NeogitOrg/neogit",

        "https://github.com/MunifTanjim/nui.nvim",
        "https://github.com/kawre/leetcode.nvim",
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
                picker = { provider = "telescope" },
        })
        vim.cmd("Leet")
end, {})
