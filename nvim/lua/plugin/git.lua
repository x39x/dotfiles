local keymap = vim.keymap.set
--- gitsigns
require("gitsigns").setup({
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
    },
    signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
    },
    signs_staged_enable = true,

    -- signcolumn = false,
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            keymap(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
            else
                gitsigns.nav_hunk("next")
            end
        end)

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
            else
                gitsigns.nav_hunk("prev")
            end
        end)

        map("n", "<leader>gq", gitsigns.setqflist, { desc = "gitsigns  setqflist" })
        map("n", "<leader>gQ", function()
            gitsigns.setqflist("all")
        end, { desc = "gitsigns  setqflist all" })
        map("n", "<leader>gl", gitsigns.toggle_signs, { desc = "gitsigns  toggle_signs" })
        map("n", "<leader>gL", gitsigns.toggle_linehl, { desc = "gitsigns  toggle_linehl" })

        map("n", "<leader>gb", function()
            gitsigns.blame_line({ full = true })
        end)
        map("n", "<leader>gB", gitsigns.toggle_current_line_blame, { desc = "gitsigns  toggle_current_line_blame" })

        map("n", "<leader>gp", gitsigns.preview_hunk_inline, { desc = "gitsigns  preview_hunk_inline" })
        map("n", "<leader>gP", gitsigns.preview_hunk)
        map("v", "<leader>gs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("v", "<leader>gr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("n", "<leader>gs", gitsigns.stage_hunk)
        map("n", "<leader>gr", gitsigns.reset_hunk)
        map("n", "<leader>gS", gitsigns.stage_buffer)
        map("n", "<leader>gR", gitsigns.reset_buffer)
        -----------------------------------=====================================
        -----------------------------------=====================================
    end,
})

--- neogit
local neogit = require("neogit")
neogit.setup({
    disable_line_numbers = false,
    mappings = {
        status = {
            ["s"] = false,
            ["S"] = false,
            ["o"] = "Stage",
            ["O"] = "StageUnstaged",
            ["T"] = "OpenTree",
        },
    },
})

keymap("n", "<leader>gn", function()
    if not vim.b[0].gitsigns_head or vim.b[0].gitsigns_head == "" then
        return
    end
    neogit.open()
end)
keymap("n", "<leader>gN", function()
    if not vim.b[0].gitsigns_head or vim.b[0].gitsigns_head == "" then
        return
    end
    neogit.open({ kind = "vsplit" })
end)
