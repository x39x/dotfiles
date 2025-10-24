local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local cmd = vim.api.nvim_create_user_command
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
        group = vim.api.nvim_create_augroup("AUTOFORMAT", { clear = true }),
})

autocmd({ "BufReadPost" }, {
        callback = function()
                require("utils.lastplace").set_cursor_position()
        end,
        group = vim.api.nvim_create_augroup("LASTPLACE", { clear = true }),
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
        group = vim.api.nvim_create_augroup("ISWITCH", { clear = true }),
        desc = "auto switch to abc input",
})

autocmd("FileType", {
        pattern = { "markdown", "typst" },
        group = vim.api.nvim_create_augroup("WRITING", { clear = true }),

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
})

autocmd({ "FileType" }, {
        pattern = { "typst" },
        group = vim.api.nvim_create_augroup("TYPST", { clear = true }),
        callback = function()
                cmd("TypstFigures", "silent !mkdir figures", {})
        end,
})

autocmd("FileType", {
        pattern = { "lua" },
        group = vim.api.nvim_create_augroup("SHIFTWIDTHLUA", { clear = true }),
        callback = function(args)
                local _ = args.buf
                vim.bo[0].shiftwidth = 8
        end,
})
