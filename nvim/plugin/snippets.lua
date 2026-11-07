-- https://github.com/Massolari/nvim-snippets
local SNIPPET = {}

---@class snippets.Snippet
---@field prefix string|string[]
---@field body string|string[]
---@field description? string|string[]

---@class snippets.ProcessedSnippet
---@field prefix string
---@field body string
---@field description? string

---@type table<string, table<string, snippets.ProcessedSnippet>>
SNIPPET.cache = {}

---@type table<string, snippets.ProcessedSnippet>
SNIPPET.loaded_snippets = {}

---@type table<string, string[]>
SNIPPET.registry = {}

--NOTE: load snippets

---@param snippet_raw snippets.Snippet
---@return table<string, snippets.ProcessedSnippet>
local function process_snippet(snippet_raw)
	local processed_snippets = {}

	local prefix = type(snippet_raw.prefix) == "string" and { snippet_raw.prefix } or snippet_raw.prefix
	---@cast prefix string[]

	local body = type(snippet_raw.body) == "table" and table.concat(snippet_raw.body, "\n") or snippet_raw.body

	local description = snippet_raw.description or "No description"
	if type(description) == "table" then
		description = table.concat(description, "\n")
	end
	description = description .. "\n\n"

	for _, p in ipairs(prefix) do
		processed_snippets[p] = {
			prefix = p,
			body = body,
			description = description,
		}
	end
	return processed_snippets
end

---@param path string
---@return string|nil
local function read_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	return content
end

---@param filetype string
---@return table<string, snippets.ProcessedSnippet>
local function get_snippets_for_ft(filetype)
	local ft_snippets_files_list = SNIPPET.registry[filetype]
	if not ft_snippets_files_list then
		return {}
	end

	local ft_snippets = {}

	for _, f in ipairs(ft_snippets_files_list) do
		local snippets_contents = read_file(f)
		if snippets_contents then
			local s = vim.json.decode(snippets_contents)
			for _, snippet in pairs(s) do
				local processed_snippet = process_snippet(snippet)
				ft_snippets = vim.tbl_extend("force", ft_snippets, processed_snippet)
			end
		end
	end

	return ft_snippets
end

---@param filetype string
local function load_snippets(filetype)
	if not filetype then
		return
	end

	-- if has cache, load cache
	if SNIPPET.cache[filetype] then
		SNIPPET.loaded_snippets = SNIPPET.cache[filetype]
		return
	end

	-- extended some filetype
	local extended_filetype = { javascript = { "html", "css" } }
	local extended_snippets = {}
	if extended_filetype[filetype] ~= nil then
		for _, ft in ipairs(extended_filetype[filetype]) do
			extended_snippets = get_snippets_for_ft(ft)
		end
	end

	-- global snippets
	local global_filetype = { "matsu", "all" }
	local global_snippets = {}
	for _, ft in ipairs(global_filetype) do
		global_snippets = get_snippets_for_ft(ft)
	end

	-- filetype snippets
	local ft_snippets = get_snippets_for_ft(filetype)

	SNIPPET.cache[filetype] = vim.tbl_extend("force", extended_snippets, ft_snippets, global_snippets)
	SNIPPET.loaded_snippets = SNIPPET.cache[filetype]
end

-- NOTE: func for register

---@param path string
---@return table<string,string[]>
local function scan_snippet_files(path)
	local result = {}

	local req = vim.uv.fs_scandir(path)
	if not req then
		return result
	end

	for fname, ftype in vim.uv.fs_scandir_next, req do
		if ftype == "file" and fname:match("%.json$") then
			local language = fname:gsub("%.json$", "")
			result[language] = result[language] or {}
			table.insert(result[language], vim.fs.joinpath(path, fname))
		end
	end

	return result
end

---@param path string
---@return table<string, string[]>
local function load_snippet_packagejson(path)
	local data = read_file(vim.fs.joinpath(path, "package.json"))
	if not data then
		return {}
	end

	local pkg_data = vim.json.decode(data)
	local snippet_info_list = vim.tbl_get(pkg_data, "contributes", "snippets")
	if not snippet_info_list then
		return {}
	end

	local result = {}
	for _, snippet_meta in ipairs(snippet_info_list) do
		local languages = snippet_meta.language or {}
		languages = type(languages) == "string" and { languages } or languages

		for _, language in ipairs(languages) do
			local paths = result[language] or {}
			table.insert(paths, vim.fs.normalize(vim.fs.joinpath(path, snippet_meta.path)))
			result[language] = paths
		end
	end

	return result
end

-- NOTE: register snippet files

local local_snippet_path = vim.fs.joinpath(vim.fn.stdpath("config"), "snippets")
local friendly_snippet_path = ""

for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
	if path:match("friendly.snippets") then
		friendly_snippet_path = path
		break
	end
end

---@type table<string,string[]>
local snippet_map = {}

for language, snippet_file_list in pairs(load_snippet_packagejson(friendly_snippet_path)) do
	snippet_map[language] = snippet_file_list
end

for language, snippet_file_list in pairs(scan_snippet_files(local_snippet_path)) do
	snippet_map[language] = snippet_map[language] or {}
	snippet_map[language] = vim.list.unique(vim.list_extend(snippet_map[language], snippet_file_list))
end

SNIPPET.registry = snippet_map

-- NOTE:  builtin variables

--- https://github.com/garymjr/nvim-snippets/blob/main/lua/snippets/utils/builtin.lua
--- https://github.com/L3MON4D3/LuaSnip/blob/master/lua/luasnip/util/_builtin_vars.lua
--- https://code.visualstudio.com/docs/editor/userdefinedsnippets#_variables

-- TM_SELECTED_TEXT The currently selected text or the empty string
-- TM_CURRENT_LINE The contents of the current line
-- TM_CURRENT_WORD The contents of the word under cursor or the empty string
-- TM_LINE_INDEX The zero-index based line number
-- TM_LINE_NUMBER The one-index based line number
-- TM_FILENAME The filename of the current document
-- TM_FILENAME_BASE The filename of the current document without its extensions
-- TM_DIRECTORY The directory of the current document
-- TM_FILEPATH The full file path of the current document
-- RELATIVE_FILEPATH The relative (to the opened workspace or folder) file path of the current document
-- CLIPBOARD The contents of your clipboard
-- WORKSPACE_NAME The name of the opened workspace or folder
-- WORKSPACE_FOLDER The path of the opened workspace or folder
-- CURRENT_YEAR The current year
-- CURRENT_YEAR_SHORT The current year's last two digits
-- CURRENT_MONTH The month as two digits (example '02')
-- CURRENT_MONTH_NAME The full name of the month (example 'July')
-- CURRENT_MONTH_NAME_SHORT The short name of the month (example 'Jul')
-- CURRENT_DATE The day of the month as two digits (example '08')
-- CURRENT_DAY_NAME The name of day (example 'Monday')
-- CURRENT_DAY_NAME_SHORT The short name of the day (example 'Mon')
-- CURRENT_HOUR The current hour in 24-hour clock format
-- CURRENT_MINUTE The current minute as two digits
-- CURRENT_SECOND The current second as two digits
-- CURRENT_SECONDS_UNIX The number of seconds since the Unix epoch
-- CURRENT_TIMEZONE_OFFSET The current UTC time zone offset as +HH:MM or -HH:MM (example -07:00).
-- RANDOM 6 random Base-10 digits
-- RANDOM_HEX 6 random Base-16 digits
-- UUID A Version 4 UUID
-- BLOCK_COMMENT_START Example output: in PHP /* or in HTML <!--
-- BLOCK_COMMENT_END Example output: in PHP */ or in HTML -->
-- LINE_COMMENT Example output: in PHP //
---- not support
-- CURRENT_MILLISECOND The current millisecond as three digits (example 078)
-- CURRENT_MILLISECONDS_UNIX The number of milliseconds since the Unix epoch
-- CURRENT_TIMEZONE_NAME The IANA name of the current time zone (example America/Los_Angeles)
-- CURSOR_INDEX The zero-index based cursor number
-- CURSOR_NUMBER The one-index based cursor number

local builtin = {
	lazy = {},
}

function builtin.lazy.TM_FILENAME()
	return vim.fn.expand("%:t")
end

function builtin.lazy.TM_FILENAME_BASE()
	return vim.fn.expand("%:t:s?\\.[^\\.]\\+$??")
end

function builtin.lazy.TM_DIRECTORY()
	return vim.fn.expand("%:p:h")
end

function builtin.lazy.TM_FILEPATH()
	return vim.fn.expand("%:p")
end

function builtin.lazy.CLIPBOARD()
	return vim.fn.getreg(vim.v.register, true)
end

local function buf_to_ws_part()
	local LSP_WORKSPACE_PARTS = "LSP_WORKSPACE_PARTS"
	local ok, ws_parts = pcall(vim.api.nvim_buf_get_var, 0, LSP_WORKSPACE_PARTS)
	if not ok then
		local file_path = vim.fn.expand("%:p")

		for _, ws in pairs(vim.lsp.buf.list_workspace_folders()) do
			if file_path:find(ws, 1, true) == 1 then
				ws_parts = { ws, file_path:sub(#ws + 2, -1) }
				break
			end
		end
		-- If it can't be extracted from lsp, then we use the file path
		if not ok and not ws_parts then
			ws_parts = { vim.fn.expand("%:p:h"), vim.fn.expand("%:p:t") }
		end
		vim.api.nvim_buf_set_var(0, LSP_WORKSPACE_PARTS, ws_parts)
	end
	return ws_parts
end

function builtin.lazy.RELATIVE_FILEPATH() -- The relative (to the opened workspace or folder) file path of the current document
	return buf_to_ws_part()[2]
end

function builtin.lazy.WORKSPACE_FOLDER() -- The path of the opened workspace or folder
	return buf_to_ws_part()[1]
end

function builtin.lazy.WORKSPACE_NAME() -- The name of the opened workspace or folder
	local parts = vim.split(buf_to_ws_part()[1] or "", "[\\/]")
	return parts[#parts]
end

function builtin.lazy.CURRENT_YEAR()
	return os.date("%Y")
end

function builtin.lazy.CURRENT_YEAR_SHORT()
	return os.date("%y")
end

function builtin.lazy.CURRENT_MONTH()
	return os.date("%m")
end

function builtin.lazy.CURRENT_MONTH_NAME()
	return os.date("%B")
end

function builtin.lazy.CURRENT_MONTH_NAME_SHORT()
	return os.date("%b")
end

function builtin.lazy.CURRENT_DATE()
	return os.date("%d")
end

function builtin.lazy.CURRENT_DAY_NAME()
	return os.date("%A")
end

function builtin.lazy.CURRENT_DAY_NAME_SHORT()
	return os.date("%a")
end

function builtin.lazy.CURRENT_HOUR()
	return os.date("%H")
end

function builtin.lazy.CURRENT_MINUTE()
	return os.date("%M")
end

function builtin.lazy.CURRENT_SECOND()
	return os.date("%S")
end

function builtin.lazy.CURRENT_SECONDS_UNIX()
	return tostring(os.time())
end

local function get_timezone_offset(ts)
	local utcdate = os.date("!*t", ts)
	local localdate = os.date("*t", ts)
	localdate.isdst = false -- this is the trick
	local diff = os.difftime(os.time(localdate), os.time(utcdate))
	local h, m = math.modf(diff / 3600)
	return string.format("%+.4d", 100 * h + 60 * m)
end

function builtin.lazy.CURRENT_TIMEZONE_OFFSET()
	return get_timezone_offset(os.time()):gsub("([+-])(%d%d)(%d%d)$", "%1%2:%3")
end

math.randomseed(os.time())

function builtin.lazy.RANDOM()
	return string.format("%06d", math.random(999999))
end

function builtin.lazy.RANDOM_HEX()
	return string.format("%06x", math.random(16777216)) --16^6
end

function builtin.lazy.UUID()
	local random = math.random
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	local out
	local function subs(c)
		local v = (((c == "x") and random(0, 15)) or random(8, 11))
		return string.format("%x", v)
	end

	out = template:gsub("[xy]", subs)
	return out
end

local _comments_cache = {}
local function buffer_comment_chars()
	local commentstring = vim.bo.commentstring
	if _comments_cache[commentstring] then
		return _comments_cache[commentstring]
	end
	local comments = { "//", "/*", "*/" }
	local placeholder = "%s"
	local index_placeholder = commentstring:find(vim.pesc(placeholder))
	if index_placeholder then
		index_placeholder = index_placeholder - 1
		if index_placeholder + #placeholder == #commentstring then
			comments[1] = vim.trim(commentstring:sub(1, -#placeholder - 1))
		else
			comments[2] = vim.trim(commentstring:sub(1, index_placeholder))
			comments[3] = vim.trim(commentstring:sub(index_placeholder + #placeholder + 1, -1))
		end
	end
	_comments_cache[commentstring] = comments
	return comments
end

function builtin.lazy.LINE_COMMENT()
	return buffer_comment_chars()[1]
end

function builtin.lazy.BLOCK_COMMENT_START()
	return buffer_comment_chars()[2]
end

function builtin.lazy.BLOCK_COMMENT_END()
	return buffer_comment_chars()[3]
end

local function get_cursor()
	local c = vim.api.nvim_win_get_cursor(0)
	c[1] = c[1] - 1
	return c
end

local function get_current_line()
	local pos = get_cursor()
	return vim.api.nvim_buf_get_lines(0, pos[1], pos[1] + 1, false)[1]
end

local function word_under_cursor(cur, line)
	if line == nil then
		return
	end

	local ind_start = 1
	local ind_end = #line

	while true do
		local tmp = string.find(line, "%W%w", ind_start)
		if not tmp then
			break
		end
		if tmp > cur[2] + 1 then
			break
		end
		ind_start = tmp + 1
	end

	local tmp = string.find(line, "%w%W", cur[2] + 1)
	if tmp then
		ind_end = tmp
	end

	return string.sub(line, ind_start, ind_end)
end

local function get_selected_text()
	if vim.fn.visualmode() == "V" then
		---@diagnostic disable-next-line
		return vim.fn.trim(vim.fn.getreg(vim.v.register, true), "\n", 2)
	end
	return ""
end

vim.api.nvim_create_autocmd("InsertEnter", {
	group = vim.api.nvim_create_augroup("nvim_snippets_eager_enter", { clear = true }),
	callback = function()
		builtin.eager = {}
		builtin.eager.TM_CURRENT_LINE = get_current_line()
		builtin.eager.TM_CURRENT_WORD = word_under_cursor(get_cursor(), builtin.eager.TM_CURRENT_LINE)
		builtin.eager.TM_LINE_INDEX = tostring(get_cursor()[1])
		builtin.eager.TM_LINE_NUMBER = tostring(get_cursor()[1] + 1)
		builtin.eager.TM_SELECTED_TEXT = get_selected_text()
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = vim.api.nvim_create_augroup("nvim_snippets_eager_leave", { clear = true }),
	callback = function()
		builtin.eager = nil
	end,
})

local function safe_parse(input)
	local safe, parsed = pcall(vim.lsp._snippet_grammar.parse, input)
	if not safe then
		return nil
	end
	return parsed
end

local function expand_vars(input)
	local lazy_vars = builtin.lazy
	local eager_vars = builtin.eager or {}

	local resolved_snippet = input
	local parsed_snippet = safe_parse(input)
	if not parsed_snippet then
		return input
	end

	for _, child in ipairs(parsed_snippet.data.children) do
		local type, data = child.type, child.data
		if type == vim.lsp._snippet_grammar.NodeType.Variable then
			if eager_vars[data.name] then
				resolved_snippet = resolved_snippet:gsub("%$[{]?(" .. data.name .. ")[}]?", eager_vars[data.name])
			elseif lazy_vars[data.name] then
				resolved_snippet = resolved_snippet:gsub("%$[{]?(" .. data.name .. ")[}]?", lazy_vars[data.name]())
			end
		end
	end

	return resolved_snippet
end

--NOTE: complete

---@param prefix string
---@param snippet snippets.ProcessedSnippet
---@param kind string
local function snippet_to_complete_items(prefix, snippet, kind)
	local info = string.format("%s```\n%s\n```", snippet.description, snippet.body)

	return {
		word = prefix,
		abbr = prefix .. " ",
		info = info,
		kind = kind,

		user_data = {
			nvim_snippet = true,
			prefix = prefix,
			body = expand_vars(snippet.body),
		},
		dup = 1,
		icase = 1,
	}
end

-- :h complete-functions
---@param findstart number 1 to find start position, 0 to find matches
---@param _ string The text to match (empty on first call)
---@return number|table Column position on first call, list of matches on second call
_G.snippet_complete = function(findstart, _)
	if findstart == 1 then
		-- First call: find the start of the completion
		local col = vim.api.nvim_win_get_cursor(0)[2]

		return col
	else
		local response = {}

		local ignored_filetypes = { "fzf" }
		if vim.tbl_contains(ignored_filetypes, vim.bo.filetype) then
			return response
		end

		-- snippet 存在多个 prefix 的情况已在 process_snippet 处理过了
		-- prefix 是唯一的，但可以对应相同的 snippet.body
		load_snippets(vim.bo.filetype)
		for prefix, snippet in pairs(SNIPPET.loaded_snippets) do
			table.insert(response, snippet_to_complete_items(prefix, snippet, "Snippet"))
		end

		return response
	end
end

-- nvim has default snippet keymap <Tab>/<S-Tab>
-- see: https://github.com/neovim/neovim/pull/31887.patch
-- Inside a snippet, don't use <Backspace> to remove the placeholder
-- It will end the snippet active state, use <C-o> + normal-mode action(c/s)
vim.api.nvim_create_autocmd("CompleteDone", {
	group = vim.api.nvim_create_augroup("matsu.snippet.expand", { clear = true }),
	callback = function()
		local completed = vim.v.completed_item
		local word = completed.word
		local reason = vim.v.event.reason

		if not word or reason ~= "accept" then
			return
		end

		if not completed.user_data or not completed.user_data.nvim_snippet then
			return
		end

		-- Get current line and cursor position
		local lnum, col = unpack(vim.api.nvim_win_get_cursor(0))
		vim.api.nvim_buf_set_text(0, lnum - 1, col - #word, lnum - 1, col, {})
		vim.snippet.expand(completed.user_data.body)
	end,
})
