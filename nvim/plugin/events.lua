local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup
local keymap = vim.keymap.set
local o = vim.o

---  formatoption
au("FileType", {
    pattern = "*",
    group = ag("matsu.formatoptions", { clear = true }),
    callback = function()
        -- tc: text/comment,qwn2j:format,mM] cjk
        -- ro: <enter>/oO auto comment leader
        -- see :h 'formatoptions'
        o.formatoptions = "tcr/qwn2jvlmM]"
    end,
})

--- highlight yank/put
au("TextYankPost", {
    group = ag("matsu.highlight.yank", { clear = true }),
    callback = function()
        if not vim.v.event.visual then
            -- vim.hl.on_yank({ higroup = "Visual", timeout = 139 })
            -- 0.13
            vim.hl.hl_op({ higroup = "Visual", timeout = 139 })
        end
    end,
})

-- 0.13
au("TextPutPost", {
    group = ag("matsu.highlight.remove", { clear = true }),
    callback = function()
        vim.hl.hl_op({ higroup = "Visual", timeout = 139 })
    end,
})

--- input method
local switch_im
if vim.fn.has("linux") == 1 and vim.fn.executable("fcitx5-remote") == 1 then
    switch_im = { "fcitx5-remote", "-c" }
elseif vim.fn.has("macunix") == 1 and vim.fn.executable("iswitch") == 1 then
    switch_im = { "iswitch", "-i", "com.apple.keylayout.ABC" }
end
if switch_im then
    au("InsertLeave", {
        group = ag("matsu.imswitch", { clear = true }),
        callback = function()
            vim.system(switch_im)
        end,
    })
end

--- md
au("FileType", {
    pattern = { "markdown" },
    callback = function(args)
        local winid = vim.api.nvim_get_current_win()
        vim.bo[args.buf].textwidth = 120
        -- vim.wo[winid][0].wrap = true
        vim.wo[winid].wrap = true
        keymap({ "x", "n" }, "j", "gj", { silent = true, buf = args.buf })
        keymap({ "x", "n" }, "k", "gk", { silent = true, buf = args.buf })
        keymap("", "H", "g^", { silent = true, buf = args.buf })
        keymap("", "L", "g$", { silent = true, buf = args.buf })
    end,
    group = ag("matsu.markdown", { clear = true }),
})

--- indent/tab
au("FileType", {
    pattern = { "c", "cpp", "go" },
    callback = function(args)
        vim.bo[args.buf].shiftwidth = 8
    end,
    group = ag("matsu.indet", { clear = true }),
})

--- quickfix
au("FileType", {
    group = ag("matsu.qfbufline", { clear = true }),
    pattern = "qf",
    callback = function(args)
        vim.bo[args.buf].buflisted = false

        vim.wo.listchars = "tab:   ,extends:,precedes:,trail:·,nbsp:󰌎"
        vim.wo.statusline = "%{%g:matsu_statusline()%}"

        keymap("n", "J", "j<Cmd>cn<CR><C-w><C-P>", { buf = args.buf })
        keymap("n", "K", "k<Cmd>cp<CR><C-w><C-P>", { buf = args.buf })
    end,
})

-- hi
au("ColorScheme", {
    group = ag("matsu.retrobox", { clear = true }),
    callback = function(args)
        if args.match and args.match == "retrobox" then
            vim.api.nvim_set_hl(0, "FloatBorder", { link = "NormalFloat" })
        end
        vim.api.nvim_set_hl(0, "PmenuThumb", { link = "PmenuBorder" })
    end,
})
