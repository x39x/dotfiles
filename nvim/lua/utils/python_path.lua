local python_path

local uv_python = nil

local function resolve_uv_python()
        local uv_data_dir = vim.fn.expand("$HOME/.local/share/uv/python")

        local cmd_result = vim.system({ "uv", "python", "find" }, { text = true }):wait()

        if cmd_result.code ~= 0 then
                return false
        end

        local found_path = vim.fn.trim(cmd_result.stdout)

        -- ignore uv-managed internal python
        if vim.startswith(found_path, uv_data_dir) then
                return false
        end

        uv_python = found_path
        return true
end

--NOTE: https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-876700701
-- prefer active virtualenv
if vim.env.VIRTUAL_ENV then
        python_path = vim.env.VIRTUAL_ENV .. "/bin/python3"
-- fallback to uv python (if available)
elseif resolve_uv_python() then
        python_path = uv_python
-- system python
else
        python_path = vim.fn.exepath("python3") or vim.fn.exepath("python") or "python3"
end

return python_path
