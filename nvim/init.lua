-- Enables the experimental Lua module loader
vim.loader.enable()

-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.editorconfig = false

-- leader key
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = "\\"

-- rust fmt
vim.g.rust_recommended_style = 0

-- filetype
vim.filetype.add({
    pattern = {
        [".*profile"] = "bash",
    },
    extension = {
        typ = "typst",
        mdx = "markdown",
    },
})

local keymap = vim.keymap.set
local o = vim.o
local command = vim.api.nvim_create_user_command

------------------------------------------------------------------------------
-- options
------------------------------------------------------------------------------

o.backup = false
o.swapfile = false
o.autochdir = false
o.splitright = true
o.splitbelow = true
o.tabclose = "uselast"
o.startofline = false
o.synmaxcol = 200
o.smoothscroll = true
o.ignorecase = true
o.smartcase = true
o.scrolloff = 5
o.sidescrolloff = 5
o.exrc = true -- exrc config
o.quickfixtextfunc = "v:lua.matsu_qftf" --  quickfix textfunc
o.virtualedit = "block"
--
o.showtabline = 2 -- 0: no
o.laststatus = 3 --  global statusline
o.showmode = false
o.signcolumn = "yes" -- sign column
o.number = true
o.numberwidth = 3
o.list = true
o.listchars = "tab:··,extends:,precedes:,trail:·,nbsp:󰌎"
o.fillchars = "eob: ,msgsep:─,fold: ,diff:╱" -- eob: hide "~"
o.guicursor = o.guicursor .. ",n:blinkon339-blinkoff339"
o.cursorline = false
-- o.cursorlineopt = "number"
o.conceallevel = 0 -- Hide * ..., 0: no ,1: leave space, 2:hide space
--
o.wrap = false
o.linebreak = true -- wrap don't break words
o.smartindent = true
o.copyindent = true
o.shiftwidth = 4
o.expandtab = true
o.softtabstop = -1 -- " Don't mess with 'tabstop', with 'expandtab' it isn't used. " Set softtabstop=-1 to mirror 'shiftwidth'
--
o.foldlevel = 99
o.foldlevelstart = 99
o.foldcolumn = "0" -- don't show fold in column
o.foldmethod = "manual"
o.foldtext = "v:lua.matsu_foldtext()"
--
o.pumborder = "solid"
o.autocomplete = false
o.completeopt = "menu,menuone,noinsert,popup,fuzzy"
o.complete = ".,w,o,Fv:lua.snippet_complete"
o.completefunc = "v:lua.snippet_complete"
-- o.previewpopup = "height:10,width:60,border:bold" -- doesn't work
o.wildoptions = o.wildoptions .. ",fuzzy"

------------------------------------------------------------------------------
-- keymap
------------------------------------------------------------------------------
-- see :h map-table :h default-mappings ,"": n o x

keymap("i", "jk", "<esc>")
keymap("", "<Space>", "<Nop>")
-- discard text
keymap("x", "d", '"_d')
-- L H
keymap("", "L", "g_")
keymap("", "H", "^")
-- always use global mark
keymap("", "'", "`")
-- copy to '+'
keymap("", "<leader>y", [["+y]])
-- q %
keymap({ "n", "v" }, "q", "%")
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("matsu.keymapq", { clear = true }),
    callback = function()
        keymap("n", "%", "q")
    end,
})
-- J K
keymap({ "n", "x" }, "K", "<ScrollWheelUp>")
keymap({ "n", "x" }, "J", "<ScrollWheelDown>")
keymap({ "n" }, "<bar>", "mzJ`z")
keymap({ "x" }, "<bar>", "J")
-- []
keymap({ "n", "x" }, ";", "m")
keymap("n", "m", "]", { remap = true })
keymap("n", ",", "[", { remap = true })

--- pair
keymap("i", "{<cr>", "{<cr>}<esc>O")

--- move line
keymap({ "n", "i" }, "<M-->", "<cmd>m .+1<CR>")
keymap({ "n", "i" }, "<M-=>", "<cmd>m .-2<CR>")
keymap("x", "<M-->", ":m '>+1<CR>gv=gv")
keymap("x", "<M-=>", ":m '<-2<CR>gv=gv")
keymap("x", "<", "<gv")
keymap("x", ">", ">gv")

--- cmd edit
keymap("c", "<C-k>", "<Up>")
keymap("c", "<C-j>", "<Down>")
keymap("c", "<C-f>", "<Right>")
keymap("c", "<C-b>", "<Left>")
keymap("c", "<C-a>", "<Home>")

--- complete
keymap({ "i", "c" }, "<C-l>", function()
    return tonumber(vim.fn.pumvisible()) ~= 0 and "<C-y>" or "<C-l>"
end, { expr = true })

--- save
keymap({ "n", "i", "x" }, "<M-s>", "<esc><cmd>w<cr>")

--- hi current word
keymap("n", "<leader>,", ":let @/ = expand('<cword>') | set hlsearch<cr>")

--- search
keymap("n", "/", "ms/")
keymap("n", "\\c", "ms:<c-u>lvimgrep // % <bar>lw<s-left><left><left><left><left>")
keymap("n", "\\v", "mS:<c-u>noau vimgrep /C/j **<left><left><left><left><left>")
keymap(
    "n",
    "\\b",
    [[mS:<c-u>cexpr []<bar>exe 'bufdo silent! noau vimgrepadd/\C/j %'<bar>botright copen<s-left><s-left><left><left><left>]]
)
keymap("c", "<BS>", "(getcmdtype() =~ '[/?]' && getcmdline() == '') ? '\\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>' : '<BS>'")

--- change dir
keymap("n", "cdb", "<cmd>lcd %:h<bar>verbose pwd<cr>")
keymap("n", "cdg", function()
    local dir = vim.fs.root(vim.fn.expand("%"), ".git")
    vim.cmd.lcd(dir)
    vim.notify("lcd: " .. dir, vim.log.levels.WARN)
end)
keymap("n", "cdu", "<cmd>lcd ..<bar>verbose pwd<cr>")
keymap("n", "cd-", "<cmd>lcd -<bar>verbose pwd<cr>")

--- format
keymap("n", "gqax", "<cmd>%!tidy -q -i -xml -utf8<cr>")
keymap("n", "gqah", "<cmd>%!tidy -q -i -ashtml -utf8<cr>")
keymap("n", "gqaj", "<cmd>%!python3 -m json.tool<cr>")

--- insert ...
keymap({ "i", "c" }, "<m-/>", "<c-r>=expand('%:.:h', 1)<cr>")
keymap({ "i", "c" }, "<c-r>?", "<c-r>=substitute(getreg('/'), '[<>\\]', '', 'g')<cr>")
keymap({ "i", "c" }, "<c-r>b", "<c-r>=fnamemodify(@%, ':t')<cr>")

--- show buffer
keymap(
    { "n", "x" },
    "ms",
    "v:count ? ':<c-u>'.v:count.'buffer<cr>' : ':set nomore<bar>ls<bar>set more<cr>:buffer<space>'",
    { expr = true }
)

--- terminal
keymap("t", "<C-[>", [[<C-\><C-N>]])
keymap("t", "<Esc>", "<Esc>") -- Map ESC to ESC, so we have a way to send literal ESC.

--- useless sS
keymap("", "s", "<nop>")
keymap("", "S", "<nop>")
keymap("", "sn", "<cmd>tab split<cr>")
keymap("", "sw", "<cmd>tabc<cr>")
keymap("", "sjalways use global mark", "gt")
keymap("", "sk", "gT")
keymap("", "so", function()
    if vim.v.count and vim.v.count > 0 then
        vim.fn.setqflist({})
        return
    end

    local has_quickfix = false

    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            has_quickfix = true
            break
        end
    end

    if has_quickfix then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end)
keymap("n", "sO", function()
    if vim.v.count and vim.v.count > 0 then
        vim.fn.setloclist(0, {})
        return
    end

    local has_loclist = false

    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.loclist == 1 then
            has_loclist = true
            break
        end
    end

    if has_loclist then
        vim.cmd("lclose")
    else
        vim.cmd("lopen")
    end
end)

------------------------------------------------------------------------------
-- command
------------------------------------------------------------------------------

command("Bufpwd", function(args)
    local file = vim.api.nvim_buf_get_name(0)
    local message = "Bufpwd: " .. file

    if args.bang then
        local dir = vim.fs.dirname(file)
        message = "cd: " .. dir
        vim.api.nvim_set_current_dir(dir)
    end

    vim.notify(message, vim.log.levels.WARN)
end, { bang = true })

local scratch_file

command("S", function(args)
    local dir = vim.fs.joinpath(vim.fn.stdpath("state"), "scratch")

    if not vim.uv.fs_stat(dir) then
        vim.fs.mkdir(dir)
    end

    if args.bang then
        vim.cmd.edit(dir)
        return
    end

    local edit = function(file)
        vim.cmd.edit(file)

        local scratch_buf = vim.api.nvim_get_current_buf()

        keymap("n", "<localleader>d", function()
            vim.api.nvim_buf_delete(scratch_buf, { force = true })
            vim.fs.rm(file, { force = true })
        end, { buf = scratch_buf })
    end

    if scratch_file and (not args.args or args.args == "") then
        edit(scratch_file)
        return
    end

    local ext = args.args and args.args ~= "" and args.args or "lua"

    scratch_file = vim.fs.joinpath(dir, os.date("%B_%d_%I_%M_%S") .. "." .. ext)
    edit(scratch_file)
end, { nargs = "?", bang = true })

------------------------------------------------------------------------------
-- plugin/lsp/colorscheme
------------------------------------------------------------------------------

require("plugin")
require("lspconfig")

ok, _ = pcall(vim.cmd.so, "~/.local/state/matsu/colo.vim")

if not ok then
    vim.cmd.colo("retrobox")
end

require("vim._core.ui2").enable({ msg = { target = "cmd" } })
