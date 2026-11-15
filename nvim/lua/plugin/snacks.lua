local keymap = vim.keymap.set
local h = require("utils.header").X
local Actions = require("snacks.explorer.actions")

local explorer = {
    diagnostics = false,
    auto_close = false,
    layout = {
        preview = false,
        layout = {
            backdrop = false,
            box = "vertical",
            border = "left",
            col = -1,
            width = 40,
            min_width = 40,
            height = 0,
            {
                win = "input",
                height = 1,
                -- { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                border = { "─", "─", "─", " ", "─", "─", "─", " " },

                title = "{title} {live} {flags}",
                title_pos = "center",
            },
            { win = "list", border = "top" },
            { win = "preview", title = "{preview}", height = 0.4, border = "top" },
        },
    },
    win = {
        list = {
            keys = {
                ["<cr>"] = "confirm",
                ["o"] = "confirm",
                ["l"] = "confirm",
                ["O"] = "explorer_open",
                ["<c-t>"] = "tcd",
                ["<c-l>"] = "cd",
                ["<C-c>"] = { "cancel", mode = { "i", "n" } },
            },
        },
        input = {
            keys = {
                ["<C-c>"] = { "cancel", mode = { "i", "n" } },
            },
        },
    },
}

local zoxide = {

    confirm = { "cd", "close" },
    layout = { preset = "vscode" },
    win = {
        input = {
            keys = {
                ["<c-t>"] = { "t", mode = { "i", "n" } },
                ["<c-l>"] = { "l", mode = { "i", "n" } },
            },
        },
    },
    actions = {
        t = function(picker, item)
            picker:close()
            vim.cmd.tcd(item.file)
        end,
        l = function(picker, item)
            picker:close()
            vim.cmd.lcd(item.file)
        end,
    },
}

local p = {
    sources = {
        files = { layout = { preset = "vscode" } },
        smart = { layout = { hidden = { "preview" } } },
        recent = { layout = { preset = "vscode" } },
        buffers = { layout = { preset = "vscode" } },
        colorschemes = { layout = { preset = "vscode" } },
        select = { layout = { preset = "vscode" } },
        grep = { layout = { preset = "ivy" } },
        explorer = explorer,
        zoxide = zoxide,
    },

    layout = {
        layout = { backdrop = false },
    },

    win = {
        -- input window
        input = {
            keys = {
                ["/"] = false,
                ["<c-a>"] = { "<home>", mode = { "i" }, expr = true },
                ["<c-e>"] = { "<end>", mode = { "i" }, expr = true },
                ["<c-b>"] = { "<left>", mode = { "i" }, expr = true },
                ["<c-f>"] = { "<right>", mode = { "i" }, expr = true },

                ["<C-c>"] = { "cancel", mode = { "i", "n" } },
                ["<c-y>"] = { "select_all", mode = { "n", "i" } },
                ["<c-,>"] = { "cycle_win", mode = { "n", "i" } },

                ["<c-j>"] = { "history_forward", mode = { "i", "n" } },
                ["<c-k>"] = { "history_back", mode = { "i", "n" } },
                ["<c-;>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<c-'>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<a-q>"] = { "loclist", mode = { "i", "n" } },
            },
        },
        -- result list window
        list = {
            keys = {
                ["/"] = false,
                ["<c-;>"] = "preview_scroll_up",
                ["<c-'>"] = "preview_scroll_down",

                ["<c-y>"] = "select_all",
                ["<c-.>"] = "toggle_hidden",
                ["<c-,>"] = "cycle_win",
                ["<a-q>"] = { "loclist", mode = { "i", "n" } },
            },
        },
        preview = {
            keys = {
                ["/"] = false,
                ["<c-,>"] = "cycle_win",
            },
        },
    },
    icons = {
        files = {
            dir = " ",
            dir_open = " ", --
            file = " ",
        },
        ui = {
            live = "",
        },
    },
}

require("snacks").setup({
    picker = p,
    indent = {
        indent = { hl = "Conceal" },
        animate = { enabled = false },
        scope = { enabled = false },
    },
    win = {
        backdrop = false,
        wo = {
            winhighlight = "Normal:Normal,NormalNC:NormalNC,FloatBorder:SnacksPickerBorder",
        },
    },
    scratch = {
        win = {
            wo = {
                winhighlight = "Normal:Normal,NormalNC:NormalNC,FloatBorder:SnacksPickerBorder",
            },
        },
    },
    dashboard = {
        preset = {
            header = h.art,
        },
        sections = {
            { section = "header", padding = h.padding },
        },
    },
})
local function open_dir()
    local cw = vim.api.nvim_get_current_win()

    local e = Snacks.picker.get({ source = "explorer" })[1]
    local iw = e and e.layout and e.layout.opts.wins.input.win or -1
    local lw = e and e.layout and e.layout.opts.wins.list.win or -1

    if iw == cw or lw == cw then
        Snacks.picker.explorer()
        return
    elseif vim.api.nvim_win_is_valid(lw) then
        vim.api.nvim_set_current_win(lw)
        return
    else
        Snacks.picker.explorer({
            follow_file = false,
            auto_close = false,
            hidden = true,
        })
    end
end

local function focus_file()
    local Tree = require("snacks.explorer.tree")
    local file = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
    local e = Snacks.picker.get({ source = "explorer" })[1]

    local function reveal()
        local cwd = e:cwd()
        if not Tree:in_cwd(cwd, file) then
            for parent in vim.fs.parents(file) do
                if Tree:in_cwd(parent, cwd) then
                    e:set_cwd(parent)
                    break
                end
            end
        end
        Tree:open(file)
        Actions.update(e, { target = file, refresh = true })
    end

    if e then
        reveal()

        local iw = e and e.layout and e.layout.opts.wins.input.win or -1
        local lw = e and e.layout and e.layout.opts.wins.list.win or -1
        local cw = vim.api.nvim_get_current_win()

        if iw ~= cw and lw ~= cw and vim.api.nvim_win_is_valid(lw) then
            vim.api.nvim_set_current_win(lw)
            return
        end
    else
        e = Snacks.explorer.open({ on_show = reveal, auto_close = true, hidden = true })
    end
    return e
end

---========================================================================
-- keymap
---========================================================================

-- stylua: ignore start
keymap("n", "sr", function() Snacks.picker() end)
keymap("n", "sf", function() Snacks.picker.files() end)
keymap("n", "ss", function() Snacks.picker.smart() end)
keymap("n", "sh", function() Snacks.picker.recent() end)
keymap("n", "sd", function() Snacks.picker.buffers() end)
keymap("n", "sx", function() Snacks.picker.colorschemes() end)
keymap("n", "sl", function() Snacks.picker.grep() end)
keymap("n", "sp", function() Snacks.picker.zoxide() end)
keymap("n", "sm", function() Snacks.picker.marks() end)
keymap("n", "se", function() Snacks.picker.resume() end)
-- stylua: ignore end
keymap("n", "<leader>w", Snacks.bufdelete.delete)
keymap("n", "<leader>Wa", Snacks.bufdelete.all)
keymap("n", "<leader>Wo", Snacks.bufdelete.other)
keymap("n", "<leader>Wi", Snacks.bufdelete.invisible)
keymap("n", "<leader>n", open_dir)
keymap("n", "<leader>m", focus_file)

---========================================================================
-- hi
---========================================================================
local function hi()
    vim.api.nvim_set_hl(0, "SnacksPicker", { link = "Normal" })
    vim.api.nvim_set_hl(0, "SnacksPickerCol", { link = "Normal" })
    vim.api.nvim_set_hl(0, "SnacksPickerIconFile", { link = "Normal" })
    vim.api.nvim_set_hl(0, "SnacksNormal", { link = "Normal" })
    vim.api.nvim_set_hl(0, "SnacksNormalNC", { link = "Normal" })
    vim.api.nvim_set_hl(0, "SnacksPickerTree", { link = "Conceal" })
    vim.api.nvim_set_hl(0, "SnacksPickerCursorLine", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "SnacksPickerBoxCursorLine", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "SnacksPickerInputCursorLine", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "SnacksPickerPreviewCursorLine", { link = "CursorLine" })

    if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "SnacksPickerBorder" })) then
        vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#6F777E", bg = "none" })
        vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = "#D3302F", bg = "none" })
    end
end

local ag = vim.api.nvim_create_augroup("matsu.snacks", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter" }, {
    group = ag,
    callback = function()
        hi()
    end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
    group = ag,
    callback = function()
        hi()
    end,
})
