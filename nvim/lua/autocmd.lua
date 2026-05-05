local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local Default = vim.api.nvim_create_augroup("Default", { clear = true })
local autosnip = require("utils.autosnip")

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
                "*.hh",
                "*.cpp",

                "*.go",
                "*.py",
                "*.rs",
                "*.lua",

                "*.js",
                "*.jsx",
                "*.ts",
                "*.tsx",
                "*.mjs",
                "*.mts",
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
        pattern = { "markdown" },
        callback = function(args)
                local winid = vim.api.nvim_get_current_win()
                local bufnr = args.buf
                vim.bo[bufnr].textwidth = 120
                vim.wo[winid][0].wrap = true
                keymap({ "x", "n" }, "j", "gj", { silent = true, buf = args.buf })
                keymap({ "x", "n" }, "k", "gk", { silent = true, buf = args.buf })
                keymap("", "H", "g^", { silent = true, buf = args.buf })
                keymap("", "L", "g$", { silent = true, buf = args.buf })

                autosnip.add(";1", "```\n```", "<Esc>k0A", { buf = args.buf })
                autosnip.add(";2", "``", "<Esc>i", { buf = args.buf })
        end,
        group = vim.api.nvim_create_augroup("TEXT", { clear = true }),
        desc = "Text autocmd",
})

autocmd("FileType", {
        pattern = { "lua", "c", "cpp" },
        callback = function(args)
                vim.bo[args.buf].shiftwidth = 8
        end,
        group = vim.api.nvim_create_augroup("LUA", { clear = true }),

        desc = "Lua autocmd",
})

autocmd("FileType", {
        pattern = { "go" },
        callback = function(args)
                local template = "if err != nil {\n" .. "return err\n}"
                autosnip.add("iff", template, "<Esc>k0teltel", { buf = args.buf })
        end,
        group = vim.api.nvim_create_augroup("GOLANG", { clear = true }),
        desc = "go autocmd",
})

autocmd("FileType", {
        pattern = "qf",
        callback = function()
                vim.opt_local.buflisted = false
        end,
        group = Default,
        desc = "Do't show qf in bufline",
})

autocmd("User", {
        pattern = "CodeDiffOpen",
        callback = function()
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                        vim.wo[win].cursorline = false
                end
        end,
        desc = "Disable cursorline in diff windows",
})

-- NOTE: https://www.reddit.com/r/neovim/comments/1jilkjs/comment/mjlpumh/
-- vim.api.nvim_create_autocmd("LspAttach", {
--         callback = function()
--                 for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--                         vim.api.nvim_set_hl(0, group, {})
--                 end
--         end,
--         group = Default,
--         desc = "Disable LSP semantic token highlighting",
-- })

-- autocmd("PackChanged", {
--         callback = function(ev)
--                 local name, kind = ev.data.spec.name, ev.data.kind
--
--                 if name == "luasnip" and (kind == "install" or kind == "update") then
--                         vim.system({ "make install_jsregexp" }, { cwd = ev.data.path }):wait()
--                 end
--         end,
--         group = vim.api.nvim_create_augroup("PACK", { clear = true }),
--         desc = "pack make",
-- })
