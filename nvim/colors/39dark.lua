local function hl(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
end

local colors = {
        miku = "#ACB5DE",

        purple0 = "#b392f0",
        purple1 = "#a485de",

        blue1 = "#79b8ff",
        blue2 = "#6db0fc",
        blue3 = "#316bcd",
        blue4 = "#1976D2",
        blue5 = "#264F78",

        fg0 = "#888888",
        fg1 = "#FFFFFF",
        fg2 = "#f8f8f8",

        bg0 = "#1F1F1F",
        bg1 = "#000000",
        bg2 = "#1A1A1A",
        bg3 = "#292929",
        bg4 = "#212121",

        gray0 = "#303030",
        gray1 = "#383838",
        gray2 = "#2A2A2A",
        gray3 = "#444444",
        gray4 = "#727272",
        gray5 = "#6b737c",
        gray8 = "#9db1c5",
        gray6 = "#bbbbbb",
        gray7 = "#F5F5F5",

        yellow0 = "#FF9800",
        yellow1 = "#ffab70",
        yellow2 = "#FCE094",
        yellow3 = "#cd9731",
        yellow4 = "#63341D",

        green1 = "#0FBC7A",
        green2 = "#51FA7A",

        red0 = "#f50000",
        red2 = "#cd3131",
        red3 = "#cd3131",
        red1 = "#FF7B72",
        red4 = "#f97583",
        red5 = "#FF7A84",

        --DONE: diff
        diff_x = "#4E201E",
        diff_t = "#a12237",
        diff_a = "#39482B",
        diff_d = "#303030",
        diff_l = "#494949",
        diff_s = "#1B7F37",
        diff_r = "#cd3131",
        diff_o = "#d68349",

        --NOTE:
        -- "#515C6A"
        -- "#2A2A2A"
        -- "#2b6bab"
        -- "#691B24"
        -- "#611B27"
        --
}

local function m39k()
        vim.cmd("hi clear")
        if vim.fn.exists("syntax_on") then
                vim.cmd("syntax reset")
        end
        vim.o.background = "dark"
        vim.g.colors_name = "39dark"

        --NOTE: UI
        hl("Normal", { fg = colors.fg0, bg = colors.bg0 })
        hl("NormalFloat", { fg = colors.fg0, bg = colors.bg2 })
        hl("FloatBorder", { fg = colors.gray3, bg = colors.bg2 })
        hl("CursorLine", { bg = colors.gray0 })
        hl("CursorColumn", { bg = colors.gray0 })
        hl("Cursor", { fg = colors.bg0, bg = colors.fg0 })
        hl("LineNr", { fg = colors.gray4 })
        hl("CursorLineNr", { fg = colors.fg2 })
        hl("SignColumn", { fg = colors.gray4, bg = colors.bg0 })
        hl("ColorColumn", { bg = colors.gray0 })
        hl("StatusLine", { fg = colors.gray4, bg = colors.bg2 })
        hl("StatusLineNC", { fg = colors.gray4, bg = colors.bg2 })
        hl("VertSplit", { fg = colors.gray3 })
        hl("WinSeparator", { fg = colors.gray3 })
        hl("Pmenu", { fg = colors.fg0, bg = colors.bg2 })
        hl("PmenuSel", { fg = colors.gray7, bg = colors.bg4 })
        hl("PmenuSbar", { bg = colors.bg2 })
        hl("PmenuThumb", { bg = colors.gray4 })
        hl("TabLine", { fg = colors.gray4, bg = colors.bg2 })
        hl("TabLineFill", { bg = colors.bg2 })
        hl("TabLineSel", { fg = colors.gray7, bg = colors.bg0 })
        hl("Visual", { bg = colors.blue5 })
        hl("VisualNOS", { bg = colors.red2 })
        hl("Search", { bg = colors.yellow2, fg = colors.bg1 })
        hl("CurSearch", { bg = colors.green1, fg = colors.bg1 })
        hl("IncSearch", { bg = colors.red0, fg = colors.bg1 })
        hl("MatchParen", { bg = colors.green1, fg = colors.bg1 })
        hl("Directory", { fg = colors.purple0 })
        hl("Folded", { fg = colors.gray4, bg = colors.bg3 })
        hl("FoldColumn", { fg = colors.gray4, bg = colors.bg0 })
        hl("NonText", { fg = colors.gray4 })
        hl("EndOfBuffer", { fg = colors.gray4 })
        hl("SpecialKey", { fg = colors.gray4 })
        hl("Title", { fg = colors.blue1, bold = true })
        hl("Question", { fg = colors.purple0 })
        hl("MoreMsg", { fg = colors.purple0 })
        hl("ModeMsg", { fg = colors.fg0 })
        hl("ErrorMsg", { fg = colors.red3 })
        hl("WarningMsg", { fg = colors.yellow0 })
        hl("WildMenu", { fg = colors.gray7, bg = colors.bg3 })
        hl("Conceal", { fg = colors.gray5 })
        hl("Whitespace", { fg = colors.gray2 })
        hl("Underlined", { underline = true })
        hl("Todo", { fg = colors.gray7, bg = colors.bg3, bold = true })

        --NOTE:  LSP Diagnostics Diff
        hl("LspReferenceText", { bg = colors.bg3 })
        hl("LspReferenceRead", { bg = colors.bg3 })
        hl("LspReferenceWrite", { bg = colors.bg3 })
        hl("LspCodeLens", { fg = colors.gray5 })
        hl("LspCodeLensText", { fg = colors.gray5 })
        hl("LspCodeLensSign", { fg = colors.gray5 })
        hl("LspSignatureActiveParameter", { fg = colors.yellow0, bold = true })
        hl("LspInlayHint", { fg = colors.gray5, italic = true })
        -- Diagnostics (LSP)
        hl("DiagnosticError", { fg = colors.red3 })
        hl("DiagnosticWarn", { fg = colors.yellow0 })
        hl("DiagnosticInfo", { fg = colors.blue3 })
        hl("DiagnosticHint", { fg = colors.purple0 })
        hl("DiagnosticUnderlineError", { sp = colors.red3, undercurl = true })
        hl("DiagnosticUnderlineWarn", { sp = colors.yellow0, undercurl = true })
        hl("DiagnosticUnderlineInfo", { sp = colors.blue3, undercurl = true })
        hl("DiagnosticUnderlineHint", { sp = colors.purple0, undercurl = true })
        hl("DiagnosticSignError", { fg = colors.red3 })
        hl("DiagnosticSignWarn", { fg = colors.yellow0 })
        hl("DiagnosticSignInfo", { fg = colors.blue3 })
        hl("DiagnosticSignHint", { fg = colors.purple0 })
        hl("DiagnosticFloatingError", { fg = colors.red3 })
        hl("DiagnosticFloatingWarn", { fg = colors.yellow0 })
        hl("DiagnosticFloatingInfo", { fg = colors.blue3 })
        hl("DiagnosticFloatingHint", { fg = colors.purple0 })
        hl("DiagnosticVirtualTextError", { fg = colors.red3, italic = true })
        hl("DiagnosticVirtualTextWarn", { fg = colors.yellow0, italic = true })
        hl("DiagnosticVirtualTextInfo", { fg = colors.blue3, italic = true })
        hl("DiagnosticVirtualTextHint", { fg = colors.purple0, italic = true })
        -- diff
        hl("DiffChange", { bg = colors.diff_x })
        hl("DiffText", { bg = colors.diff_t, fg = colors.fg1 })
        hl("DiffAdd", { bg = colors.diff_a })
        hl("DiffDelete", { bg = colors.diff_d, fg = colors.diff_l })
        hl("diffAdded", { fg = colors.diff_s })
        hl("diffRemoved", { fg = colors.diff_r })
        hl("diffChanged", { fg = colors.diff_o })
        hl("@diff.plus", { link = "diffAdded" })
        hl("@diff.minus", { link = "diffRemoved" })
        hl("@diff.delta", { link = "diffChanged" })

        --NOTE: Syntax
        hl("Function", { fg = colors.fg2 })
        hl("Identifier", { fg = colors.gray7 })
        hl("Structure", { fg = colors.fg2 })
        hl("StorageClass", { fg = colors.fg2 })
        hl("Special", { link = "Function" })
        hl("SpecialChar", { link = "Special" })

        hl("Repeat", { fg = colors.gray7 })
        hl("Exception", { fg = colors.fg2 })
        hl("Conditional", { fg = colors.fg2 })
        hl("Include", { fg = colors.fg2 })
        hl("Tag", { fg = colors.fg2 })
        -- 1red
        hl("Keyword", { fg = colors.red4 })
        hl("Statement", { fg = colors.red4 })
        hl("Number", { fg = colors.red4 })
        hl("Float", { fg = colors.red4 })
        --2yellow
        hl("Character", { fg = colors.yellow1 })
        hl("String", { fg = colors.yellow1 })
        --3blue
        hl("Type", { fg = colors.blue1 })
        hl("Typedef", { link = "Type" })
        hl("Operator", { fg = colors.blue2 })
        hl("Define", { fg = colors.blue1 })
        hl("PreProc", { fg = colors.blue1 })
        hl("PreCondit", { link = "PreProc" })
        --4gray
        hl("Comment", { fg = colors.gray5 })
        hl("Delimiter", { fg = colors.gray5 })
        hl("SpecialComment", { fg = colors.gray5, italic = true })
        -- 5 6purple
        hl("Boolean", { fg = colors.purple0 })
        hl("Macro", { fg = colors.purple0 })
        hl("Constant", { fg = colors.purple0 })
        hl("Label", { fg = colors.red4 })

        --NOTE: Treesitter
        hl("@variable", { link = "Function" })
        hl("@constant", { link = "Constant" })
        hl("@label", { link = "Label" })
        hl("@boolean", { link = "Boolean" })
        hl("@number", { link = "Number" })
        hl("@type", { link = "Type" })
        hl("@function", { link = "Function" })
        hl("@constructor", { link = "Function" })
        hl("@operator", { link = "Operator" })
        hl("@keyword", { link = "Keyword" })
        hl("@punctuation.delimiter", { link = "Delimiter" })
        hl("@punctuation.bracket", { link = "Delimiter" })
        hl("@punctuation.special", { link = "Constant" })
        hl("@tag", { link = "Tag" })
        hl("@comment", { link = "Comment" })
        hl("@module", { link = "Include" })
        hl("@string", { link = "String" })
        -- md
        hl("@markup.heading.1", { fg = colors.red1, bold = true })
        hl("@markup.heading.2", { fg = colors.yellow2, bold = true })
        hl("@markup.heading.3", { fg = colors.purple0, bold = true })
        hl("@markup.strong", { fg = colors.blue1, bold = true })
        hl("@markup.italic", { fg = colors.blue1, italic = true })
        hl("@markup.link", { fg = colors.blue3 })
        -- custom
        hl("@string.escape", { fg = colors.blue2 })
        hl("@string.regexp", { fg = colors.purple1 })
        hl("@attribute", { fg = colors.green1 })
        hl("@tag.attribute", { fg = colors.blue1 })
        hl("@string.documentation", { fg = colors.blue1 })
        hl("@comment.documentation", { fg = colors.blue1 })

        --PLUG:
        hl("GitSignsAdd", { fg = colors.gray8 })
        hl("GitSignsChange", { fg = colors.yellow0 })
        hl("GitSignsDelete", { fg = colors.red2 })

        hl("FlashMatch", { link = "Normal" })
        hl("FlashCurrent", { bg = colors.red2 })
        hl("FlashLabel", { fg = colors.red3, bold = true })

        hl("BlinkCmpKind", { fg = colors.purple0 })

        hl("FzfLuaBorder", { bg = colors.bg0, fg = colors.gray3 })
        hl("FzfLuaTitle", { fg = colors.fg0 })

        hl("NvimTreeIndentMarker", { link = "Comment" })
        hl("NvimTreeGitFolderDirtyHL", { fg = colors.red4 })
        hl("NvimTreeGitFileDirtyHL", { link = "NvimTreeGitFolderDirtyHL" })
        hl("NvimTreeGitFileNewHL", { fg = colors.green1 })
        hl("AlphaHeader", { fg = colors.miku })

        hl("HeirlineA", { fg = colors.blue2 })
        hl("HeirlineB", { fg = colors.purple0 })

        hl("IndentLine", { link = "Whitespace" })
        hl("IndentLineCurrent", { link = "Whitespace" })

        vim.g.terminal_color_background = colors.bg0
        vim.g.terminal_color_foreground = colors.fg2
        vim.g.terminal_color_0 = colors.bg0
        vim.g.terminal_color_1 = colors.red4
        vim.g.terminal_color_2 = colors.blue2
        vim.g.terminal_color_3 = colors.yellow1
        vim.g.terminal_color_4 = colors.blue1
        vim.g.terminal_color_5 = colors.purple0
        vim.g.terminal_color_6 = colors.blue2
        vim.g.terminal_color_7 = colors.fg2
        vim.g.terminal_color_8 = colors.fg2
        vim.g.terminal_color_9 = colors.red4
        vim.g.terminal_color_10 = colors.purple0
        vim.g.terminal_color_11 = colors.yellow0
        vim.g.terminal_color_12 = colors.fg0
        vim.g.terminal_color_13 = colors.red4
        vim.g.terminal_color_14 = colors.yellow2
        vim.g.terminal_color_15 = colors.fg2
end

m39k()
