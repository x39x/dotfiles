local function hl(group, properties)
        vim.api.nvim_set_hl(0, group, properties)
end

local colors = {
        --TODO: unused
        cyan2 = "#248f8f",
        cyan3 = "#3377aa",
        cyan4 = "#36666b",
        cyan5 = "#286d73",
        cyan1 = "#88aa99",
        purple3 = "#662277",
        purple1 = "#45164F",
        yellow4 = "#F7E6A0",
        brown2 = "#805900",
        brown3 = "#8c6c41",

        miku = "#1F30C8",

        cyan0 = "#00627A",

        purple4 = "#6B2FBA",
        purple0 = "#871094",
        purple2 = "#74118c",

        bg0 = "#FFFFFF",
        bg1 = "#F6F8FE",
        bg2 = "#F7F8FA",
        bg3 = "#EBECF0",
        bg4 = "#D6D6D6",
        bg5 = "#D5E1FF",

        fg0 = "#080808",
        fg2 = "#8C8C8C",
        fg1 = "#AEB3C2",
        fg3 = "#D3D3D3",
        fg4 = "#B5B7BD",

        green0 = "#10B981",
        green1 = "#1B7F37",
        green5 = "#397d2c",
        green2 = "#077D18",
        green7 = "#6DB083",
        green6 = "#8EC39D",
        green3 = "#BEE6BE",
        green4 = "#E9F5E6",

        red0 = "#f50000",
        red2 = "#CE0606",
        red7 = "#DB3B4B",
        red4 = "#de0202",
        red8 = "#D3302F",
        red1 = "#DC2626",
        red6 = "#FFC4C5",
        red5 = "#FFE5E5",

        blue1 = "#0137A6",
        blue2 = "#0133B3",
        blueD = "#0042B6",
        blueC = "#174ad4",
        blue3 = "#264eff",
        blue7 = "#174be6",
        blue4 = "#1750EB",
        blue5 = "#0A69DA",
        blueB = "#8cb1de",
        blue6 = "#A6D2FF",
        blue8 = "#B4D7FF",
        blueA = "#E7EFFA",
        blueE = "#E3EBFE",
        blueF = "#A7C5FF",

        orange = "#b86114",

        brown0 = "#9E880D",
        brown1 = "#B28B00",

        yellow0 = "#e6bc05",
        yellow1 = "#F2BF56",
        yellow2 = "#FCD57E",
}

local function m39k()
        vim.cmd("hi clear")
        if vim.fn.exists("syntax_on") then
                vim.cmd("syntax reset")
        end
        vim.o.background = "light"
        vim.g.colors_name = "39light"

        -- NOTE:  UI  https://neovim.io/doc/user/syntax/#highlight-groups
        hl("Normal", { fg = colors.fg0, bg = colors.bg0 })
        hl("NormalFloat", { bg = colors.bg2 })
        hl("FloatBorder", { bg = colors.bg2, fg = colors.bg4 })
        hl("LineNr", { fg = colors.fg1 })
        hl("EndOfBuffer", { link = "Whitespace" })
        hl("WildMenu", { bg = colors.bg2 })
        hl("Pmenu", { bg = colors.bg2 })
        hl("PmenuSel", { bg = colors.bg5 })
        hl("PmenuSbar", { bg = colors.bg2 })
        hl("PmenuThumb", { bg = colors.bg2 })
        hl("PmenuMatch", { bold = true })
        hl("PmenuMatchSel", { bold = true })
        hl("TabLine", { bg = colors.bg2 })
        hl("TabLineSel", { fg = colors.blueC, bg = colors.bg0 })
        hl("CursorLine", { bg = colors.bg1 })
        hl("ColorColumn", { link = "CursorLine" })
        hl("StatusLine", { fg = colors.blue3 })
        hl("StatusLineNC", { link = "StatusLine" })
        hl("Folded", { bg = colors.green4 })
        hl("Search", { bg = colors.yellow2, fg = colors.fg0 })
        hl("CurSearch", { bg = colors.green0, fg = colors.fg0 })
        hl("IncSearch", { bg = colors.red1, fg = colors.fg0 })
        hl("MatchParen", { bg = colors.blue6 })
        hl("Visual", { bg = colors.blue8 })
        hl("Directory", { fg = colors.fg0 })
        hl("Whitespace", { fg = colors.bg3 }) --indent line
        hl("WinSeparator", { link = "Whitespace" })
        hl("MsgSeparator", { link = "CursorLine" })
        hl("WarningMsg", { fg = colors.orange })
        hl("ErrorMsg", { fg = colors.red1 })
        hl("ModeMsg", { bg = colors.bg0, fg = colors.fg0 })
        hl("Title", { fg = colors.blueD, bold = true })
        hl("Underlined", { underline = true })

        --NOTE: LSP DIFF
        hl("DiagnosticError", { fg = colors.red1 })
        hl("DiagnosticWarn", { fg = colors.orange })
        hl("DiagnosticInfo", { fg = colors.blue5 })
        hl("DiagnosticHint", { fg = colors.green0 })
        hl("DiagnosticUnderlineError", { undercurl = true, sp = colors.red0 })
        hl("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow1 })
        hl("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.blue5 })
        hl("DiagnosticUnderlineHint", { undercurl = true, sp = colors.green0 })
        --diff
        hl("DiffAdd", { bg = colors.green3 })
        hl("DiffDelete", { bg = colors.red5, fg = colors.fg4 })
        hl("DiffChange", { bg = colors.blueE })
        hl("DiffText", { bg = colors.blueF, fg = colors.red4 })
        hl("@diff.plus", { link = "DiffAdd" })
        hl("@diff.minus", { link = "DiffDelete" })
        hl("@diff.delta", { link = "DiffChange" })

        -- NOTE: Syntax  https://neovim.io/doc/user/syntax/#group-name
        hl("Function", { fg = colors.fg0 })
        hl("Identifier", { fg = colors.fg0 })
        hl("Structure", { fg = colors.fg0 })
        hl("StorageClass", { fg = colors.fg0 })
        hl("Special", { fg = colors.fg0 })
        hl("SpecialChar", { link = "Special" })
        hl("Repeat", { fg = colors.fg0 })
        hl("Exception", { fg = colors.fg0 })
        hl("Conditional", { fg = colors.fg0 })
        hl("Include", { fg = colors.fg0 })
        hl("Tag", { fg = colors.fg })
        hl("Comment", { fg = colors.fg2 })
        -- 1blue
        hl("Keyword", { fg = colors.blue2 })
        hl("Statement", { fg = colors.blue7 })
        hl("Number", { fg = colors.blue4 })
        hl("Float", { fg = colors.blue4 })
        -- 2green
        hl("Character", { fg = colors.green1 })
        hl("String", { fg = colors.green2 })
        -- 3purple
        hl("Operator", { fg = colors.purple0 })
        hl("Define", { fg = colors.purple2 })
        hl("PreProc", { fg = colors.purple2 })
        hl("PreCondit", { link = "PreProc" })
        --4cyan0
        hl("Type", { fg = colors.purple0 })
        hl("Typedef", { link = "Type" })
        hl("Delimiter", { fg = colors.cyan0 })
        hl("SpecialComment", { fg = colors.cyan0 })
        --5brown
        hl("Boolean", { fg = colors.brown0 })
        hl("Macro", { fg = colors.brown0 })
        -- 6red
        hl("Constant", { fg = colors.red8 })
        hl("Label", { fg = colors.red8 })

        --NOTE: Treesitter  https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
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
        hl("@punctuation.bracket", { link = "Operator" })
        hl("@punctuation.special", { link = "Constant" })
        hl("@string", { link = "String" })

        hl("@type", { link = "Type" })
        hl("@type.builtin", { link = "Type" })

        hl("@constant", { link = "Constant" })
        hl("@constant.builtin", { link = "Constant" })

        -- md
        hl("@markup.heading.1", { fg = colors.purple0, bold = true })
        hl("@markup.heading.2", { fg = colors.green2, bold = true })
        hl("@markup.heading.3", { fg = colors.blue3, bold = true })
        hl("@markup.strong", { fg = colors.blue1, bold = true })
        hl("@markup.italic", { fg = colors.blue1, italic = true })
        hl("@markup.link", { fg = colors.blueD })
        -- custom
        hl("@string.escape", { fg = colors.purple4 })
        hl("@string.regexp", { fg = colors.brown0 })
        hl("@string.documentation", { fg = colors.brown0 })
        hl("@comment.documentation", { fg = colors.brown0 })
        hl("@character.printf", { fg = colors.brown0 })

        hl("@attribute", { fg = colors.red8 })
        hl("@tag.attribute", { fg = colors.purple0 })

        -- NOTE: quickfix
        hl("QuickFixLine", { fg = colors.blue3 })
        hl("QuickFixError", { fg = colors.red2 })
        hl("qfSeparator", { fg = colors.bg4 })
        hl("qfSeparator1", { link = "qfSeparator" })
        hl("qfSeparator2", { link = "qfSeparator" })
        hl("qfLineNr", { link = "Function" })
        hl("qfFileName", { link = "Function" })

        --PLUG:
        hl("diffAdded", { fg = colors.green7 })
        hl("diffRemoved", { fg = colors.red2 })
        hl("diffChanged", { fg = colors.brown1 })
        hl("GitSignsAdd", { link = "diffAdded" })
        hl("GitSignsChange", { link = "diffChanged" })
        hl("GitSignsDelete", { link = "diffRemoved" })
        hl("CodeDiffCharInsert", { bg = colors.green6 })
        hl("CodeDiffCharDelete", { bg = colors.red6 })
        hl("CodeDiffFiller", { fg = colors.bg4 })

        hl("FlashMatch", { link = "Function" })
        hl("FlashCurrent", { bg = colors.red1 })
        hl("FlashLabel", { fg = colors.red4, bold = true })

        hl("BlinkCmpKind", { fg = colors.purple0 })

        hl("FzfLuaBorder", { bg = colors.bg, fg = colors.bg4 })
        hl("FzfLuaTitle", { fg = colors.fg2 })

        hl("NvimTreeIndentMarker", { link = "Comment" })
        hl("NvimTreeGitFolderDirtyHL", { link = "diffRemoved" })
        hl("NvimTreeGitFileDirtyHL", { link = "NvimTreeGitFolderDirtyHL" })
        hl("NvimTreeGitFileNewHL", { fg = colors.green0 })

        hl("AlphaHeader", { fg = colors.miku })

        hl("HeirlineA", { fg = colors.blue2 })
        hl("HeirlineB", { fg = colors.purple0 })

        hl("IndentLine", { link = "Whitespace" })
        hl("IndentLineCurrent", { link = "Whitespace" })

        hl("DapBreakpointHighlight", { fg = colors.red7 })
        hl("DapStoppedHiglight", { fg = colors.green0 })

        hl("NvimDapVirtualText", { link = "Comment" })
        hl("NvimDapVirtualTextChanged", { fg = colors.red7 })

        vim.g.terminal_color_background = colors.bg0
        vim.g.terminal_color_foreground = colors.fg0
        vim.g.terminal_color_0 = colors.bg
        vim.g.terminal_color_1 = colors.red4
        vim.g.terminal_color_2 = colors.green2
        vim.g.terminal_color_3 = colors.yellow1
        vim.g.terminal_color_4 = colors.blue2
        vim.g.terminal_color_5 = colors.purple0
        vim.g.terminal_color_6 = colors.blue3
        vim.g.terminal_color_7 = colors.fg
        vim.g.terminal_color_8 = colors.fg
        vim.g.terminal_color_9 = colors.red4
        vim.g.terminal_color_10 = colors.purple0
        vim.g.terminal_color_11 = colors.yellow0
        vim.g.terminal_color_12 = colors.cyan0
        vim.g.terminal_color_13 = colors.red0
        vim.g.terminal_color_14 = colors.yellow2
        vim.g.terminal_color_15 = colors.fg2
end

m39k()
