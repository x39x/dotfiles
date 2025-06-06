local conditions = require("heirline.conditions")

local function process_diff(data)
        -- Adapted from https://github.com/wbthomason/nvim-vcs.lua
        local added, removed, modified = 0, 0, 0
        for _, line in ipairs(data) do
                if string.find(line, [[^@@ ]]) then
                        local tokens = vim.fn.matchlist(line, [[^@@ -\v(\d+),?(\d*) \+(\d+),?(\d*)]])
                        local line_stats = {
                                mod_count = tokens[3] == nil and 0 or tokens[3] == "" and 1 or tonumber(tokens[3]),
                                new_count = tokens[5] == nil and 0 or tokens[5] == "" and 1 or tonumber(tokens[5]),
                        }

                        if line_stats.mod_count == 0 and line_stats.new_count > 0 then
                                added = added + line_stats.new_count
                        elseif line_stats.mod_count > 0 and line_stats.new_count == 0 then
                                removed = removed + line_stats.mod_count
                        else
                                local min = math.min(line_stats.mod_count, line_stats.new_count)
                                modified = modified + min
                                added = added + line_stats.new_count - min
                                removed = removed + line_stats.mod_count - min
                        end
                end
        end
        return { added = added, modified = modified, removed = removed }
end

local function get_git_diff_stats(file_path)
        if not file_path or #file_path == 0 then
                return { added = 0, modified = 0, removed = 0 }
        end

        local diff_output_cache = {}
        local cmd = string.format(
                [[git -C %s --no-pager diff --no-color --no-ext-diff -U0 -- %s]],
                vim.fn.fnamemodify(file_path, ":h"),
                vim.fn.fnamemodify(file_path, ":t")
        )

        local handle = io.popen(cmd)
        if not handle then
                return { added = 0, modified = 0, removed = 0 }
        end

        for line in handle:lines() do
                table.insert(diff_output_cache, line)
        end
        handle:close()

        return process_diff(diff_output_cache)
end

local function resolve_git_dir(git_root)
        local git_path = git_root .. "/.git"
        local stat = vim.loop.fs_stat(git_path)
        if stat and stat.type == "file" then
                local content = vim.fn.readfile(git_path)[1]
                local real_git_dir = content:match("gitdir: (.+)")
                if real_git_dir then
                        return vim.fn.fnamemodify(git_root .. "/" .. real_git_dir, ":p")
                end
        end
        return git_path
end

local Space = { provider = "  " }
local Align = { provider = "%=" }

local FileName = {
        provider = function(self)
                -- trim the pattern relative to the current directory
                local filename = vim.fn.fnamemodify(self.filename, ":.")
                if filename == "" then
                        return "[No Name]"
                end
                filename = vim.fn.fnamemodify(filename, ":~")

                -- if the filename would occupy more than 1/4th of the available space,
                -- trim the file path to its initials
                if not conditions.width_percent_below(#filename, 0.5) then
                        filename = vim.fn.pathshorten(filename)
                end
                return filename
        end,
        hl = function()
                return { fg = "heirline_A", bold = true, force = true }
        end,
}

local FileFlags = {
        {
                condition = function()
                        return vim.bo.modified
                end,
                provider = "[+]",
        },
        {
                condition = function()
                        return not vim.bo.modifiable or vim.bo.readonly
                end,
                provider = "[]",
        },
}

local FileNameBlock = {
        -- let's first set up some attributes needed by this component and it's children
        init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
        end,

        FileName,
        FileFlags,
        { provider = "%<" }, -- this means that the statusline is cut here when there's not enough space
}

local WorkDir = {

        provider = function()
                local icon = (vim.fn.haslocaldir(0) == 1 and "󰌶 " or "")
                local cwd = vim.fn.getcwd(0)
                cwd = vim.fn.fnamemodify(cwd, ":~")
                if not conditions.width_percent_below(#cwd, 0.25) then
                        cwd = vim.fn.pathshorten(cwd)
                end
                local trail = cwd:sub(-1) == "/" and "" or "/"
                return icon .. cwd .. trail
        end,
        hl = function()
                return { fg = "heirline_A", bold = true, force = true }
        end,
}

local BufType = {
        provider = function()
                return vim.bo.filetype
        end,
        hl = function()
                return { fg = "heirline_A", bold = true, force = true }
        end,
}

local Ruler = {
        provider = "%2c:%2P",
}

local Diagnostics = {

        condition = conditions.has_diagnostics,

        static = {

                error_icon = "",
                warn_icon = "",
                info_icon = "",
                hint_icon = "",
        },

        init = function(self)
                self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        update = { "DiagnosticChanged", "BufEnter" },

        {
                provider = function(self)
                        return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ")
                end,
                hl = function()
                        return { fg = "heirline_diagnostic_error" }
                end,
        },
        {
                provider = function(self)
                        return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ")
                end,
                hl = function()
                        return { fg = "heirline_diagnostic_warn" }
                end,
        },
        {
                provider = function(self)
                        return self.info > 0 and (self.info_icon .. " " .. self.info .. " ")
                end,
                hl = function()
                        return { fg = "heirline_diagnostic_info" }
                end,
        },
        {
                provider = function(self)
                        return self.hints > 0 and (self.hint_icon .. " " .. self.hints)
                end,
                hl = function()
                        return { fg = "heirline_diagnostic_hint" }
                end,
        },
}

local Git = {
        condition = function()
                return vim.b.is_git_repo
        end,
        update = { "BufEnter", "BufWritePost" },
        init = function(self)
                local current_file = vim.fn.expand("%:p")
                local file_dir = vim.fn.fnamemodify(current_file, ":h")

                local result = vim.system({ "git", "-C", file_dir, "rev-parse", "--show-toplevel" }, { text = true })
                        :wait()

                if result.code ~= 0 then
                        vim.notify("39line! statusline.lua: 233", vim.log.levels.WARN)
                        return
                end

                local git_root = result.stdout and vim.trim(result.stdout) or nil

                local git_dir = resolve_git_dir(git_root)

                local head = vim.fn.readfile(git_dir .. "/HEAD")[1]
                local branch = head and head:match("refs/heads/(.+)") or (head and head:sub(1, 7)) or "unknown"

                self.branch = branch
                self.diff_dict = get_git_diff_stats(current_file)
                self.has_changes = self.diff_dict.added ~= 0
                        or self.diff_dict.removed ~= 0
                        or self.diff_dict.modified ~= 0
        end,

        {
                provider = function(self)
                        return " " .. self.branch
                end,
                hl = function()
                        return { fg = "heirline_git_branch", bold = true }
                end,
        },
        {
                condition = function(self)
                        return self.has_changes
                end,
                provider = "[ ",
                hl = { bold = true },
        },

        {
                provider = function(self)
                        local count = self.diff_dict.added or 0
                        return count > 0 and ("+" .. count .. " ")
                end,
                hl = function()
                        return { fg = "heirline_git_added", bold = true }
                end,
        },
        {
                provider = function(self)
                        local count = self.diff_dict.removed or 0
                        return count > 0 and ("-" .. count .. " ")
                end,
                hl = function()
                        return { fg = "heirline_git_removed", bold = true }
                end,
        },
        {
                provider = function(self)
                        local count = self.diff_dict.modified or 0
                        return count > 0 and ("~" .. count .. " ")
                end,
                hl = function()
                        return { fg = "heirline_git_modified", bold = true }
                end,
        },
        {
                condition = function(self)
                        return self.has_changes
                end,
                provider = "]",
                hl = { bold = true },
        },
}

local DAPMessages = {
        condition = function()
                local session = require("dap").session()
                return session ~= nil
        end,
        provider = function()
                return " " .. require("dap").status()
        end,
        hl = "Debug",
}

local DefaultStatusline = {
        Space,
        FileNameBlock,
        Space,
        Diagnostics,

        Align,

        DAPMessages,
        Space,
        Git,
        Space,
        WorkDir,
        Space,
        Ruler,
        Space,
}
local InactiveStatusline = {
        condition = conditions.is_not_active,
        Space,
        FileNameBlock,
        Align,
}

local SpecialStatusline = {
        condition = function()
                return conditions.buffer_matches({
                        buftype = { "nofile", "prompt", "help", "quickfix" },
                        filetype = { "^git.*", "fugitive" },
                })
        end,
        Space,
        BufType,
        Align,
        WorkDir,
        Space,
}

return {

        hl = "Normal",
        fallthrough = false,
        SpecialStatusline,
        InactiveStatusline,
        DefaultStatusline,
}
