local function find_oxfmtrc()
    local default_config = vim.fs.normalize("~/.dotfiles/fmtstyle/oxfmtrc.json")
    local current_file = vim.api.nvim_buf_get_name(0)

    if current_file == "" then
        return default_config
    end
    local config_file = vim.fs.find({
        ".oxfmtrc.json",
        ".oxfmtrc.jsonc",
        "oxfmt.config.ts",
        "oxfmt.config.mts",
    }, {
        path = vim.fs.dirname(current_file),
        upward = true,
        stop = vim.fs.dirname(vim.uv.os_homedir()),
    })[1]
    return config_file or default_config
end

local conform = require("conform")
conform.setup({
    formatters = {
        shfmt = {
            append_args = { "-i", "4" },
        },
        oxfmt = {
            args = function()
                return { "-c", find_oxfmtrc(), "--stdin-filepath", "$FILENAME" }
            end,
        },
    },
    formatters_by_ft = {
        lua = { "stylua" },

        javascript = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        vue = { "oxfmt" },
        astro = { "oxfmt" },
        css = { "oxfmt" },
        html = { "oxfmt" },
        markdown = { "oxfmt" },
        json = { "oxfmt" },
        jsonc = { "oxfmt" },
        json5 = { "oxfmt" },
        toml = { "oxfmt" },
        yaml = { "oxfmt" },

        sh = { "shfmt" },
        zsh = { "shfmt" },
        bash = { "shfmt" },
    },
    stop_after_first = true,
    default_format_opts = {
        lsp_format = "fallback",
        stop_after_first = true,
        quiet = false,
    },
})

local api = vim.api

api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
            return
        end
        conform.format({ bufnr = args.buf })
    end,
})

vim.keymap.set({ "n", "x" }, "F", function()
    conform.format({
        bufnr = api.nvim_win_get_buf(0),
        async = true,
    }, function(err)
        if not err then
            local mode = api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
                api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
        end
    end)
end, { desc = "format" })

api.nvim_create_user_command("Fdisable", function(args)
    if args.bang then
        -- Fdisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

api.nvim_create_user_command("Fenable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

------------------------------------------------------------------
--- lint
------------------------------------------------------------------

local lint = require("lint")

local linters_by_ft = {
    sh = { "shellcheck" },
    bash = { "shellcheck" },
    go = { "golangcilint" },
}

api.nvim_create_autocmd("BufWritePost", {
    group = api.nvim_create_augroup("matsu.lint", { clear = true }),
    callback = function(args)
        local buf = args.buf
        if not api.nvim_buf_is_valid(buf) then
            return
        end

        local linters = { "typos" }
        vim.list_extend(linters, linters_by_ft[vim.bo[buf].filetype] or {})

        -- 使用到触发事件的 buf，避免 lint 错文件
        api.nvim_buf_call(buf, function()
            lint.try_lint(linters)
        end)
    end,
})

------------------------------------------------------------------
--- tasks/runner
------------------------------------------------------------------

local overseer = require("overseer")
overseer.setup({
    form = {
        border = "double",
    },
    component_aliases = {
        default_vscode = {
            "default",
            "on_result_diagnostics",
            { "on_result_diagnostics_quickfix", close = true, open = true },
        },
    },
    task_list = {
        min_height = 11,
    },
    template_timeout_ms = 0,
})

overseer.add_template_hook({ module = "^make.*", filetype = "c" }, function(task_defn, util)
    util.add_component(task_defn, { "on_output_parse", problem_matcher = "$gcc" })
    util.add_component(task_defn, { "on_result_diagnostics_quickfix", close = true, open = true })
end)
