_G.matsu_foldtext = function()
    local start_line = vim.v.foldstart
    local end_line = vim.v.foldend
    local lines = end_line - start_line + 1

    local text = vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, true)[1] or ""
    text = text:gsub("\t", string.rep(" ", vim.bo[0].tabstop))
    return text .. "   󰁂 " .. lines .. " lines "
end

--NOTE:  https://github.com/vim/vim/issues/4425#issuecomment-640123274
-- QuickFixTextFunc

local function display_width(s)
    return vim.api.nvim_strwidth(s)
end

-- 按终端显示宽度截断，避免中文文件名被切坏或算错宽度。
local function truncate(s, width)
    if display_width(s) <= width then
        return s
    end

    local ellipsis = "…"
    local limit = width - display_width(ellipsis)
    if limit <= 0 then
        return ellipsis
    end

    local prefix = ""
    for i = 0, vim.fn.strchars(s) - 1 do
        local char = vim.fn.strcharpart(s, i, 1)
        if display_width(prefix .. char) > limit then
            break
        end
        prefix = prefix .. char
    end

    return prefix .. ellipsis
end

local function pad_right(s, width)
    return s .. string.rep(" ", math.max(width - display_width(s), 0))
end

local function pad_left(s, width)
    return string.rep(" ", math.max(width - display_width(s), 0)) .. s
end

_G.matsu_qftf = function(info)
    local list
    if info.quickfix == 1 then
        list = vim.fn.getqflist({ id = info.id, items = 0 })
    else
        list = vim.fn.getloclist(info.winid, { id = info.id, items = 0 })
    end
    local items = list and list.items or {}

    local names = {}
    local name_widths = {}
    local line_width, col_width = 1, 1
    local max_index = 0

    for i, item in ipairs(items) do
        max_index = i

        local name = item.filename
        if type(name) ~= "string" or name == "" then
            name = vim.fn.bufname(item.bufnr or 0)
        end
        name = name or ""

        if name ~= "" then
            -- 相对路径优先；不在当前目录或家目录下的路径保持原样
            name = vim.fn.fnamemodify(name, ":~:.")
            name_widths[#name_widths + 1] = display_width(name)
        end
        names[i] = name

        local lnum = tonumber(item.lnum) or 0
        local col = tonumber(item.col) or 0
        if lnum > 0 then
            line_width = math.max(line_width, #tostring(lnum))
        end
        if col > 0 then
            col_width = math.max(col_width, #tostring(col))
        end
    end

    -- 用非空文件名的 75 百分位宽度，避免少数超长路径撑宽整列
    table.sort(name_widths)
    local filename_width = 10
    if #name_widths > 0 then
        local p75 = name_widths[math.ceil(#name_widths * 0.75)] or 0
        filename_width = math.min(math.max(p75 + 2, 10), 43)
    end

    local result = {}
    for i = info.start_idx, info.end_idx do
        local item = items[i]
        if not item then
            break
        end

        local name = names[i] or ""
        local lnum = tonumber(item.lnum) or 0
        local col = tonumber(item.col) or 0

        -- 0:0 项通常是多行错误的续行
        if lnum == 0 and col == 0 then
            name = ""
        end
        name = pad_right(truncate(name, filename_width), filename_width)

        local line_text = lnum > 0 and tostring(lnum) or ""
        local col_text = col > 0 and tostring(col) or ""
        local separator = (line_text ~= "" and col_text ~= "") and ":" or " "
        local position = pad_left(line_text, line_width) .. separator .. pad_left(col_text, col_width)

        local text = item.text or ""
        result[#result + 1] = name .. " | " .. position .. " | " .. text
    end

    return result
end
