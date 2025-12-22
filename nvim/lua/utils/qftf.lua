-- https://github.com/vim/vim/issues/4425#issuecomment-640123274
-- QuickFixTextFunc
return function(info)
        local qfl = info.quickfix == 1 and vim.fn.getqflist({ id = info.id, items = 0 }).items
                or vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items

        --  计算合适的 max_width
        local lens = {}
        for _, e in ipairs(qfl) do
                local fname = vim.fn.fnamemodify(vim.fn.bufname(e.bufnr), ":o") or ""
                table.insert(lens, vim.fn.strchars(fname, true))
        end
        table.sort(lens)
        local idx = math.floor((#lens + 1) * 0.75)
        local max_width = lens[idx] + 2

        -- local max_width = 20

        -- clamp 为 [10, 39] 之间
        max_width = math.min(math.max(max_width, 10), 39)

        local result = {}

        for i = info.start_idx, info.end_idx do
                local e = qfl[i]
                local fname = vim.fn.fnamemodify(vim.fn.bufname(e.bufnr), ":o") or ""

                if fname ~= "" then
                        -- 截断处理
                        if vim.fn.strchars(fname, true) > max_width then
                                fname = fname:sub(1, max_width - 1) .. "…"
                        else
                                fname = string.format("%-" .. max_width .. "s   ", fname)
                        end
                end

                local pos = ""
                if e.lnum and e.col then
                        pos = string.format("%-7s   ", e.lnum .. ":" .. e.col)
                end

                -- multiple lines error
                if vim.trim(pos) == "0:0" then
                        pos = string.format("%-7s", "")
                        fname = string.format("%-" .. max_width .. "s   ", "")
                end

                -- no filename and position
                if vim.trim(pos) == "" and vim.trim(fname) == "" then
                        pos = ""
                        fname = " "
                end

                local text = e.text or ""
                local line = fname .. pos .. text
                table.insert(result, line)
        end

        return result
end
