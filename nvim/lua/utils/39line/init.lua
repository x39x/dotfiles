return function()
        local utils = require("heirline.utils")
        local tabline = require("utils.39line.tabline")
        local statusline = require("utils.39line.statusline")

        local function setup_colors()
                return {

                        heirline_diagnostic_error = utils.get_highlight("DiagnosticError").fg or "",
                        heirline_diagnostic_warn = utils.get_highlight("DiagnosticWarn").fg or "",
                        heirline_diagnostic_info = utils.get_highlight("DiagnosticInfo").fg or "",
                        heirline_diagnostic_hint = utils.get_highlight("DiagnosticHint").fg or "",

                        heirline_git_branch = utils.get_highlight("Keyword").fg or "",
                        heirline_git_added = utils.get_highlight("diffAdded").fg or "",
                        heirline_git_removed = utils.get_highlight("diffRemoved").fg or "",
                        heirline_git_modified = utils.get_highlight("diffChanged").fg or "",

                        heirline_filename = utils.get_highlight("Keyword").fg or "",
                        heirline_workdir = utils.get_highlight("Keyword").fg or "",
                        heirline_buftype = utils.get_highlight("Keyword").fg or "",
                }
        end
        require("heirline").load_colors(setup_colors)
        vim.api.nvim_create_augroup("Heirline", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                        utils.on_colorscheme(setup_colors)
                end,
                group = "Heirline",
        })
        vim.api.nvim_create_autocmd("bufenter", {
                callback = function(args)
                        local bufnr = args.buf
                        local file = vim.api.nvim_buf_get_name(bufnr)

                        -- ignore term、nofile、quickfix
                        if file == "" or vim.bo[bufnr].buftype ~= "" then
                                vim.b[bufnr].is_git_repo = false
                                return
                        end
                        local buffer_path = vim.fn.fnamemodify(file, ":h")

                        local result = vim.system(
                                { "git", "-C", buffer_path, "rev-parse", "--is-inside-work-tree" },
                                { text = true }
                        ):wait()
                        local git_status = result.stdout and vim.split(result.stdout, "\n")[1] or nil
                        vim.b[bufnr].is_git_repo = git_status == "true"
                end,
                desc = "Set vim.b[bufnr].is_git_repo based on Git repository status",
        })

        return {
                colors = setup_colors(),
                statusline = statusline,
                tabline = tabline,
        }
end
