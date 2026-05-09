local snippets = {}

---@class SnippetOpts
---@field lang string
---@field abbr string
---@field template string[]
---@field cursor_pos function
---@field eol? boolean
---@field mode? string

---@param snip SnippetOpts
local add = function(snip)
	snip = vim.tbl_extend("force", { eol = true, mode = "i" }, snip or {})

	local lang = snip.lang
	local abbr = snip.abbr
	local key = abbr:sub(-1)

	snippets[lang] = snippets[lang] or {}
	snippets[lang][key] = snippets[lang][key] or {}

	snippets[lang][key][abbr] = snip
end

local function inside_word(col0, line)
	local next_char = line:sub(col0 + 1, col0 + 1)
	return next_char ~= "" and next_char:match("%w") ~= nil
end

local function apply_snippet(pos, indent, snip)
	local lines = vim.deepcopy(snip.template)

	for i = 2, #lines do
		lines[i] = indent .. lines[i]
	end

	vim.api.nvim_buf_set_text(0, pos.row - 1, pos.col - #snip.abbr, pos.row - 1, pos.col, lines)

	snip.set_cursor(pos)
end

local function try_expand(pos, bucket)
	local col0 = vim.fn.col(".") - 1
	local line = vim.fn.getline(".")

	if inside_word(col0, line) then
		return
	end

	local before = line:sub(1, col0)
	local word = before:match("%S+$") or before

	local snip = bucket[word]
	if not snip then
		return
	end

	if snip.eol then
		local trimmed = line:gsub("%s+$", "")
		if col0 < #trimmed then
			return
		end
	end

	local indent = line:match("^%s+") or ""
	apply_snippet(pos, indent, snip)

	if snip.mode == "n" then
		vim.cmd("stopinsert")
	end
end

---@param opts { lang:string, args:integer }
local load = function(opts)
	local lang = opts.lang
	local lang_snips = snippets[lang]
	if not lang_snips then
		return
	end

	for key, bucket in pairs(lang_snips) do
		vim.keymap.set("i", key, function()
			vim.schedule(function()
				local cur = vim.api.nvim_win_get_cursor(0)
				local pos = { row = cur[1], col = cur[2] }

				-- insert trigger key
				vim.api.nvim_buf_set_text(0, pos.row - 1, pos.col, pos.row - 1, pos.col, { key })

				pos.col = pos.col + 1
				vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })

				try_expand(pos, bucket)
			end)
		end, { noremap = true, silent = true, buf = opts.buf })
	end
end

local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
	pattern = { "go" },
	callback = function(args)
		add({
			lang = "go",
			abbr = "iff",
			template = { "if err != nil {", "\treturn err", "}" },
			set_cursor = function(pos)
				local line = vim.fn.getline(pos.row + 1)
				vim.api.nvim_win_set_cursor(0, {
					pos.row + 1,
					string.len(line) - 2,
				})
			end,
			mode = "n",
		})
		load({ lang = "go", buf = args.buf })
	end,
	group = vim.api.nvim_create_augroup("go.snippets", { clear = true }),
	desc = "go snippets",
})

autocmd("FileType", {
	pattern = { "markdown" },
	callback = function(args)
		add({
			lang = "markdown",
			abbr = ";1",
			template = { "```", "```" },

			set_cursor = function(pos)
				vim.api.nvim_win_set_cursor(0, {
					pos.row,
					pos.col + string.len(";1"),
				})
			end,
		})
		add({
			lang = "markdown",
			abbr = "；1",
			template = { "```", "```" },
			set_cursor = function(pos)
				vim.api.nvim_win_set_cursor(0, {
					pos.row,
					pos.col + string.len("；1"),
				})
			end,
		})
		add({
			lang = "markdown",
			abbr = ";2",
			template = { "``" },

			set_cursor = function(pos)
				vim.api.nvim_win_set_cursor(0, {
					pos.row,
					pos.col - 1,
				})
			end,
		})
		add({
			lang = "markdown",
			abbr = "；2",
			template = { "``" },
			set_cursor = function(pos)
				vim.api.nvim_win_set_cursor(0, {
					pos.row,
					pos.col - 3,
				})
			end,
		})
		load({ lang = "markdown", buf = args.buf })
	end,
	group = vim.api.nvim_create_augroup("markdown.snippets", { clear = true }),
	desc = "markdown snippets",
})
