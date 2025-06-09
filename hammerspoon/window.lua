local window = require("hs.window")
local M = {}

local winSize = {
        --   - x: Horizontal starting position of the window's top-left corner (0 to 1 scale, 0 is far left, 1 is far right).
        --   - y: Vertical starting position of the window's top-left corner (0 to 1 scale, 0 is top, 1 is bottom).
        --   - width: The width of the window, as a proportion of the total screen width (0 to 1 scale).
        --   - height: The height of the window, as a proportion of the total screen height (0 to 1 scale).
        top = { 0.004, 0.004, 0.992, 0.494 },
        bottom = { 0.004, 0.502, 0.992, 0.494 },
        left = { 0.004, 0.004, 0.494, 0.992 },
        right = { 0.502, 0.004, 0.494, 0.992 },

        max = { 0.004, 0.004, 0.992, 0.992 },
        center = { 0.2, 0.10, 0.6, 0.7 },

        topLeft = { 0.004, 0.004, 0.494, 0.494 },
        topRight = { 0.502, 0.004, 0.494, 0.494 },
        bottomLeft = { 0.004, 0.502, 0.494, 0.494 },
        bottomRight = { 0.502, 0.502, 0.494, 0.494 },
}

M.windowManager = function(size)
        return function()
                local win = window.focusedWindow()
                if win == nil then
                        return
                end

                -- Handle fullScreen toggle
                if size == "fullScreen" then
                        win:setFullScreen(not win:isFullScreen())
                        return
                end

                win:moveToUnit(winSize[size])
        end
end

return M
