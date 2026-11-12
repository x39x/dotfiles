vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/igorlfs/nvim-dap-view",
    "https://github.com/windwp/nvim-ts-autotag",
    "https://github.com/brenoprata10/nvim-highlight-colors",
}, { load = function() end, confirm = false })

vim.api.nvim_create_user_command("Pad", function(opts)
    local pack = opts.args

    if pack == "" then
        return
    elseif pack == "dap" then
        vim.cmd.packadd("nvim-dap-view")
        vim.cmd.packadd("nvim-dap")
        require("plugin.dapconfig")
    elseif pack == "autotag" then
        vim.cmd.packadd("nvim-ts-autotag")
        require("nvim-ts-autotag").setup()
    elseif pack == "color" then
        vim.cmd.packadd("nvim-highlight-colors")
        require("nvim-highlight-colors").setup({
            render = "background",
            enable_named_colors = false,
            enable_tailwind = true,
        })
    else
        return
    end
end, {
    nargs = "?",
    complete = function(arglead)
        local packs = { "dap", "autotag", "color" }
        return vim.tbl_filter(function(pack)
            return pack:find("^" .. vim.pesc(arglead)) ~= nil
        end, packs)
    end,
})
