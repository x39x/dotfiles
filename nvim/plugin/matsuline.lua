local api = vim.api
local fn = vim.fn
local au = api.nvim_create_autocmd
local aug = api.nvim_create_augroup("matsu.matsuline", { clear = true })

local state = {
    -- tabline
    show_labels = false,
    tabs = {},
    tab_names = {},
}

---========================================================================
-- config
---========================================================================

local STL_FT = { fzf = true }
local STL_BT = { help = true }
local TBL_BT = { help = true }
local TBL_FT = { NeogitStatus = true }
local TABNAME_EXCLUDED_FT = { fzf = true }
local TABNAME_EXCLUDED_BT = { quickfix = true }
local TAB_LABEL_CHARS = { "h", "j", "k", "l", "g", "m", "n", "f", "w", "e", "r", "u" }

---========================================================================
-- global
---========================================================================

local function set_hl(name, inherit)
    local marker = inherit and "$" or "#"
    return "%" .. marker .. name .. marker
end

local function file_flag(bufnr)
    bufnr = bufnr or 0
    local bo = vim.bo[bufnr]
    if not bo then
        return
    end
    if bo.readonly then
        return "[]"
    elseif bo.buftype == "terminal" then
        return "[]"
    elseif not bo.modifiable then
        return "[=]"
    elseif bo.modified then
        return "[+]"
    end
    return "   "
end

local function escape_statusline(s)
    return (s:gsub("%%", "%%%%"))
end

---========================================================================
-- statusline
---========================================================================

local function is_inactive()
    return api.nvim_get_current_win() ~= tonumber(vim.g.actual_curwin)
end

local function shorten_if_long(path, ratio)
    local width = vim.o.laststatus == 3 and vim.o.columns or api.nvim_win_get_width(0)
    if #path / width <= ratio then
        return path
    end
    return fn.pathshorten(path)
end

---------------------------------------------------------------------------
-- components
---------------------------------------------------------------------------

--- workdir
local function workdir()
    local icon = ""

    if fn.haslocaldir(-1, 0) == 1 then
        icon = "[T]"
    end
    if fn.haslocaldir(0) == 1 then
        icon = "[W]"
    end
    if fn.haslocaldir(-1, -1, 0) == 1 then
        icon = "[X]"
    end

    local cwd = shorten_if_long(fn.fnamemodify(vim.uv.cwd() or "", ":~"), 0.25)
    cwd = escape_statusline(cwd)
    local trail = cwd:sub(-1) == "/" and "" or "/"
    local ctx = {
        "   ",
        set_hl("MatsuLineBold"),
        set_hl("MatsuLineA", true),
        cwd .. trail,
        set_hl("StatusLine"),
        icon,
    }

    return table.concat(ctx)
end

local function filename_block()
    local name = api.nvim_buf_get_name(0)

    if name == "" then
        return set_hl("MatsuLineBold") .. set_hl("MatsuLineA", true) .. "[No Name]"
    end

    name = shorten_if_long(fn.fnamemodify(name, ":.:~"), 0.33)
    name = escape_statusline(name)

    return table.concat({
        set_hl("MatsuLineBold"),
        set_hl("MatsuLineA", true),
        name,
        set_hl("StatusLine"),
        file_flag(),
        "   ",
    })
end

--- git: branch + diff
local git_changes = {
    { key = "added", hl = "diffAdded", symbol = "+" },
    { key = "changed", hl = "diffChanged", symbol = "~" },
    { key = "removed", hl = "diffRemoved", symbol = "-" },
}

local function git()
    local status = vim.b.gitsigns_status_dict
    if not status then
        return ""
    end

    local parts = {
        "   ",
        set_hl("MatsuLineBold"),
        set_hl("MatsuLineB", true),
        " ",
        status.head,
        set_hl("StatusLine"),
    }

    local changes = {}
    for _, c in ipairs(git_changes) do
        local count = status[c.key] or 0
        if count > 0 then
            changes[#changes + 1] = ("%%#%s# %s%d"):format(c.hl, c.symbol, count)
        end
    end

    if #changes > 0 then
        parts[#parts + 1] = "["
        parts[#parts + 1] = table.concat(changes)
        parts[#parts + 1] = set_hl("StatusLine") .. " ]"
    end

    return table.concat(parts)
end

--- lsp diagnostics
local diagnostic_levels = {
    { severity = vim.diagnostic.severity.ERROR, icon = "", hl = "DiagnosticError" },
    { severity = vim.diagnostic.severity.WARN, icon = "", hl = "DiagnosticWarn" },
    { severity = vim.diagnostic.severity.INFO, icon = "", hl = "DiagnosticInfo" },
    { severity = vim.diagnostic.severity.HINT, icon = "", hl = "DiagnosticHint" },
}

local function diagnostics()
    local parts = {}

    -- diagnostic is already cached by lsp
    local counts = vim.diagnostic.count(api.nvim_get_current_buf()) or {}

    for _, level in ipairs(diagnostic_levels) do
        local count = counts[level.severity] or 0
        if count and count > 0 then
            parts[#parts + 1] = table.concat({
                set_hl(level.hl),
                level.icon,
                " ",
                count,
                "  ",
            })
        end
    end

    return vim.trim(table.concat(parts))
end

--- special buffers
local function special_name()
    local hi = set_hl("MatsuLineBold") .. set_hl("MatsuLineA", true)

    local ft = vim.bo[0].filetype

    if STL_FT[ft] then
        return hi .. ft
    end

    local bt = vim.bo[0].buftype

    -- quickfix
    if bt == "quickfix" then
        return vim.tbl_isempty(fn.getloclist(0)) and hi .. "quickfix" or hi .. "localfix"
    end

    if STL_BT[bt] then
        return hi .. bt
    end

    if bt then
        if api.nvim_buf_get_name(0) ~= "" then
            return filename_block()
        end

        if ft ~= "" then
            return hi .. ft
        end

        return hi .. bt
    end

    return hi .. "[No Type]"
end

---------------------------------------------------------------------------
-- layouts
---------------------------------------------------------------------------

local layout = {}

function layout.inactive()
    return table.concat({
        "   ",
        filename_block(),
        "%<%=",
    })
end

function layout.special()
    return table.concat({
        "   ",
        special_name(),
        "%<%=",
        workdir(),
        "   ",
        set_hl("MatsuLineBold"),
        "%6(%c:%L%)",
        "   ",
    })
end

function layout.default()
    return table.concat({
        "   ",
        filename_block(),
        diagnostics(),
        "%<%=",
        git(),
        workdir(),
        "   ",
        set_hl("MatsuLineBold"),
        "%6(%c:%L%)",
        "   ",
    })
end

local function render_stl()
    if is_inactive() then
        return layout.inactive()
    end

    if vim.bo.buftype ~= "" then
        return layout.special()
    end

    return layout.default()
end

---========================================================================
-- tabline
---========================================================================

-- 包裹 click 函数：%{id}@v:lua.{handler}@ ... %X
local function clickable(handler, id, text)
    return string.format("%%%d@v:lua.%s@%s%%X", id, handler, text)
end

local function shorten_tab_name(name)
    local len = fn.strchars(name)
    if len > 20 then
        return fn.strcharpart(name, 0, 19) .. "…"
    end
    return name
end

---------------------------------------------------------------------------
-- components
---------------------------------------------------------------------------

--- local dir
local function get_localdir_name(tabnr)
    if fn.haslocaldir(-1, tabnr) == 0 then
        return nil
    end

    local dir = fn.getcwd(-1, tabnr)
    local name = fn.fnamemodify(dir, ":t")
    if name == "" then
        name = dir
    end
    if name:sub(-1) ~= "/" then
        name = name .. "/"
    end
    return shorten_tab_name(name)
end

--- buf name
local function get_buffer_name(bufnr)
    local path = api.nvim_buf_get_name(bufnr)
    if path == "" then
        return "[No Name]"
    end

    local is_dir = path:sub(-1) == "/" or fn.isdirectory(path) == 1
    path = path:gsub("/+$", "")
    local name = path == "" and "/" or vim.fs.basename(path)
    if is_dir and name ~= "/" then
        name = name .. "/"
    end
    return shorten_tab_name(name)
end

--- term name
local shell_names = {
    bash = true,
    fish = true,
}

local function get_term_name(bufnr)
    local channel = vim.bo[bufnr].channel
    if not channel or channel <= 0 then
        return "terminal"
    end

    local pid = fn.jobpid(channel)
    if not pid or pid <= 0 then
        return "terminal"
    end

    local ok, children = pcall(api.nvim_get_proc_children, pid)
    local child_pid = ok and children and children[1]
    if not child_pid then
        return "terminal"
    end

    local proc_ok, process_info = pcall(api.nvim_get_proc, child_pid)
    local name = proc_ok and process_info and process_info.name
    if not name or shell_names[name] then
        return "terminal"
    end

    return shorten_tab_name(name .. "[sh]")
end

---------------------------------------------------------------------------
-- make tabline
---------------------------------------------------------------------------
local function is_temporary_tab_window(winid, bufnr)
    local bo = vim.bo[bufnr] or {}
    if TABNAME_EXCLUDED_FT[bo.filetype] or TABNAME_EXCLUDED_BT[bo.buftype] then
        return true
    end
    return api.nvim_win_get_config(winid).relative ~= ""
end

local function get_tab_name(tab)
    local winid = api.nvim_tabpage_get_win(tab.tabid)
    local bufnr = api.nvim_win_get_buf(winid)

    local localdir_name = get_localdir_name(tab.tabnr)
    if localdir_name then
        state.tab_names[tab.tabid] = localdir_name
        return localdir_name
    end

    -- NOTE: 这里过滤一些浮动窗口之类的，显示缓存的名称
    --       如果要彻底不显示某个 tab，参考 alpha 的处理
    if is_temporary_tab_window(winid, bufnr) then
        return state.tab_names[tab.tabid] or ""
    end

    local ft = vim.bo[bufnr].filetype
    local bt = vim.bo[bufnr].buftype
    local name
    if TBL_FT[ft] then
        name = ft
    elseif TBL_BT[bt] then
        name = bt
    elseif bt == "terminal" then
        name = get_term_name(bufnr)
    else
        name = get_buffer_name(bufnr)
    end

    state.tab_names[tab.tabid] = name
    return name
end

local function concat_range(items, first, last)
    local parts = {}
    for i = first, last do
        parts[#parts + 1] = items[i].str
    end
    return table.concat(parts)
end

local function render_tab(tab, current_tabid)
    local name_hl = tab.tabid == current_tabid and set_hl("MatsuLineA", true) or set_hl("TabLine")
    local name = get_tab_name(tab)
    local label = state.show_labels and tab.label or " "
    local display = {
        " ",
        set_hl("MatsuLineBold"),
        set_hl("MatsuLineD", true),
        label,
        name_hl,
        escape_statusline(name),
        "   ",
    }

    local str = clickable("matsu_click_tab", tab.tabid, table.concat(display))
    local width = fn.strdisplaywidth(" " .. label .. name .. "   ")

    --NOTE: 在 tabname 处理会有空格，这样处理会使存在 alpha 的 tab
    --      彻底不可见，但几乎没有这种情况，可以接受
    local winid = api.nvim_tabpage_get_win(tab.tabid)
    local bufnr = api.nvim_win_get_buf(winid)
    if vim.bo[bufnr].filetype == "alpha" then
        state.tab_names[tab.tabid] = ""
        str = ""
        width = 0
    end

    return { str = str, width = width, is_active = tab.tabid == current_tabid }
end

-- 在 max_width 内渲染 tabs，保证当前 tab 可见并向两侧扩展
local function render_tbl()
    local max_width = vim.o.columns

    local current_tabid = api.nvim_get_current_tabpage()
    local tabids = api.nvim_list_tabpages()
    local tabs, live_tabids, items, active_idx, total = {}, {}, {}, 1, 0

    for i, tabid in ipairs(tabids) do
        local tab = {
            tabid = tabid,
            tabnr = api.nvim_tabpage_get_number(tabid),
            label = TAB_LABEL_CHARS[i] or "#",
        }
        tabs[i] = tab
        live_tabids[tabid] = true
        local item = render_tab(tab, current_tabid)
        items[i] = item
        total = total + item.width
        if item.is_active then
            active_idx = i
        end
    end
    state.tabs = tabs
    for tabid in pairs(state.tab_names) do
        if not live_tabids[tabid] then
            state.tab_names[tabid] = nil
        end
    end

    if #items == 0 then
        return "", 0
    end

    local left_padding, right_padding = "   ", "   "
    local left_marker, right_marker = "  ", "  "
    local outer_width = fn.strdisplaywidth(left_padding) + fn.strdisplaywidth(right_padding)

    if total + outer_width <= max_width then
        return table.concat({ left_padding, "%<", concat_range(items, 1, #items), right_padding }), max_width
    end

    local first, last = active_idx, active_idx
    local used = items[active_idx].width
    local function edge_width(first_idx, last_idx)
        local left = first_idx > 1 and left_marker or left_padding
        local right = last_idx < #items and right_marker or right_padding
        return fn.strdisplaywidth(left) + fn.strdisplaywidth(right)
    end

    local grew = true
    while grew do
        grew = false
        if last < #items and used + items[last + 1].width + edge_width(first, last + 1) <= max_width then
            last = last + 1
            used = used + items[last].width
            grew = true
        end
        if first > 1 and used + items[first - 1].width + edge_width(first - 1, last) <= max_width then
            first = first - 1
            used = used + items[first].width
            grew = true
        end
    end

    local left_text = first > 1 and left_marker or left_padding
    local head = first > 1 and (set_hl("Comment") .. left_text) or left_text
    local trail = right_padding

    if last < #items then
        ---@diagnostic disable-next-line
        local padding = math.max(0, max_width - fn.strdisplaywidth(left_text) - used - fn.strdisplaywidth(right_marker))
        trail = set_hl("Comment") .. string.rep(" ", padding) .. right_marker
    end

    return table.concat({ head, "%<", concat_range(items, first, last), trail }), max_width
end

local function click_tab(tabid, _, button)
    if button == "r" then
        vim.cmd.tabclose()
    elseif api.nvim_tabpage_is_valid(tabid) then
        api.nvim_set_current_tabpage(tabid)
    end
    vim.cmd.redrawtabline()
end

---------------------------------------------------------------------------
-- jump
---------------------------------------------------------------------------
local function jump()
    state.show_labels = true
    vim.cmd.redrawtabline()

    local ok, char = pcall(fn.getcharstr)
    if ok then
        for _, tab in ipairs(state.tabs) do
            if tab.label == char and api.nvim_tabpage_is_valid(tab.tabid) then
                api.nvim_set_current_tabpage(tab.tabid)
                break
            end
        end
    end

    state.show_labels = false
    vim.cmd.redrawtabline()
end

---========================================================================
-- highlight
---========================================================================

local function link_if_unset(name, target)
    if vim.tbl_isempty(api.nvim_get_hl(0, { name = name })) then
        api.nvim_set_hl(0, name, { link = target })
    end
end

local function apply_highlights()
    link_if_unset("MatsuLineA", "Function")
    link_if_unset("MatsuLineB", "Keyword")
    link_if_unset("MatsuLineC", "Added")
    link_if_unset("MatsuLineD", "Removed")

    api.nvim_set_hl(0, "MatsuLineBold", { bold = true })
    api.nvim_set_hl(0, "TabLine", { bold = false })
    api.nvim_set_hl(0, "TabLineSel", { link = "TabLine" })
    api.nvim_set_hl(0, "TabLineFill", { link = "TabLine" })
    api.nvim_set_hl(0, "StatusLine", { bold = false })
    api.nvim_set_hl(0, "StatusLineNC", { link = "StatusLine" })
    api.nvim_set_hl(0, "StatusLineTerm", { link = "StatusLine" })
    api.nvim_set_hl(0, "StatusLineTermNC", { link = "StatusLine" })
end

au("ColorScheme", {
    group = aug,
    callback = function()
        apply_highlights()
        vim.cmd.redrawstatus({ bang = true })
    end,
})

---========================================================================
-- setup
---========================================================================

apply_highlights()

_G.matsu_click_tab = click_tab

vim.g.matsu_statusline = render_stl
vim.g.matsu_tabline = render_tbl

vim.go.statusline = "%{%g:matsu_statusline()%}"
vim.go.tabline = "%{%g:matsu_tabline()%}"

vim.keymap.set("n", "<leader>j", jump)

au({ "TermRequest", "TermResponse" }, {
    group = aug,
    callback = function()
        vim.cmd.redrawtabline()
    end,
})
