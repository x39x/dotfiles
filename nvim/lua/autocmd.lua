local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local Default = vim.api.nvim_create_augroup("Default", { clear = true })

autocmd("FileType", {
        pattern = "*",
        callback = function()
                -- :h fo-table
                vim.o.formatoptions = vim.o.formatoptions:gsub("o", "")
        end,
        group = vim.api.nvim_create_augroup("FORMATOPTIONS", { clear = true }),
})

autocmd("BufWritePre", {
        pattern = {
                "*.c",
                "*.h",
                "*.cc",
                "*.go",
                "*.hh",
                "*.py",
                "*.rs",
                "*.cpp",
                "*.lua",

                "*.js",
                "*.jsx",
                "*.ts",
                "*.tsx",
                "*.mjs",
                "*.vue",
                "*.svelte",

                "*.md",
                "*.mdx",
                "*.json",
                "*.toml",
                "*.yaml",
        },
        callback = function()
                vim.lsp.buf.format({ sync = true })
        end,
        group = Default,
})

autocmd({ "BufReadPost" }, {
        callback = function()
                require("utils.lastplace").set_cursor_position()
        end,
        group = Default,
})

autocmd("InsertLeave", {
        callback = function()
                if vim.fn.executable("iswitch") == 0 then
                        return
                end
                vim.system({ "iswitch", "-s", "com.apple.keylayout.ABC" }, nil, function(proc)
                        if proc.code ~= 0 then
                                vim.notify("Failed to switch input source: " .. proc.stderr, vim.log.levels.Warn)
                        end
                end)
        end,
        group = Default,
        desc = "auto switch to abc input",
})

autocmd("FileType", {
        pattern = { "markdown", "typst" },
        callback = function(args)
                local winid = vim.api.nvim_get_current_win()
                local bufnr = args.buf
                vim.bo[bufnr].textwidth = 120
                vim.wo[winid][0].wrap = true
                keymap({ "x", "n" }, "j", "gj", { silent = true, buffer = true })
                keymap({ "x", "n" }, "k", "gk", { silent = true, buffer = true })
                keymap("", "H", "g^", { silent = true, buffer = true })
                keymap("", "L", "g$", { silent = true, buffer = true })
        end,
        group = vim.api.nvim_create_augroup("TEXT", { clear = true }),
})

autocmd("FileType", {
        pattern = { "lua" },
        callback = function(args)
                local _ = args.buf
                vim.bo[0].shiftwidth = 8
        end,
        group = vim.api.nvim_create_augroup("LUA", { clear = true }),
})

-- https://github.com/rebelot/heirline.nvim/blob/fae936abb5e0345b85c3a03ecf38525b0828b992/lua/heirline/utils.lua#L121
vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
                vim.opt_local.buflisted = false
        end,
        group = Default,
})
