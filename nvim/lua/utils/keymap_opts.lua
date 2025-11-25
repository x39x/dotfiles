return function(opts)
        opts = opts or {}
        local default_opts = {
                noremap = true,
                silent = true,
        }
        return vim.tbl_deep_extend("force", default_opts, opts)
end
