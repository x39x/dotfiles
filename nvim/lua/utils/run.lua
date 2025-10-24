local M = {}

--FUNC: run
local runCode = {
        markdown = function()
                vim.cmd("silent! !open %")
        end,

        typst = function()
                vim.cmd("silent! !open -a Skim.app %:p:r.pdf")
        end,
}

M.run = function()
        --get current buffer filetype
        local ftp = vim.bo.filetype
        --RUN
        if runCode[ftp] ~= nil then
                runCode[ftp]()
        end
end

return M
