---@class autosnip.Autosnip
---@field body string[]
---@field callback fun(args: table|nil)

---@type table<string,autosnip.Autosnip>
local auto_snippets = {}
---@type table<string,string[]>
local auto_triggers = {}

local AUTO = {}

---@param ft string
---@param buf number
---@param pos table
---@return string|nil
function AUTO.should_expand(ft, buf, pos)
	local line = vim.api.nvim_buf_get_lines(buf, pos.row - 1, pos.row, true)[1]
	if not line then
		return nil
	end

	-- Get the word immediately before the cursor.
	-- Any non-whitespace character is allowed, including CJK and emoji.
	local before_cursor = line:sub(1, pos.col)
	local cursor_word = before_cursor:match("(%S+)$")
	if not cursor_word then
		return nil
	end

	-- Check whether the snippet exists.
	local snippet = auto_snippets[ft][cursor_word]
	if not snippet then
		return nil
	end

	-- Inline snippets can expand anywhere.
	if snippet.inline then
		return cursor_word
	end

	-- The character after the word must be whitespace or EOL.
	local after_cursor = line:sub(pos.col + 1)
	local next_char = after_cursor:sub(1, 1)
	if next_char ~= "" and not next_char:match("[ \t]") then
		return nil
	end

	-- Non-inline snippets require only whitespace after the cursor.
	if after_cursor:match("^%s*$") then
		return cursor_word
	end
	return nil
end

---@param prefix string
---@param ft string
---@return boolean
function AUTO.expand(prefix, ft)
	local snippet = auto_snippets[ft][prefix]
	local snippet_str = table.concat(snippet.body, "\n")
	vim.snippet.expand(snippet_str)

	return snippet.callback and snippet.callback()
end

---@param buf number
---@param ft string
function AUTO.set(ft, buf)
	for _, k in pairs(auto_triggers[ft]) do
		vim.keymap.set("i", k, function()
			local cur = vim.api.nvim_win_get_cursor(0)
			local pos = { row = cur[1], col = cur[2] }

			-- -- insert trigger key and move cursor first
			vim.api.nvim_buf_set_text(0, pos.row - 1, pos.col, pos.row - 1, pos.col, { k })
			pos.col = pos.col + 1
			vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
			vim.notify("col: " .. (pos.col + 1), vim.log.levels.WARN)
			local prefix = AUTO.should_expand(ft, buf, pos)
			if prefix then
				vim.api.nvim_buf_set_text(0, pos.row - 1, pos.col - #prefix, pos.row - 1, pos.col, {})
				AUTO.expand(prefix, ft)
			end
		end, { noremap = true, silent = true, buf = buf })
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "go" },
	callback = function(args)
		local ft = args.match

		if auto_triggers[ft] then
			return
		end

		auto_triggers[ft] = {}
		for k in pairs(auto_snippets[ft]) do
			table.insert(auto_triggers[ft], k:sub(-1))
		end
		auto_triggers[ft] = vim.list.unique(auto_triggers[ft])

		AUTO.set(ft, args.buf)
	end,
	group = vim.api.nvim_create_augroup("matsu.autosnip", { clear = true }),
})

-- NOTE: snippets
auto_snippets.markdown = {
	["；1"] = {
		body = { "```${1:txt}\n${2:print()}", "```", "${0}" },
	},
	[";1"] = {
		body = { "```${1:txt}\n${2:print()}", "```", "${0}" },
	},
	[";2"] = {
		body = { "`${1}`${0}" },
		inline = true,
	},
	["；2"] = {
		body = { "`${1}`${0}" },
		inline = true,
	},
	[";a1"] = {
		body = { "hello ${1:world}!${0}" },
		inline = true,
		callback = function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", false)
		end,
	},
}

auto_snippets.go = {
	["iff"] = {
		body = { "if err != nil {", "\treturn err${0}", "}" },
		callback = function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", false)
		end,
	},
}
