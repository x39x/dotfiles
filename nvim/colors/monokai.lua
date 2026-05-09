local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local colors = {
	miku = "#ACB5DE",

	fg0 = "#FDFFF1",
	fg2 = "#F5F5F5",

	bg0 = "#272822",
	bg2 = "#3B3C35",
	bg1 = "#000000",
	bg4 = "#21221D",
	bg3 = "#1D1E19",

	red0 = "#F92672",
	yel0 = "#E6DB74",
	blu0 = "#66D9EF",
	gre0 = "#A6E22E",
	pur0 = "#AE81FF",
	ora0 = "#FD971F",

	gra0 = "#727272",
	gra1 = "#57584F",
	gra2 = "#444444",

	red1 = "#f50000",
	red2 = "#a1384a",
	red3 = "#532821",

	gre4 = "#32fa6d",
	gre1 = "#0FBC79",
	gre2 = "#3e872f",
	gre3 = "#3D452D",

	blu1 = "#264F78",
	blu2 = "#25323E",
	blu3 = "#385570",
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
	hl("FloatBorder", { fg = colors.gra2, bg = colors.bg2 })
	hl("CursorLine", { bg = colors.bg2 })
	hl("CursorColumn", { bg = colors.bg2 })
	hl("Cursor", { fg = colors.bg0, bg = colors.fg0 })
	hl("LineNr", { fg = colors.gra0 })
	hl("CursorLineNr", { fg = colors.fg0 })
	hl("SignColumn", { fg = colors.gra0, bg = colors.bg0 })
	hl("ColorColumn", { bg = colors.bg2 })
	hl("StatusLine", { fg = colors.gra0, bg = colors.bg0 })
	hl("StatusLineNC", { fg = colors.gra0, bg = colors.bg0 })
	hl("VertSplit", { fg = colors.gra2 })
	hl("WinSeparator", { fg = colors.gra2 })
	hl("Pmenu", { bg = colors.bg2 })
	hl("PmenuSel", { bg = colors.gra1 })
	hl("PmenuSbar", { bg = colors.bg2 })
	hl("PmenuThumb", { bg = colors.bg2 })
	hl("TabLine", { fg = colors.gra0, bg = colors.bg2 })
	hl("TabLineFill", { bg = colors.bg2 })
	hl("TabLineSel", { fg = colors.fg2, bg = colors.bg0 })
	hl("Visual", { bg = colors.blu1 })
	hl("VisualNOS", { bg = colors.red0 })
	hl("Search", { bg = colors.yel0, fg = colors.bg1 })
	hl("CurSearch", { bg = colors.gre1, fg = colors.bg1 })
	hl("IncSearch", { bg = colors.red0, fg = colors.bg1 })
	hl("MatchParen", { bg = colors.gre1, fg = colors.bg1 })
	hl("Directory", { fg = colors.pur0 })
	hl("Folded", { fg = colors.gra0, bg = colors.bg3 })
	hl("FoldColumn", { fg = colors.gra0, bg = colors.bg0 })
	hl("NonText", { fg = colors.gra0 })
	hl("EndOfBuffer", { fg = colors.gra0 })
	hl("SpecialKey", { fg = colors.gra0 })
	hl("Title", { fg = colors.blu0, bold = true })
	hl("Question", { fg = colors.pur0 })
	hl("MoreMsg", { fg = colors.pur0 })
	hl("ModeMsg", { fg = colors.fg0 })
	hl("ErrorMsg", { fg = colors.red0 })
	hl("WarningMsg", { fg = colors.ora0 })
	hl("WildMenu", { fg = colors.fg2, bg = colors.bg3 })
	hl("Conceal", { fg = colors.gra1 })
	hl("Whitespace", { fg = colors.bg2 })
	hl("Underlined", { underline = true })
	hl("Todo", { fg = colors.fg2, bg = colors.bg3, bold = true })
	hl("Added", { fg = colors.gre0 })

	--NOTE:  LSP Diagnostics Diff
	hl("LspReferenceText", { bg = colors.bg3 })
	hl("LspReferenceRead", { bg = colors.bg3 })
	hl("LspReferenceWrite", { bg = colors.bg3 })
	hl("LspCodeLens", { fg = colors.gra1 })
	hl("LspCodeLensText", { fg = colors.gra1 })
	hl("LspCodeLensSign", { fg = colors.gra1 })
	hl("LspSignatureActiveParameter", { fg = colors.ora0, bold = true })
	hl("LspInlayHint", { fg = colors.gra1, italic = true })
	-- Diagnostics (LSP)
	hl("DiagnosticError", { fg = colors.red0 })
	hl("DiagnosticWarn", { fg = colors.ora0 })
	hl("DiagnosticInfo", { fg = colors.blu0 })
	hl("DiagnosticHint", { fg = colors.pur0 })
	hl("DiagnosticUnderlineError", { sp = colors.red0, undercurl = true })
	hl("DiagnosticUnderlineWarn", { sp = colors.ora0, undercurl = true })
	hl("DiagnosticUnderlineInfo", { sp = colors.blu0, undercurl = true })
	hl("DiagnosticUnderlineHint", { sp = colors.pur0, undercurl = true })
	hl("DiagnosticSignError", { fg = colors.red0 })
	hl("DiagnosticSignWarn", { fg = colors.ora0 })
	hl("DiagnosticSignInfo", { fg = colors.blu0 })
	hl("DiagnosticSignHint", { fg = colors.pur0 })
	hl("DiagnosticFloatingError", { fg = colors.red0 })
	hl("DiagnosticFloatingWarn", { fg = colors.ora0 })
	hl("DiagnosticFloatingInfo", { fg = colors.blu0 })
	hl("DiagnosticFloatingHint", { fg = colors.pur0 })
	hl("DiagnosticVirtualTextError", { fg = colors.red0, italic = true })
	hl("DiagnosticVirtualTextWarn", { fg = colors.ora0, italic = true })
	hl("DiagnosticVirtualTextInfo", { fg = colors.blu0, italic = true })
	hl("DiagnosticVirtualTextHint", { fg = colors.pur0, italic = true })
	-- diff
	hl("DiffAdd", { bg = colors.gre3 })
	hl("DiffDelete", { bg = colors.red3, fg = colors.gra1 })
	hl("DiffChange", { bg = colors.blu2 })
	hl("DiffText", { bg = colors.blu3, fg = colors.gre4 })
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
	hl("Keyword", { fg = colors.red0 })
	hl("Statement", { fg = colors.red0 })
	hl("Float", { fg = colors.red0 })
	hl("Character", { fg = colors.red0 })
	--yellow
	hl("Boolean", { fg = colors.yel0 })
	--blue
	hl("Type", { fg = colors.blu0 })
	hl("Typedef", { link = "Type" })
	hl("Define", { fg = colors.blu0 })
	hl("PreProc", { fg = colors.blu0 })
	hl("PreCondit", { link = "PreProc" })
	hl("Include", { fg = colors.blu0 })
	--green
	hl("String", { fg = colors.gre0 })
	-- purple
	hl("Macro", { fg = colors.pur0 })
	hl("Constant", { fg = colors.pur0 })
	hl("Label", { fg = colors.pur0 })
	hl("Number", { fg = colors.pur0 })
	--orange
	hl("Operator", { fg = colors.ora0 })
	--gray
	hl("Comment", { fg = colors.gra1 })
	hl("SpecialComment", { fg = colors.gra1, italic = true })

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
	hl("@markup.heading.1", { fg = colors.red0, bold = true })
	hl("@markup.heading.2", { fg = colors.yel0, bold = true })
	hl("@markup.heading.3", { fg = colors.pur0, bold = true })
	hl("@markup.strong", { fg = colors.blu0, bold = true })
	hl("@markup.italic", { fg = colors.blu0, italic = true })
	hl("@markup.link", { fg = colors.blu0 })
	-- custom
	hl("@string.escape", { fg = colors.pur0 })
	hl("@string.regexp", { fg = colors.ora0 })
	hl("@string.documentation", { fg = colors.blu0 })
	hl("@comment.documentation", { fg = colors.blu0 })
	hl("@character.printf", { fg = colors.ora0 })

	hl("@attribute", { fg = colors.gre1 })
	hl("@tag.attribute", { fg = colors.blu0 })

	--NOTE: quickfix
	hl("QuickFixLine", { fg = colors.blu0 })
	hl("QuickFixError", { fg = colors.red0 })
	hl("qfSeparator", { fg = colors.gra2 })
	hl("qfSeparator1", { link = "qfSeparator" })
	hl("qfSeparator2", { link = "qfSeparator" })
	hl("qfLineNr", { link = "Function" })
	hl("qfFileName", { link = "Function" })

	--PLUG:
	hl("diffAdded", { fg = colors.gre0 })
	hl("diffRemoved", { fg = colors.red0 })
	hl("diffChanged", { fg = colors.ora0 })
	hl("GitSignsAdd", { link = "diffAdded" })
	hl("GitSignsChange", { link = "diffChanged" })
	hl("GitSignsDelete", { link = "diffRemoved" })
	hl("CodeDiffCharInsert", { bg = colors.gre2 })
	hl("CodeDiffCharDelete", { bg = colors.red2 })
	hl("CodeDiffFiller", { fg = colors.gra2 })

	hl("FlashLabel", { fg = colors.gre4, bold = true })
	hl("FlashCurrent", { link = "Function" })
	hl("FlashMatch", { link = "Function" })

	hl("BlinkCmpKind", { fg = colors.pur0 })

	hl("FzfLuaBorder", { bg = colors.bg0, fg = colors.gra2 })
	hl("FzfLuaTitle", { fg = colors.fg0 })
	hl("FzfFgPlus", { fg = colors.gre1 })
	hl("FzfBgPlus", { bg = colors.bg0 })

	hl("NvimTreeIndentMarker", { link = "Comment" })
	hl("NvimTreeGitFolderDirtyHL", { fg = colors.red0 })
	hl("NvimTreeGitFileDirtyHL", { link = "NvimTreeGitFolderDirtyHL" })
	hl("NvimTreeGitFileNewHL", { fg = colors.gre1 })
	hl("AlphaHeader", { fg = colors.miku })

	hl("HeirlineA", { fg = colors.blu0 })
	hl("HeirlineB", { fg = colors.pur0 })

	hl("IndentLine", { link = "Whitespace" })
	hl("IndentLineCurrent", { link = "Whitespace" })

	hl("DapBreakpointHighlight", { fg = colors.red0 })
	hl("DapStoppedHiglight", { fg = colors.gre1 })

	hl("NvimDapVirtualText", { link = "Comment" })
	hl("NvimDapVirtualTextChanged", { fg = colors.red0 })

	hl("YaziFloatBorder", { fg = colors.gra2, bg = colors.bg0 })

	vim.g.terminal_color_background = colors.bg0
	vim.g.terminal_color_foreground = colors.fg0
	vim.g.terminal_color_0 = colors.bg0
	vim.g.terminal_color_1 = colors.red0
	vim.g.terminal_color_2 = colors.blu0
	vim.g.terminal_color_3 = colors.ora0
	vim.g.terminal_color_4 = colors.blu0
	vim.g.terminal_color_5 = colors.pur0
	vim.g.terminal_color_6 = colors.blu0
	vim.g.terminal_color_7 = colors.fg0
	vim.g.terminal_color_8 = colors.fg0
	vim.g.terminal_color_9 = colors.red0
	vim.g.terminal_color_10 = colors.pur0
	vim.g.terminal_color_11 = colors.ora0
	vim.g.terminal_color_12 = colors.fg0
	vim.g.terminal_color_13 = colors.red0
	vim.g.terminal_color_14 = colors.yel0
	vim.g.terminal_color_15 = colors.fg0
end

m39k()
