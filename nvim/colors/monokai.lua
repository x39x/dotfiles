local function hl(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
end

--  "#C0C1B5",
--  "#C0C0BB",
--  "#919288",
--  "#75715E",
--  "#6E7066",
--  "#21221D",

local colors = {
        miku = "#ACB5DE",
        high = "#32fa6d",

        -- DONE:
        red = "#F92672",
        yel = "#E6DB74",
        blu = "#66D9EF",
        gre = "#A6E22E",
        pur = "#AE81FF",
        ora = "#FD971F",

        fg2 = "#F5F5F5",
        fg0 = "#FDFFF1",
        fg1 = "#57584F",
        fg3 = "#444444",

        bg0 = "#272822",
        bg2 = "#3B3C35",
        bg3 = "#1D1E19",
        bg1 = "#000000",

        --TODO:
        gray3 = "#444444",
        gray4 = "#727272",
        red0 = "#f50000",
        red1 = "#a1384a",

        green0 = "#0FBC79",
        green1 = "#3e872f",

        gray8 = "#9DB1C5", -- GIT
        blue5 = "#264F78", -- visual

        -- diff
        diff_add = "#3D452D",
        diff_del = "#532821",
        diff_changed = "#25323E",
        diff_text = "#385570",
        diff_ = "",
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
        hl("FloatBorder", { fg = colors.fg3, bg = colors.bg2 })
        hl("CursorLine", { bg = colors.bg2 })
        hl("CursorColumn", { bg = colors.bg2 })
        hl("Cursor", { fg = colors.bg0, bg = colors.fg0 })
        hl("LineNr", { fg = colors.gray4 })
        hl("CursorLineNr", { fg = colors.fg0 })
        hl("SignColumn", { fg = colors.gray4, bg = colors.bg0 })
        hl("ColorColumn", { bg = colors.bg2 })
        hl("StatusLine", { fg = colors.gray4, bg = colors.bg0 })
        hl("StatusLineNC", { fg = colors.gray4, bg = colors.bg0 })
        hl("VertSplit", { fg = colors.fg3 })
        hl("WinSeparator", { fg = colors.fg3 })
        hl("Pmenu", { bg = colors.bg2 })
        hl("PmenuSel", { bg = colors.bg0 })
        hl("PmenuSbar", { bg = colors.bg2 })
        hl("PmenuThumb", { bg = colors.gray4 })
        hl("TabLine", { fg = colors.gray4, bg = colors.bg2 })
        hl("TabLineFill", { bg = colors.bg2 })
        hl("TabLineSel", { fg = colors.fg2, bg = colors.bg0 })
        hl("Visual", { bg = colors.blue5 })
        hl("VisualNOS", { bg = colors.red })
        hl("Search", { bg = colors.yel, fg = colors.bg1 })
        hl("CurSearch", { bg = colors.green0, fg = colors.bg1 })
        hl("IncSearch", { bg = colors.red, fg = colors.bg1 })
        hl("MatchParen", { bg = colors.green0, fg = colors.bg1 })
        hl("Directory", { fg = colors.pur })
        hl("Folded", { fg = colors.gray4, bg = colors.bg3 })
        hl("FoldColumn", { fg = colors.gray4, bg = colors.bg0 })
        hl("NonText", { fg = colors.gray4 })
        hl("EndOfBuffer", { fg = colors.gray4 })
        hl("SpecialKey", { fg = colors.gray4 })
        hl("Title", { fg = colors.blu, bold = true })
        hl("Question", { fg = colors.pur })
        hl("MoreMsg", { fg = colors.pur })
        hl("ModeMsg", { fg = colors.fg0 })
        hl("ErrorMsg", { fg = colors.red })
        hl("WarningMsg", { fg = colors.ora })
        hl("WildMenu", { fg = colors.fg2, bg = colors.bg3 })
        hl("Conceal", { fg = colors.fg1 })
        hl("Whitespace", { fg = colors.bg2 })
        hl("Underlined", { underline = true })
        hl("Todo", { fg = colors.fg2, bg = colors.bg3, bold = true })
        hl("Added", { fg = colors.gre })

        --NOTE:  LSP Diagnostics Diff
        hl("LspReferenceText", { bg = colors.bg3 })
        hl("LspReferenceRead", { bg = colors.bg3 })
        hl("LspReferenceWrite", { bg = colors.bg3 })
        hl("LspCodeLens", { fg = colors.fg1 })
        hl("LspCodeLensText", { fg = colors.fg1 })
        hl("LspCodeLensSign", { fg = colors.fg1 })
        hl("LspSignatureActiveParameter", { fg = colors.ora, bold = true })
        hl("LspInlayHint", { fg = colors.fg1, italic = true })
        -- Diagnostics (LSP)
        hl("DiagnosticError", { fg = colors.red })
        hl("DiagnosticWarn", { fg = colors.ora })
        hl("DiagnosticInfo", { fg = colors.blu })
        hl("DiagnosticHint", { fg = colors.pur })
        hl("DiagnosticUnderlineError", { sp = colors.red, undercurl = true })
        hl("DiagnosticUnderlineWarn", { sp = colors.ora, undercurl = true })
        hl("DiagnosticUnderlineInfo", { sp = colors.blu, undercurl = true })
        hl("DiagnosticUnderlineHint", { sp = colors.pur, undercurl = true })
        hl("DiagnosticSignError", { fg = colors.red })
        hl("DiagnosticSignWarn", { fg = colors.ora })
        hl("DiagnosticSignInfo", { fg = colors.blu })
        hl("DiagnosticSignHint", { fg = colors.pur })
        hl("DiagnosticFloatingError", { fg = colors.red })
        hl("DiagnosticFloatingWarn", { fg = colors.ora })
        hl("DiagnosticFloatingInfo", { fg = colors.blu })
        hl("DiagnosticFloatingHint", { fg = colors.pur })
        hl("DiagnosticVirtualTextError", { fg = colors.red, italic = true })
        hl("DiagnosticVirtualTextWarn", { fg = colors.ora, italic = true })
        hl("DiagnosticVirtualTextInfo", { fg = colors.blu, italic = true })
        hl("DiagnosticVirtualTextHint", { fg = colors.pur, italic = true })
        -- diff
        hl("DiffAdd", { bg = colors.diff_add })
        hl("DiffDelete", { bg = colors.diff_del, fg = colors.fg1 })
        hl("DiffChange", { bg = colors.diff_changed })
        hl("DiffText", { bg = colors.diff_text, fg = colors.high })
        hl("@diff.plus", { link = "DiffAdd" })
        hl("@diff.minus", { link = "DiffDelete" })
        hl("@diff.delta", { link = "DiffChange" })

        --NOTE: Syntax
        hl("Function", { fg = colors.fg0 })
        hl("Identifier", { fg = colors.fg0 })
        hl("Structure", { fg = colors.fg0 })
        hl("StorageClass", { fg = colors.fg0 })
        hl("Special", { link = "Function" })
        hl("SpecialChar", { link = "Special" })
        hl("Repeat", { fg = colors.fg0 })
        hl("Exception", { fg = colors.fg0 })
        hl("Conditional", { fg = colors.fg0 })
        hl("Tag", { fg = colors.fg0 })
        hl("Delimiter", { fg = colors.fg0 })
        -- red
        hl("Keyword", { fg = colors.red })
        hl("Statement", { fg = colors.red })
        hl("Float", { fg = colors.red })
        hl("Character", { fg = colors.red })
        --yellow
        hl("Boolean", { fg = colors.yel })
        --blue
        hl("Type", { fg = colors.blu })
        hl("Typedef", { link = "Type" })
        hl("Define", { fg = colors.blu })
        hl("PreProc", { fg = colors.blu })
        hl("PreCondit", { link = "PreProc" })
        hl("Include", { fg = colors.blu })
        --green
        hl("String", { fg = colors.gre })
        -- purple
        hl("Macro", { fg = colors.pur })
        hl("Constant", { fg = colors.pur })
        hl("Label", { fg = colors.pur })
        hl("Number", { fg = colors.pur })
        --orange
        hl("Operator", { fg = colors.ora })
        --gray
        hl("Comment", { fg = colors.fg1 })
        hl("SpecialComment", { fg = colors.fg1, italic = true })

        --NOTE: Treesitter
        hl("@keyword", { link = "Keyword" })
        hl("@function", { link = "Function" })
        hl("@number", { link = "Number" })
        hl("@boolean", { link = "Boolean" })
        hl("@variable", { link = "Function" })
        hl("@constructor", { link = "Function" })
        hl("@module", { link = "Include" })
        hl("@label", { link = "Label" })
        hl("@tag", { link = "Tag" })
        hl("@comment", { link = "Comment" })
        hl("@operator", { link = "Operator" })
        hl("@punctuation.delimiter", { link = "Delimiter" })
        hl("@punctuation.bracket", { link = "Delimiter" })
        hl("@punctuation.special", { link = "Constant" })
        hl("@string", { link = "String" })

        hl("@constant", { link = "Constant" })
        hl("@constant.builtin", { link = "Constant" })

        hl("@type", { link = "Type" })
        hl("@type.builtin", { link = "Type" })

        -- md
        hl("@markup.heading.1", { fg = colors.red, bold = true })
        hl("@markup.heading.2", { fg = colors.yel, bold = true })
        hl("@markup.heading.3", { fg = colors.pur, bold = true })
        hl("@markup.strong", { fg = colors.blu, bold = true })
        hl("@markup.italic", { fg = colors.blu, italic = true })
        hl("@markup.link", { fg = colors.blu })
        -- custom
        hl("@string.escape", { fg = colors.pur })
        hl("@string.regexp", { fg = colors.ora })
        hl("@string.documentation", { fg = colors.blu })
        hl("@comment.documentation", { fg = colors.blu })
        hl("@character.printf", { fg = colors.ora })

        hl("@attribute", { fg = colors.green0 })
        hl("@tag.attribute", { fg = colors.blu })

        --NOTE: quickfix
        hl("QuickFixLine", { fg = colors.blu })
        hl("QuickFixError", { fg = colors.red })
        hl("qfSeparator", { fg = colors.fg3 })
        hl("qfSeparator1", { link = "qfSeparator" })
        hl("qfSeparator2", { link = "qfSeparator" })
        hl("qfLineNr", { link = "Function" })
        hl("qfFileName", { link = "Function" })

        --PLUG:
        hl("diffAdded", { fg = colors.gre })
        hl("diffRemoved", { fg = colors.red })
        hl("diffChanged", { fg = colors.ora })
        hl("GitSignsAdd", { link = "diffAdded" })
        hl("GitSignsChange", { link = "diffChanged" })
        hl("GitSignsDelete", { link = "diffRemoved" })
        hl("CodeDiffCharInsert", { bg = colors.green1 })
        hl("CodeDiffCharDelete", { bg = colors.red1 })
        hl("CodeDiffFiller", { fg = colors.gray3 })

        hl("FlashLabel", { fg = colors.high, bold = true })
        hl("FlashCurrent", { link = "Function" })
        hl("FlashMatch", { link = "Function" })

        hl("BlinkCmpKind", { fg = colors.pur })

        hl("FzfLuaBorder", { bg = colors.bg0, fg = colors.fg3 })
        hl("FzfLuaTitle", { fg = colors.fg0 })

        hl("NvimTreeIndentMarker", { link = "Comment" })
        hl("NvimTreeGitFolderDirtyHL", { fg = colors.red })
        hl("NvimTreeGitFileDirtyHL", { link = "NvimTreeGitFolderDirtyHL" })
        hl("NvimTreeGitFileNewHL", { fg = colors.green0 })
        hl("AlphaHeader", { fg = colors.miku })

        hl("HeirlineA", { fg = colors.blu })
        hl("HeirlineB", { fg = colors.pur })

        hl("IndentLine", { link = "Whitespace" })
        hl("IndentLineCurrent", { link = "Whitespace" })

        hl("DapBreakpointHighlight", { fg = colors.red })
        hl("DapStoppedHiglight", { fg = colors.green0 })

        hl("NvimDapVirtualText", { link = "Comment" })
        hl("NvimDapVirtualTextChanged", { fg = colors.red })

        vim.g.terminal_color_background = colors.bg0
        vim.g.terminal_color_foreground = colors.fg0
        vim.g.terminal_color_0 = colors.bg0
        vim.g.terminal_color_1 = colors.red
        vim.g.terminal_color_2 = colors.blu
        vim.g.terminal_color_3 = colors.ora
        vim.g.terminal_color_4 = colors.blu
        vim.g.terminal_color_5 = colors.pur
        vim.g.terminal_color_6 = colors.blu
        vim.g.terminal_color_7 = colors.fg0
        vim.g.terminal_color_8 = colors.fg0
        vim.g.terminal_color_9 = colors.red
        vim.g.terminal_color_10 = colors.pur
        vim.g.terminal_color_11 = colors.ora
        vim.g.terminal_color_12 = colors.fg0
        vim.g.terminal_color_13 = colors.red
        vim.g.terminal_color_14 = colors.yel
        vim.g.terminal_color_15 = colors.fg0
end

m39k()
