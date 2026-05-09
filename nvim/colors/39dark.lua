local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local colors = {
	--UI
	miku = "#ACB5DE",

	red0 = "#f50000",
	red1 = "#cd3131",
	red2 = "#f97583",
	red3 = "#6D3136",
	red4 = "#cd3131",
	red5 = "#3F1E21",

	yel0 = "#FF9800",
	yel4 = "#d68349",
	yel1 = "#ffab70",
	yel3 = "#FCE094",

	blu0 = "#79b8ff",
	blu1 = "#6db0fc",
	blu2 = "#316bcd",
	blu3 = "#264F78",
	blu4 = "#385570",
	blu5 = "#25323E",

	gre2 = "#32fa6d",
	gre0 = "#0FBC79",
	gre3 = "#1B7F37",
	gre1 = "#274B34",
	gre4 = "#192C20",

	pur0 = "#b392f0",
	pur1 = "#a485de",

	fg0 = "#f8f8f8",
	fg1 = "#F5F5F5",

	gra0 = "#888888",
	gra1 = "#727272",
	gra2 = "#6b737c",
	gra3 = "#444444",
	gra4 = "#303030",
	gra5 = "#2A2A2A",

	bg0 = "#1F1F1F",
	bg1 = "#000000",
	bg2 = "#1A1A1A",
	bg3 = "#292929",
	bg4 = "#212121",
}

local function m39k()
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	vim.o.background = "dark"
	vim.g.colors_name = "39dark"

	--NOTE: UI
	hl("Normal", { fg = colors.gra0, bg = colors.bg0 })
	hl("NormalFloat", { fg = colors.gra0, bg = colors.bg2 })
	hl("FloatBorder", { fg = colors.gra3, bg = colors.bg2 })
	hl("CursorLine", { bg = colors.gra4 })
	hl("CursorColumn", { bg = colors.gra4 })
	hl("Cursor", { fg = colors.bg0, bg = colors.gra0 })
	hl("LineNr", { fg = colors.gra1 })
	hl("CursorLineNr", { fg = colors.fg0 })
	hl("SignColumn", { fg = colors.gra1, bg = colors.bg0 })
	hl("ColorColumn", { bg = colors.gra4 })
	hl("StatusLine", { fg = colors.gra1, bg = colors.bg2 })
	hl("StatusLineNC", { fg = colors.gra1, bg = colors.bg2 })
	hl("VertSplit", { fg = colors.gra3 })
	hl("WinSeparator", { fg = colors.gra3 })
	hl("Pmenu", { fg = colors.gra0, bg = colors.bg2 })
	hl("PmenuSel", { fg = colors.fg1, bg = colors.bg4 })
	hl("PmenuSbar", { bg = colors.bg2 })
	hl("PmenuThumb", { bg = colors.bg2 })
	hl("TabLine", { fg = colors.gra1, bg = colors.bg2 })
	hl("TabLineFill", { bg = colors.bg2 })
	hl("TabLineSel", { fg = colors.fg1, bg = colors.bg0 })
	hl("Visual", { bg = colors.blu3 })
	hl("VisualNOS", { bg = colors.red1 })
	hl("Search", { bg = colors.yel3, fg = colors.bg1 })
	hl("CurSearch", { bg = colors.gre0, fg = colors.bg1 })
	hl("IncSearch", { bg = colors.red0, fg = colors.bg1 })
	hl("MatchParen", { bg = colors.gre0, fg = colors.bg1 })
	hl("Directory", { fg = colors.pur0 })
	hl("Folded", { fg = colors.gra1, bg = colors.bg3 })
	hl("FoldColumn", { fg = colors.gra1, bg = colors.bg0 })
	hl("NonText", { fg = colors.gra1 })
	hl("EndOfBuffer", { fg = colors.gra1 })
	hl("SpecialKey", { fg = colors.gra1 })
	hl("Title", { fg = colors.blu0, bold = true })
	hl("Question", { fg = colors.pur0 })
	hl("MoreMsg", { fg = colors.pur0 })
	hl("ModeMsg", { fg = colors.gra0 })
	hl("ErrorMsg", { fg = colors.red1 })
	hl("WarningMsg", { fg = colors.yel0 })
	hl("WildMenu", { fg = colors.fg1, bg = colors.bg3 })
	hl("Conceal", { fg = colors.gra2 })
	hl("Whitespace", { fg = colors.gra5 })
	hl("Underlined", { underline = true })

	--NOTE:  LSP Diagnostics Diff
	hl("LspReferenceText", { bg = colors.bg3 })
	hl("LspReferenceRead", { bg = colors.bg3 })
	hl("LspReferenceWrite", { bg = colors.bg3 })
	hl("LspCodeLens", { fg = colors.gra2 })
	hl("LspCodeLensText", { fg = colors.gra2 })
	hl("LspCodeLensSign", { fg = colors.gra2 })
	hl("LspSignatureActiveParameter", { fg = colors.yel0, bold = true })
	hl("LspInlayHint", { fg = colors.gra2, italic = true })
	-- Diagnostics (LSP)
	hl("DiagnosticError", { fg = colors.red1 })
	hl("DiagnosticWarn", { fg = colors.yel0 })
	hl("DiagnosticInfo", { fg = colors.blu2 })
	hl("DiagnosticHint", { fg = colors.pur0 })
	hl("DiagnosticUnderlineError", { sp = colors.red1, undercurl = true })
	hl("DiagnosticUnderlineWarn", { sp = colors.yel0, undercurl = true })
	hl("DiagnosticUnderlineInfo", { sp = colors.blu2, undercurl = true })
	hl("DiagnosticUnderlineHint", { sp = colors.pur0, undercurl = true })
	hl("DiagnosticSignError", { fg = colors.red1 })
	hl("DiagnosticSignWarn", { fg = colors.yel0 })
	hl("DiagnosticSignInfo", { fg = colors.blu2 })
	hl("DiagnosticSignHint", { fg = colors.pur0 })
	hl("DiagnosticFloatingError", { fg = colors.red1 })
	hl("DiagnosticFloatingWarn", { fg = colors.yel0 })
	hl("DiagnosticFloatingInfo", { fg = colors.blu2 })
	hl("DiagnosticFloatingHint", { fg = colors.pur0 })
	hl("DiagnosticVirtualTextError", { fg = colors.red1, italic = true })
	hl("DiagnosticVirtualTextWarn", { fg = colors.yel0, italic = true })
	hl("DiagnosticVirtualTextInfo", { fg = colors.blu2, italic = true })
	hl("DiagnosticVirtualTextHint", { fg = colors.pur0, italic = true })
	-- diff
	hl("DiffAdd", { bg = colors.gre4 })
	hl("DiffDelete", { bg = colors.red5, fg = colors.gra3 })
	hl("DiffChange", { bg = colors.blu5 })
	hl("DiffText", { bg = colors.blu4, fg = colors.gre2 })
	hl("@diff.plus", { link = "DiffAdd" })
	hl("@diff.minus", { link = "DiffDelete" })
	hl("@diff.delta", { link = "DiffChange" })

	--NOTE: Syntax
	hl("Function", { fg = colors.fg0 })
	hl("Identifier", { fg = colors.fg1 })
	hl("Structure", { fg = colors.fg0 })
	hl("StorageClass", { fg = colors.fg0 })
	hl("Special", { link = "Function" })
	hl("SpecialChar", { link = "Special" })

	hl("Repeat", { fg = colors.fg1 })
	hl("Exception", { fg = colors.fg0 })
	hl("Conditional", { fg = colors.fg0 })
	hl("Include", { fg = colors.fg0 })
	hl("Tag", { fg = colors.fg0 })
	-- 1red
	hl("Keyword", { fg = colors.red2 })
	hl("Statement", { fg = colors.red2 })
	hl("Number", { fg = colors.red2 })
	hl("Float", { fg = colors.red2 })
	hl("Character", { fg = colors.red2 })
	--2yellow
	hl("String", { fg = colors.yel1 })
	--3blue
	hl("Type", { fg = colors.blu0 })
	hl("Typedef", { link = "Type" })
	hl("Operator", { fg = colors.blu1 })
	hl("Define", { fg = colors.blu0 })
	hl("PreProc", { fg = colors.blu0 })
	hl("PreCondit", { link = "PreProc" })
	--4gray
	hl("Comment", { fg = colors.gra2 })
	hl("Delimiter", { fg = colors.gra2 })
	hl("SpecialComment", { fg = colors.gra2, italic = true })
	-- 5 6purple
	hl("Boolean", { fg = colors.pur0 })
	hl("Macro", { fg = colors.pur0 })
	hl("Constant", { fg = colors.pur0 })
	hl("Label", { fg = colors.red2 })

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

	hl("@type", { link = "Type" })
	hl("@type.builtin", { link = "Type" })

	hl("@constant", { link = "Constant" })
	hl("@constant.builtin", { link = "Constant" })

	-- md
	hl("@markup.heading.1", { fg = colors.red2, bold = true })
	hl("@markup.heading.2", { fg = colors.yel3, bold = true })
	hl("@markup.heading.3", { fg = colors.pur0, bold = true })
	hl("@markup.strong", { fg = colors.blu0, bold = true })
	hl("@markup.italic", { fg = colors.blu0, italic = true })
	hl("@markup.link", { fg = colors.blu2 })
	-- custom
	hl("@string.escape", { fg = colors.blu1 })
	hl("@string.regexp", { fg = colors.pur1 })
	hl("@string.documentation", { fg = colors.blu0 })
	hl("@comment.documentation", { fg = colors.blu0 })
	hl("@character.printf", { fg = colors.pur1 })

	hl("@attribute", { fg = colors.gre0 })
	hl("@tag.attribute", { fg = colors.blu0 })

	--NOTE: quickfix
	hl("QuickFixLine", { fg = colors.blu1 })
	hl("QuickFixError", { fg = colors.red1 })
	hl("qfSeparator", { fg = colors.gra3 })
	hl("qfSeparator1", { link = "qfSeparator" })
	hl("qfSeparator2", { link = "qfSeparator" })
	hl("qfLineNr", { link = "Function" })
	hl("qfFileName", { link = "Function" })

	--PLUG:
	hl("diffAdded", { fg = colors.gre3 })
	hl("diffRemoved", { fg = colors.red4 })
	hl("diffChanged", { fg = colors.yel4 })
	hl("GitSignsAdd", { link = "diffAdded" })
	hl("GitSignsChange", { link = "diffChanged" })
	hl("GitSignsDelete", { link = "diffRemoved" })
	hl("CodeDiffCharInsert", { bg = colors.gre1 })
	hl("CodeDiffCharDelete", { bg = colors.red5 })
	hl("CodeDiffFiller", { fg = colors.gra3 })

	hl("FlashLabel", { fg = colors.gre2, bold = true })
	hl("FlashCurrent", { link = "Function" })
	hl("FlashMatch", { link = "Function" })

	hl("BlinkCmpKind", { fg = colors.pur0 })

	hl("FzfLuaBorder", { bg = colors.bg0, fg = colors.gra3 })
	hl("FzfLuaTitle", { fg = colors.gra0 })
	hl("FzfFgPlus", { fg = colors.gre0 })
	hl("FzfBgPlus", { bg = colors.bg0 })

	hl("NvimTreeIndentMarker", { link = "Comment" })
	hl("NvimTreeGitFolderDirtyHL", { fg = colors.red2 })
	hl("NvimTreeGitFileDirtyHL", { link = "NvimTreeGitFolderDirtyHL" })
	hl("NvimTreeGitFileNewHL", { fg = colors.gre0 })
	hl("AlphaHeader", { fg = colors.miku })

	hl("HeirlineA", { fg = colors.blu1 })
	hl("HeirlineB", { fg = colors.pur0 })

	hl("IndentLine", { link = "Whitespace" })
	hl("IndentLineCurrent", { link = "Whitespace" })

	hl("DapBreakpointHighlight", { fg = colors.red2 })
	hl("DapStoppedHiglight", { fg = colors.gre0 })

	hl("NvimDapVirtualText", { link = "Comment" })
	hl("NvimDapVirtualTextChanged", { fg = colors.red0 })

	hl("YaziFloatBorder", { fg = colors.gra3, bg = colors.bg0 })

	vim.g.terminal_color_background = colors.bg0
	vim.g.terminal_color_foreground = colors.fg0
	vim.g.terminal_color_0 = colors.bg0
	vim.g.terminal_color_1 = colors.red2
	vim.g.terminal_color_2 = colors.blu1
	vim.g.terminal_color_3 = colors.yel1
	vim.g.terminal_color_4 = colors.blu0
	vim.g.terminal_color_5 = colors.pur0
	vim.g.terminal_color_6 = colors.blu1
	vim.g.terminal_color_7 = colors.fg0
	vim.g.terminal_color_8 = colors.fg0
	vim.g.terminal_color_9 = colors.red2
	vim.g.terminal_color_10 = colors.pur0
	vim.g.terminal_color_11 = colors.yel0
	vim.g.terminal_color_12 = colors.gra0
	vim.g.terminal_color_13 = colors.red2
	vim.g.terminal_color_14 = colors.yel3
	vim.g.terminal_color_15 = colors.fg0
end

m39k()
