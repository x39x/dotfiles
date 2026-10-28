local api = vim.api
local fn = vim.fn
local au = api.nvim_create_autocmd
local aug = api.nvim_create_augroup("matsu.matsuline", { clear = true })

local state = {
	-- tabline
	show_labels = false,
	buffers = {},
	tabs = {},
	active_bufnr = nil,
	-- stateline
	dap = "",
	diagnostic = {},
}

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
local FT_FILETYPE = { fzf = true, alpha = true }
local FT_FILENAME = { man = true }
local BT_FILENAME = { nowrite = true, acwrite = true }

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
	local icon = fn.haslocaldir(0) == 1 and "[]" or ""
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
	local counts = state.diagnostic[api.nvim_get_current_buf()] or {}

	for _, level in ipairs(diagnostic_levels) do
		local count = counts[level.severity]
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

local function update_diagnostics(bufnr)
	bufnr = bufnr or api.nvim_get_current_buf()
	if not api.nvim_buf_is_valid(bufnr) then
		return
	end

	local counts = vim.diagnostic.count(bufnr)

	local buf_cache = {}
	for _, level in ipairs(diagnostic_levels) do
		buf_cache[level.severity] = counts[level.severity] or 0
	end

	state.diagnostic[bufnr] = buf_cache
end

--- dap

local function update_dap_status()
	local ok, dap = pcall(require, "dap")
	if ok then
		state.dap = " " .. dap.status()
	end
end

--- special buffers
local function special_name()
	local bo = vim.bo[0]
	local hi = set_hl("MatsuLineBold") .. set_hl("MatsuLineA", true)

	if FT_FILETYPE[bo.filetype] then
		return hi .. bo.filetype
	end

	if FT_FILENAME[bo.filetype] then
		return filename_block()
	end

	if BT_FILENAME[bo.buftype] then
		return filename_block()
	end

	-- quickfix type
	if bo.buftype == "quickfix" then
		return vim.tbl_isempty(fn.getloclist(0)) and hi .. "quickfix" or hi .. "localfix"
	end

	-- fallback
	if bo.buftype then
		return hi .. bo.buftype
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
		state.dap,
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
-- topbar
---========================================================================
local LABEL_CHARS = { "h", "j", "k", "l", "g", "m", "n", "f", "w", "e", "r", "u" }
local EXCLUDED_FILETYPES = { fzf = true }
local EXCLUDED_BUFTYPES = { quickfix = true }

-- 包裹 click 函数：%{id}@v:lua.{handler}@ ... %X
local function clickable(handler, id, text)
	return string.format("%%%d@v:lua.%s@%s%%X", id, handler, text)
end

-------------------- Buffer --------------------

local function is_valid_buffer(bufnr)
	local bo = vim.bo[bufnr]
	if not bo then
		return
	end

	--- special ft/bt
	if bo.filetype == "man" then
		return true
	end

	--- exclude ft/bt

	if EXCLUDED_FILETYPES[bo.filetype] then
		return false
	end

	if EXCLUDED_BUFTYPES[bo.buftype] then
		return false
	end

	return bo.buflisted
end

local function get_buffer_name(bufnr)
	local name = vim.fs.basename(api.nvim_buf_get_name(bufnr))
	if name == "" then
		return "[No Name]"
	end

	local len = fn.strchars(name)
	if len > 39 then
		return fn.strcharpart(name, 0, 13) .. "..." .. fn.strcharpart(name, len - 19)
	end
	return name
end

local function collect_buffers()
	local current = api.nvim_get_current_buf()
	if is_valid_buffer(current) then
		state.active_bufnr = current
	end

	local buffers = {}
	for _, bufnr in ipairs(api.nvim_list_bufs()) do
		if is_valid_buffer(bufnr) then
			local index = #buffers + 1
			buffers[index] = {
				bufnr = bufnr,
				name = get_buffer_name(bufnr),
				label = state.show_labels and (LABEL_CHARS[index] or "#") or " ",
			}
		end
	end

	state.buffers = buffers
	return buffers
end

-- 渲染单个 buffer，返回 { str, width }
local function render_buffer(buffer)
	local flag = file_flag(buffer.bufnr)
	local name_hl = buffer.bufnr == state.active_bufnr and set_hl("MatsuLineA", true) or set_hl("TabLine")

	local str = clickable(
		"matsu_click_buf",
		buffer.bufnr,
		table.concat({
			" ",
			set_hl("MatsuLineBold"),
			set_hl("MatsuLineD", true),
			buffer.label,
			name_hl,
			escape_statusline(buffer.name),
			set_hl("MatsuLineC"),
			flag,
		})
	)
	local width = 1 + fn.strdisplaywidth(buffer.label .. buffer.name .. flag)

	return { str = str, width = width, is_active = buffer.bufnr == state.active_bufnr }
end

local function concat_range(items, first, last)
	local parts = {}
	for i = first, last do
		parts[#parts + 1] = items[i].str
	end
	return table.concat(parts)
end

-- 在 max_width 内渲染 buffer 列表，保证 active buffer 可见
local function render_buffers(max_width)
	local items, active_idx, total = {}, 1, 0

	for i, buffer in ipairs(collect_buffers()) do
		local item = render_buffer(buffer)
		items[i] = item
		total = total + item.width
		if item.is_active then
			active_idx = i
		end
	end

	if #items == 0 then
		return ""
	end
	if total <= max_width then
		return " " .. concat_range(items, 1, #items)
	end

	local budget = max_width - api.nvim_strwidth("  ") -- 按照最长预留边界,使用时根据实际减去
	local first, last = active_idx, active_idx
	local used = items[active_idx].width -- active 即使单个超宽也强制显示 (%< fallback)

	local grew = true
	while grew do
		grew = false
		if last < #items and used + items[last + 1].width <= budget then
			last = last + 1
			used = used + items[last].width
			grew = true
		end
		if first > 1 and used + items[first - 1].width <= budget then
			first = first - 1
			used = used + items[first].width
			grew = true
		end
	end

	local head = " "
	if first > 1 then
		head = set_hl("Comment") .. "  "
	else
		-- head 预留 3 字符，这里只用了一个
		used = used - 2
	end

	-- 使 bufline 占满剩余宽度
	local trail = ""
	if last < #items then
		-- 边界宽度已预留，used==budget 后再加""刚好，不用再减 1
		while used < budget do
			trail = trail .. " "
			used = used + 1
		end
		trail = set_hl("Comment") .. trail .. ""
	end

	return table.concat({ head .. "%<", concat_range(items, first, last), trail })
end

local function click_buffer(bufnr, _, button)
	if button == "r" then
		api.nvim_buf_delete(bufnr, { force = false })
	elseif api.nvim_buf_is_valid(bufnr) then
		api.nvim_win_set_buf(0, bufnr)
	end
	vim.cmd.redrawtabline()
end

-------------------- Tab --------------------

local function render_tab(tab, current_tabid)
	local tab_hl = set_hl("TabLine", true)
	if state.show_labels then
		tab_hl = set_hl("MatsuLineC", true)
	elseif tab.tabid == current_tabid then
		tab_hl = set_hl("MatsuLineB", true)
	end
	local ctx = table.concat({ " ", set_hl("MatsuLineBold"), tab_hl, tab.tabnr, " " })
	return clickable("matsu_click_tab", tab.tabid, ctx)
end

-- 返回 tab 区域的渲染串和显示宽度；超过 max_width 时退为 " 当前/总数 "
local function render_tabs(max_width)
	local current_tabid = api.nvim_get_current_tabpage()
	local tabs, parts, width = {}, {}, 0

	for i, tabid in ipairs(api.nvim_list_tabpages()) do
		tabs[i] = { tabid = tabid, tabnr = api.nvim_tabpage_get_number(tabid) }
		parts[i] = render_tab(tabs[i], current_tabid)
		width = width + 2 + #tostring(tabs[i].tabnr)
	end
	state.tabs = tabs

	if #tabs <= 1 then
		return "", 0
	end
	if width > max_width then
		local str = string.format(" %d/%d ", fn.tabpagenr(), #tabs)
		return str, #str
	end
	return table.concat(parts), width
end

local function click_tab(tabid, _, button)
	if button == "r" then
		vim.cmd.tabclose()
	elseif api.nvim_tabpage_is_valid(tabid) then
		api.nvim_set_current_tabpage(tabid)
	end
	vim.cmd.redrawtabline()
end

-------------------- Topbar --------------------

local function render_tb()
	local columns = vim.o.columns
	local tab_str, tab_width = render_tabs(columns / 3)
	local buf_str = render_buffers(columns - tab_width - 3) -- space

	-- 头部空格由 render_buffers 添加
	return table.concat({ buf_str, "%=", tab_str, "   " })
end

-------------------- Jump --------------------

local function jump()
	state.show_labels = true
	vim.cmd.redrawtabline()

	local char = fn.getcharstr()
	local tabnr = tonumber(char)

	if tabnr then
		for _, tab in ipairs(state.tabs) do
			if tab.tabnr == tabnr and api.nvim_tabpage_is_valid(tab.tabid) then
				api.nvim_set_current_tabpage(tab.tabid)
				break
			end
		end
	else
		for _, buffer in ipairs(state.buffers) do
			if buffer.label == char and api.nvim_buf_is_valid(buffer.bufnr) then
				api.nvim_win_set_buf(0, buffer.bufnr)
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

	api.nvim_set_hl(0, "TopBarStatus", { fg = "green" })
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

_G.matsu_click_buf = click_buffer
_G.matsu_click_tab = click_tab

vim.g.matsu_statusline = render_stl
vim.g.matsu_topbar = render_tb

vim.go.statusline = "%{%g:matsu_statusline()%}"
vim.go.tabline = "%{%g:matsu_topbar()%}"

vim.keymap.set("n", "<leader>j", jump)

---========================================================================
-- state
---========================================================================

--- lsp
au({ "DiagnosticChanged", "LspAttach", "LspDetach" }, {
	group = aug,
	callback = function(args)
		vim.schedule(function()
			update_diagnostics(args.buf)
			vim.cmd.redrawstatus({ bang = true })
		end)
	end,
})

--- dap
au("User", {
	group = aug,
	pattern = "DapProgressUpdate",
	callback = function()
		vim.schedule(function()
			update_dap_status()
			vim.cmd.redrawstatus({ bang = true })
		end)
	end,
})

--- clear
au("BufWipeout", {
	group = aug,
	callback = function(args)
		state.diagnostic[args.buf] = nil
		state.dap = ""
	end,
})
