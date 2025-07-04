--NOTE: options
local o = vim.o
local keymap = vim.keymap.set
local cmd = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local key_opts = { noremap = true, silent = true }

o.backup = false
o.swapfile = false
o.autochdir = false
o.splitright = true
o.splitbelow = true
o.number = true
o.numberwidth = 3
o.smartindent = true
o.copyindent = true -- 自动缩进时，复制已有的行的缩进结构
o.ignorecase = true
o.smartcase = true
--
o.wrap = false --no wrap
o.linebreak = true -- wrap don't break words
o.scrolloff = 5
o.showtabline = 2 -- tabline,0:no
o.laststatus = 3 --  global statusline
o.signcolumn = "yes" -- sign colume
o.list = true
o.listchars = "tab:  ,extends:⟩,precedes:⟨,trail:·" --("eol:↴,tab:»·,trail:·")
o.fillchars = "eob: " -- hide  "~"
--set fold
o.foldenable = true
o.foldcolumn = "0" --show fold in line number
o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
o.foldlevelstart = 99
--
o.expandtab = true -- tab->spaces
o.shiftwidth = 8
o.tabstop = 8
o.cursorline = false
o.conceallevel = 0 -- Hide * ..., 0: no ,1: leave space, 2:hide space

--NOTE: //
vim.g.rust_recommended_style = 0
vim.g.clipboard = {
        name = "OSC 52",
        copy = {
                ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
                ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
                ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
                ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
        },
}
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.filetype.add({
        pattern = {
                [".*.typ"] = "typst",
                [".*.mdx"] = "markdown",
                [".*profile"] = "bash",
        },
})

--NOTE: LSP config

vim.keymap.del("", "grn")
vim.keymap.del("", "gra")
vim.keymap.del("", "grr")
vim.keymap.del("", "gri")
vim.diagnostic.config({
        virtual_text = false,
        signs = {
                text = {
                        -- ▎  󰌕  ✎           
                        [vim.diagnostic.severity.ERROR] = "▎",
                        [vim.diagnostic.severity.WARN] = "▎",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = "",
                },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
                focusable = false,
                style = "minimal",
                border = "single",
                source = "if_many",
                header = "",
                prefix = "",
        },
})
-- set lsp float window border
-- - "solid": Adds padding by a single whitespace cell.
local orig = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "solid"
        return orig(contents, syntax, opts, ...)
end

--NOTE: lazy
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
                vim.api.nvim_echo({
                        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                        { out, "WarningMsg" },
                        { "\nPress any key to exit..." },
                }, true, {})
                vim.fn.getchar()
                os.exit(1)
        end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        spec = {
                { import = "plugins" },
        },
        ui = {
                border = "single",
        },
        install = {
                colorscheme = { "39light" },
        },
        performance = {
                rtp = {
                        disabled_plugins = {
                                "2html_plugin",
                                "tohtml",
                                "getscript",
                                "getscriptPlugin",
                                "gzip",
                                "logipat",
                                "netrw",
                                "netrwPlugin",
                                "netrwSettings",
                                "netrwFileHandlers",
                                "matchit",
                                "tar",
                                "tarPlugin",
                                "rrhelper",
                                "spellfile_plugin",
                                "vimball",
                                "vimballPlugin",
                                "zip",
                                "zipPlugin",
                                "tutor",
                                "rplugin",
                                "syntax",
                                "synmenu",
                                "optwin",
                                "compiler",
                                "bugreport",
                                "ftplugin",
                        },
                },
        },
})

--NOTE: mode
-- insert_mode       = "i",
-- normal_mode       = "n",
-- term_mode         = "t",
-- visual_mode       = "v",
-- visual_block_mode = "x",
-- command_mode      = "c",
-- operator_mode     = "o",
-- select_mode       = "s"

keymap({ "i", "n", "x" }, "<M-s>", function()
        vim.cmd("stopinsert")
        vim.cmd("w")
end, key_opts)
keymap("n", "<leader>s", require("utils.M").insert_line, key_opts)
keymap("n", "<leader>rt", require("utils.M").tmux_tab_run, { desc = "Send cmd to  window runner" })
keymap("n", "<leader>m", require("utils.M").tmux_pane_run, { desc = "Send cmd to tmux pane" })

keymap("i", "jk", "<esc>", key_opts)
keymap({ "n", "o" }, "L", "$", key_opts)
keymap({ "x" }, "L", "$h", key_opts)
keymap("", "H", "^", key_opts)
-- keymap("", "K", "2k", key_opts)
keymap("", "J", "2j", key_opts)
keymap("", "|", "J", key_opts)
keymap("", "q", "%", key_opts)
keymap("", "%", "q", key_opts)
keymap("n", ";k", "<cmd>nohl<CR>", key_opts)
keymap("n", ";j", require("utils.M").highlightCword, key_opts)
--buffers
keymap({ "n" }, "<leader>l", "<cmd>bn<cr>", key_opts)
keymap({ "n" }, "<leader>h", "<cmd>bp<cr>", key_opts)
keymap({ "n" }, "<leader>w", "<cmd>bd<cr>", key_opts)
-- Resize with arrows
keymap({ "n", "x" }, "<M-Up>", "<cmd>resize +2<CR>", key_opts)
keymap({ "n", "x" }, "<M-Down>", "<cmd>resize -2<CR>", key_opts)
keymap({ "n", "x" }, "<M-Left>", "<cmd>vertical resize -2<CR>", key_opts)
keymap({ "n", "x" }, "<M-Right>", "<cmd>vertical resize +2<CR>", key_opts)
-- Move  line / code block
keymap({ "n", "i" }, "<M-->", "<cmd>m .+1<CR>==", key_opts)
keymap({ "n", "i" }, "<M-=>", "<cmd>m .-2<CR>==", key_opts)
keymap({ "x" }, "<M-->", ":m '>+1<cr>gv=gv", key_opts)
keymap({ "x" }, "<M-=>", ":m '<-2<cr>gv=gv", key_opts)
keymap({ "n" }, "<", "<<", key_opts)
keymap({ "n" }, ">", ">>", key_opts)
keymap({ "x" }, "<", "<gv", key_opts)
keymap({ "x" }, ">", ">gv", key_opts)
--Plugin
keymap({ "n", "x" }, "f", require("flash").jump, key_opts)
keymap("n", "<leader>n", require("nvim-tree.api").tree.open, key_opts)
keymap("n", "<Leader>fr", require("telescope.builtin").builtin, key_opts)
keymap("n", "<Leader>fm", require("telescope.builtin").marks, key_opts)
keymap("n", "<leader>fh", require("telescope.builtin").oldfiles, key_opts)
keymap("n", "<leader>fl", require("telescope").extensions.live_grep_args.live_grep_args, key_opts)
keymap("n", "<leader>ff", require("telescope.builtin").fd, key_opts)
keymap("n", "<Leader>fs", require("telescope.builtin").colorscheme, key_opts)
keymap("n", "<leader>fp", require("utils.zoxide").zoxide, key_opts)
keymap("n", "<leader>fw", require("telescope.builtin").current_buffer_fuzzy_find, key_opts)
keymap({ "n" }, "<leader>M", require("utils.M").run, key_opts)
keymap({ "n" }, "tx", require("utils.M").trouble.close, key_opts)
keymap({ "n" }, "tj", require("utils.M").trouble.next, key_opts)
keymap({ "n" }, "tk", require("utils.M").trouble.prev, key_opts)
keymap("t", "<C-\\>", "<C-\\><C-N>", key_opts)
-- cmd mode
keymap("c", "<C-p>", "<Up>")
keymap("c", "<C-n>", "<Down>")
keymap("c", "<C-f>", "<Right>")
keymap("c", "<C-b>", "<Left>")
keymap("c", "<C-a>", "<Home>")

--NOTE: user command
cmd("FormatJSON", "%!python3 -m json.tool", {})
cmd("Bpwd", require("utils.M").BufferPwd, {})
cmd("CBpwd", require("utils.M").cdBufferPwd, {})

--NOTE: autocmd
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
        pattern = { "json", "jsonc", "json5", "markdown", "typst", "python", "vue", "javascript", "fish", "sh", "bash" },
        group = vim.api.nvim_create_augroup("SHIFTWIDTH", { clear = true }),
        callback = function(args)
                local _ = args.buf
                vim.bo[0].shiftwidth = 4
                vim.bo[0].tabstop = 4
                vim.bo[0].expandtab = true
        end,
})

-- NOTE: colorscheme
require("utils.colorscheme").set()
