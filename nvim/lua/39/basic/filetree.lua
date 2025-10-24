vim.pack.add({
        "https://github.com/nvim-tree/nvim-tree.lua",

        "https://github.com/simonmclean/triptych.nvim",
        "https://github.com/antosha417/nvim-lsp-file-operations", -- optional LSP integration

        "https://github.com/stevearc/oil.nvim",
})

require("oil").setup({
        default_file_explorer = false,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        watch_for_changes = true,
        use_default_keymaps = false,
        keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["L"] = "actions.select",
                ["H"] = { "actions.parent", mode = "n" },
                ["q"] = { "actions.close", mode = "n" },
                [","] = { "actions.open_cwd", mode = "n" },
                ["`"] = { "actions.cd", mode = "n" },
                ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                ["="] = "actions.open_external",
                ["gs"] = { "actions.change_sort", mode = "n" },
                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["<C-p>"] = { "actions.preview", mode = "n" },
                ["<C-R>"] = { "actions.refresh", mode = "n" },
                ["<C-v>"] = { "actions.select", opts = { vertical = true } },
                ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
        },
        view_options = {
                show_hidden = true,
        },
        float = {
                padding = 0,
                border = "single",
                get_win_title = nil,
                preview_split = "auto",
                override = function(conf)
                        local ui = vim.api.nvim_list_uis()[1]
                        local sidebar_width = math.floor(ui.width * 0.17)

                        -- send to nvim_open_win.
                        conf = {
                                relative = "editor",
                                width = sidebar_width,
                                height = ui.height,
                                row = 0,
                                col = ui.width - sidebar_width,
                                style = "minimal",
                                border = "single",
                        }

                        return conf
                end,
        },
})

require("triptych").setup()

local on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local keymap_set = vim.keymap.set
        local keymap_del = vim.keymap.del

        local function make_opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        local function parent_root_and_collapse()
                api.tree.change_root_to_parent()
                api.tree.collapse_all()
        end

        api.config.mappings.default_on_attach(bufnr)

        keymap_del("n", "f", { buffer = bufnr })
        keymap_del("n", "F", { buffer = bufnr })
        keymap_del("n", "y", { buffer = bufnr })
        keymap_del("n", "d", { buffer = bufnr })
        keymap_del("n", "gy", { buffer = bufnr })
        keymap_del("n", "P", { buffer = bufnr })
        keymap_del("n", "s", { buffer = bufnr })
        keymap_del("n", "x", { buffer = bufnr })
        keymap_del("n", "c", { buffer = bufnr })

        keymap_set("n", "l", api.tree.change_root_to_node, make_opts("next"))
        keymap_set("n", "i", api.node.navigate.parent, make_opts("parent"))
        keymap_set("n", "h", parent_root_and_collapse, make_opts("pre"))
        keymap_set("n", "yy", api.fs.copy.node, make_opts("copy"))
        keymap_set("n", "dd", api.fs.remove, make_opts("delete"))
        keymap_set("n", "cc", api.fs.cut, make_opts("delete"))
        keymap_set("n", "=", api.node.run.system, make_opts("open system"))
        keymap_set("n", "Y", api.fs.copy.absolute_path, make_opts("absolute_path"))
end

require("nvim-tree").setup({
        on_attach = on_attach,
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        update_focused_file = {
                enable = true,
                update_root = false,
        },
        view = {
                adaptive_size = false,
                side = "right",
                width = "17%",
                preserve_window_proportions = true,
        },
        filesystem_watchers = { enable = true },
        actions = {
                open_file = {
                        resize_window = true,
                        quit_on_open = true,
                },
        },
        renderer = {
                root_folder_label = false,
                highlight_git = true,
                highlight_opened_files = "none",
                icons = { show = { git = false } },
        },
        filters = {
                dotfiles = false,
                custom = {
                        ".DS_Store",
                },
        },
})
