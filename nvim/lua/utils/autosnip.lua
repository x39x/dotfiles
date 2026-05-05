local M = {}

function M.add(abbr, template, move, opts)
        local trigger_key = abbr:sub(-1)
        local abbr_len = #abbr
        opts = opts or { eol = true }
        opts = vim.tbl_extend("force", { eol = true }, opts or {})

        vim.keymap.set("i", trigger_key, function()
                -- insert the typed key first
                vim.api.nvim_feedkeys(trigger_key, "n", false)

                vim.schedule(function()
                        local col = vim.fn.col(".") - 1
                        local line = vim.fn.getline(".")

                        -- only trigger at end of line
                        if opts.eol and col < #line then
                                return
                        end

                        -- do not trigger inside a word
                        local next_char = line:sub(col + 1, col + 1)
                        if next_char ~= "" and next_char:match("%w") then
                                return
                        end

                        -- text before cursor
                        local before_cursor = line:sub(1, col)

                        -- not enough length
                        if #before_cursor < abbr_len then
                                return
                        end

                        -- char before abbr must be whitespace (or start of line)
                        local boundary_idx = #before_cursor - abbr_len
                        if boundary_idx > 0 then
                                local prev_char = before_cursor:sub(boundary_idx, boundary_idx)
                                if not prev_char:match("%s") then
                                        return
                                end
                        end

                        -- match abbrright before cursor
                        local current = before_cursor:sub(-abbr_len)
                        if current ~= abbr then
                                return
                        end

                        -- delete abbr
                        vim.api.nvim_feedkeys(string.rep("\b", abbr_len), "n", false)

                        -- insert template
                        vim.api.nvim_feedkeys(template, "n", false)

                        -- move cursor to desired position
                        local move_keys = vim.api.nvim_replace_termcodes(move, true, false, true)
                        vim.api.nvim_feedkeys(move_keys, "n", false)
                end)
        end, { noremap = true, silent = true, buf = opts.buf })
end

return M
