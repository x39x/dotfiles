vim.pack.add({
        -- lib
        "https://github.com/nvim-lua/plenary.nvim",
        "https://github.com/nvim-tree/nvim-web-devicons",
        -- edit
        "https://github.com/kylechui/nvim-surround",
        "https://github.com/windwp/nvim-autopairs",
        "https://github.com/junegunn/vim-easy-align",
        -- fzf
        "https://github.com/ibhagwan/fzf-lua",
        -- filetree
        "https://github.com/nvim-tree/nvim-tree.lua",
        -- treesitter
        {
                src = "https://github.com/nvim-treesitter/nvim-treesitter",
                version = "main",
        },
        {
                src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
                version = "main",
        },
        "https://github.com/kevinhwang91/promise-async",
        "https://github.com/kevinhwang91/nvim-ufo",
        -- blink.cmp
        "https://github.com/rafamadriz/friendly-snippets",
        "https://github.com/L3MON4D3/LuaSnip", -- build = "make install_jsregexp",
        {
                src = "https://github.com/Saghen/blink.cmp",
                version = vim.version.range("1.*"),
        },
        --
        -- tools
        "https://github.com/folke/flash.nvim",
        "https://github.com/folke/trouble.nvim",
        "https://github.com/sindrets/diffview.nvim",

        "https://github.com/nvim-mini/mini.bufremove",
})

-- PLUG: mini.bufremove
require("mini.bufremove").setup()

-- PLUG: nvim-surround
require("nvim-surround").setup()

-- PLUG: autopairs
require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "fzf" },
        enable_check_bracket_line = false,
})
require("nvim-autopairs").get_rules("'")[1].not_filetypes = { "scheme", "lisp" }
require("nvim-autopairs").get_rules("`")[1].not_filetypes = { "typst" }

--PLUG:  motion
require("flash").setup({
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

local keymap = vim.keymap.set
local key_opts = { noremap = true, silent = true }
keymap({ "n", "x", "o" }, "f", require("flash").jump, key_opts)
keymap({ "n", "x" }, ";a", "<Plug>(EasyAlign)", { noremap = true, silent = true })
keymap("n", "<leader>n", require("nvim-tree.api").tree.open, key_opts)

-- --PLUG: trouble
local trouble = require("trouble")
trouble.setup({
        focus = true,
        auto_preview = false,
        auto_close = true,
        win = { position = "right" },
        preview = {
                type = "float",
                relative = "editor",
                border = "single",
                position = { 0, -2 },
                size = { width = 0.3, height = 0.3 },
                zindex = 200,
        },
        modes = {
                symbols = {
                        auto_preview = false,
                        focus = true,
                },
        },
})

keymap({ "n" }, "<leader>tx", function()
        if trouble.is_open({}) then
                require("trouble").close()
        end
end, key_opts)
keymap({ "n" }, "<leader>tj", function()
        if trouble.is_open({}) then
                require("trouble").next({ jump = true })
        end
end, key_opts)
keymap({ "n" }, "<leader>tk", function()
        if trouble.is_open({}) then
                require("trouble").prev({ jump = true })
        end
end, key_opts)

require("base.filetree")
require("base.treesitter")
require("base.cmp")
require("base.fzf")
require("base.extras")
