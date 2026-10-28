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

	local body = type(snippet_raw.body) == "table" and snippet_raw.body or { snippet_raw.body }
	---@cast body string[]

	local description = snippet_raw.description or "No description"
	if type(description) == "table" then
		description = table.concat(description, "\n")
	end
	description = description .. "\n\n"

	for _, p in ipairs(prefix) do
		processed_snippets[p] = {
			prefix = p,
			body = table.concat(body, "\n"),
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
	local global_filetype = { "matsu" }
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
			body = snippet.body,
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
