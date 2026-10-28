local M = {}

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.WARN)
end

-- Parse global -ax / -axr output.
local function parse_output(stdout)
	local results = {}

	for line in stdout:gmatch("[^\r\n]+") do
		local symbol, lnum, file, text = line:match("^(%S+)%s+(%d+)%s+(%S+)%s*(.*)$")

		if symbol and lnum and file then
			results[#results + 1] = {
				symbol = symbol,
				lnum = tonumber(lnum),
				filename = file,
				text = text,
			}
		end
	end

	return results
end

-- Run global and parse results.
local function search(args, word, callback)
	vim.system({ "global", unpack(args), word }, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				notify("global failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
				return
			end

			local results = parse_output(result.stdout or "")

			if #results == 0 then
				notify("No results found for: " .. word)
				return
			end

			callback(results)
		end)
	end)
end

-- Open a location.
local function open_location(item)
	vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
	vim.api.nvim_win_set_cursor(0, { item.lnum, 0 })
end

-- Send results to fzf-lua.
local function fzf_results(results, title)
	local entries = {}

	for _, item in ipairs(results) do
		entries[#entries + 1] = {
			filename = item.filename,
			lnum = item.lnum,
			text = item.text,
			display = string.format("%s:%d: %s", item.filename, item.lnum, item.text),
		}
	end

	if #entries == 1 then
		open_location(entries[1])
	end

	require("fzf-lua").fzf_exec(entries, {
		prompt = title .. "> ",
		previewer = "builtin",
		actions = {
			["default"] = function(selected)
				if not selected or not selected[1] then
					return
				end

				local entry = selected[1]
				if type(entry) == "table" and entry.filename then
					open_location(entry)
				end
			end,
		},
	})
end

function M.goto_definition()
	local word = vim.fn.expand("<cword>")

	if word == "" then
		return
	end

	search({ "-ax" }, word, function(results)
		if #results == 1 then
			open_location(results[1])
		else
			fzf_results(results, "Definitions")
		end
	end)
end

function M.goto_references()
	local word = vim.fn.expand("<cword>")

	if word == "" then
		return
	end

	search({ "-axr" }, word, function(results)
		fzf_results(results, "References")
	end)
end
