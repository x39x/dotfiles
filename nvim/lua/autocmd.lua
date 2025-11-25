local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local Default = vim.api.nvim_create_augroup("Default", { clear = true })

autocmd("FileType", {
        pattern = "*",
        callback = function()
                -- :h fo-table
                vim.o.formatoptions = vim.o.formatoptions:gsub("o", "")
        end,
        group = Default,
        desc = "Formatoptions",
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
        desc = "Lastplace",
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
        desc = "Auto switch to abc input",
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
        desc = "Text autocmd",
})

autocmd("FileType", {
        pattern = { "lua" },
        callback = function(args)
                local _ = args.buf
                vim.bo[0].shiftwidth = 8
        end,
        group = vim.api.nvim_create_augroup("LUA", { clear = true }),

        desc = "Lua autocmd",
})

autocmd("FileType", {
        pattern = "qf",
        callback = function()
                vim.opt_local.buflisted = false
        end,
        group = Default,
        desc = "Do't show qf in bufline",
})
