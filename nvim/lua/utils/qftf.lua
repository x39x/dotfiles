-- https://github.com/vim/vim/issues/4425#issuecomment-640123274
-- QuickFixTextFunc
return function(info)
        local qfl = info.quickfix == 1 and vim.fn.getqflist({ id = info.id, items = 0 }).items
                or vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items

        --  计算合适的 max_width
        local lens = {}
        for _, e in ipairs(qfl) do
                local fname = vim.fn.fnamemodify(vim.fn.bufname(e.bufnr), ":o")
                table.insert(lens, vim.fn.strchars(fname, true))
        end
        table.sort(lens)
        local idx = math.floor(#lens * 0.75)
        local max_width = lens[idx] + 2

        -- clamp 为 [10, 39] 之间
        max_width = math.min(math.max(max_width, 10), 39)

        local result = {}

        for i = info.start_idx, info.end_idx do
                local e = qfl[i]
                local fname = vim.fn.fnamemodify(vim.fn.bufname(e.bufnr), ":o")

                -- 截断处理
                if vim.fn.strchars(fname, true) > max_width then
                        fname = fname:sub(1, max_width - 1) .. "…"
                else
                        fname = string.format("%-" .. max_width .. "s", fname)
                end

                local pos = e.lnum .. ":" .. e.col

                local line = string.format("%s   %-8s   %s", fname, pos, e.text)
                table.insert(result, line)
        end

        return result
end
