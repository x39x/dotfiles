local function hl(group, properties)
	vim.api.nvim_set_hl(0, group, properties)
end

local colors = {
	miku = "#1F30C8",
	-- base
	bg0 = "#FFFFFF",
	bg1 = "#F7F8FA",
	fg0 = "#080808",
	fg1 = "#636363",
	fg2 = "#AEB3C2",
	fg3 = "#D6D6D6",
	fg4 = "#EBECF0",
	-- syntax
	cya0 = "#00627A",
	bro1 = "#b99f0e",

	gre0 = "#077D18",
	gra0 = "#8C8C8C",
	blu0 = "#0133B3",
	blu1 = "#1750EB",
	pur0 = "#871094",
	bro0 = "#9E880D",
	red0 = "#D3302F",
	-- ui
	blu2 = "#E7EFFA",
	blu3 = "#E3EBFE",
	blu4 = "#B4D7FF",
	blu5 = "#A7C5FF",
	blu6 = "#0A69DA",
	gre1 = "#E9F5E6",
	gre2 = "#BEE6BE",
	gre3 = "#8EC39D",
	gre4 = "#6DB083",
	gre5 = "#10B981",
	red1 = "#FFE5E5",
	red2 = "#FFC4C5",
	red3 = "#de0202",
	ora0 = "#b86114",
	yel0 = "#F2BF56",
	bro2 = "#B28B00",

	-- "#45164F",
	-- "#662277",
	-- "#74118c",
	-- "#6B2FBA",
	-- "#DB3B4B",
	-- "#805900",
	-- "#8c6c41",
	-- "#e6bc05",
	-- "#F7E6A0",
}

local function m39k()
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	vim.o.background = "light"
	vim.g.colors_name = "39light"

	-- NOTE:  UI  https://neovim.io/doc/user/syntax/#highlight-groups

	hl("Title", { fg = colors.blu1 })
	hl("Directory", { fg = colors.blu0 })

	hl("Normal", { fg = colors.fg0, bg = colors.bg0 })
	hl("NormalNC", { link = "Normal" })

	hl("NormalFloat", { fg = colors.fg0, bg = colors.bg1 })
	hl("FloatBorder", { fg = colors.fg3, bg = colors.bg1 })
	hl("FloatShadow", { fg = colors.fg3, bg = colors.bg0 })
	hl("FloatShadowThrough", { fg = colors.fg2, bg = colors.bg0 })
	hl("FloatTitle", { fg = colors.red0 })
	hl("FloatFooter", { fg = colors.red0 })

	hl("Pmenu", { fg = colors.fg0, bg = colors.bg1 })
	hl("PmenuBorder", { fg = colors.fg3, bg = colors.bg1 })
	hl("PmenuSel", { bg = colors.blu3 })
	hl("PmenuKind", { fg = colors.blu0 })
	hl("PmenuKindSel", { link = "PmenuSel" })
	hl("PmenuExtra", { fg = colors.pur0 })
	hl("PmenuExtraSel", { link = "PmenuSel" })
	hl("PmenuShadow", { link = "Pmenu" })
	hl("PmenuShadowThrough", { link = "Pmenu" })
	hl("PmenuSbar", { link = "PmenuBorder" })
	hl("PmenuThumb", { link = "PmenuBorder" })
	hl("PmenuMatch", { fg = colors.fg0 })
	hl("PmenuMatchSel", { link = "PmenuSel" })
	hl("ComplMatchIns", { fg = colors.fg2 })
	hl("PreInsert", { link = "ComplMatchIns" })
	hl("ComplHint", { link = "ComplMatchIns" })
	hl("ComplHintMore", { link = "ComplMatchIns" })
	hl("SnippetTabstop", { bg = colors.blu4 })
	hl("SnippetTabstopActive", { bg = colors.gre2 })
	hl("WildMenu", { link = "ComplMatchIns" })

	hl("TabLine", { fg = colors.fg1, bg = colors.bg1 })
	hl("TabLineSel", { fg = colors.blu1, bg = colors.bg1 })
	hl("TabLineFill", { link = "TabLine" })
	hl("WinBar", { fg = colors.pur0, bg = colors.bg0 })
	hl("WinBarNC", { link = "WinBar" })
	hl("StatusLine", { fg = colors.blu0, bg = colors.bg0 })
	hl("StatusLineNC", { link = "StatusLine" })
	hl("StatusLineTerm", { link = "StatusLine" })
	hl("StatusLineTermNC", { link = "StatusLine" })

	hl("MsgArea", { bg = colors.bg0, fg = colors.fg1 })
	hl("ModeMsg", { link = "MsgAred" })
	hl("MoreMsg", { link = "MsgAred" })
	hl("MsgSeparator", { bg = colors.bg0, fg = colors.fg2 })
	hl("OkMsg", { bg = colors.bg0, fg = colors.gre5 })
	hl("WarningMsg", { bg = colors.bg0, fg = colors.bro1 })
	hl("ErrorMsg", { bg = colors.bg0, fg = colors.red0 })
	hl("StdoutMsg", { link = "OkMsg" })
	hl("StderrMsg", { link = "ErrorMsg" })
	hl("Question", { fg = colors.fg0 })

	hl("WinSeparator", { fg = colors.fg3 })
	hl("SignColumn", { bg = colors.bg0 })
	hl("FoldColumn", { bg = colors.bg0 })
	hl("Folded", { bg = colors.gre1 })
	hl("ColorColumn", { link = "Folded" })
	hl("CursorColumn", { link = "Folded" })
	hl("CursorLine", { bg = colors.bg1 })
	hl("CursorLineFold", { link = "CursorLine" })
	hl("CursorLineSign", { link = "CursorLine" })
	hl("CursorLineNr", { link = "CursorLine" })
	hl("LineNr", { bg = colors.bg0, fg = colors.fg2 })
	hl("LineNrAbove", { link = "LineNr" })
	hl("LineNrBelow", { link = "LineNr" })

	hl("Visual", { bg = colors.blu4 })
	hl("VisualNOS", { link = "Visual" })
	hl("MatchParen", { link = "Visual" })
	hl("Search", { link = "Visual" })
	hl("IncSearch", { link = "Visual" })
	hl("CurSearch", { bg = colors.gre2 })
	hl("Substitute", { bg = colors.gre2 })

	hl("Whitespace", { fg = colors.fg4 })
	hl("Conceal", { fg = colors.fg4 })
	hl("EndOfBuffer", { fg = colors.fg4 })
	hl("SpecialKey", { fg = colors.pur0 })
	hl("NonText", { fg = colors.pur0 })

	hl("SpellBad", { undercurl = true, sp = colors.red0 })
	hl("SpellCap", { undercurl = true, sp = colors.gre5 })
	hl("SpellLocal", { undercurl = true, sp = colors.gre5 })
	hl("SpellRare", { undercurl = true, sp = colors.bro1 })

	--NOTE: DIFF
	hl("DiffAdd", { bg = colors.gre2 })
	hl("DiffDelete", { bg = colors.red1, fg = colors.fg2 })
	hl("DiffChange", { bg = colors.blu3 })
	hl("DiffText", { bg = colors.blu5, fg = colors.red3 })
	hl("DiffTextAdd", { link = "DiffText" })
	hl("@diff.plus", { link = "DiffAdd" })
	hl("@diff.minus", { link = "DiffDelete" })
	hl("@diff.delta", { link = "DiffChange" })
	hl("Added", { fg = colors.gre4 })
	hl("Removed", { fg = colors.red3 })
	hl("Changed", { fg = colors.bro2 })
	hl("diffAdded", { link = "Added" })
	hl("diffRemoved", { link = "Changed" })
	hl("diffChanged", { link = "Removed" })
	hl("GitSignsAdd", { link = "Added" })
	hl("GitSignsChange", { link = "Changed" })
	hl("GitSignsDelete", { link = "Removed" })
	hl("CodeDiffCharInsert", { bg = colors.gre3 })
	hl("CodeDiffCharDelete", { bg = colors.red2 })
	hl("CodeDiffFiller", { fg = colors.fg3 })

	--NOTE: quickfix
	hl("QuickFixLine", { fg = colors.blu1 })
	hl("QuickFixError", { fg = colors.red0 })
	hl("qfSeparator", { fg = colors.fg3 })
	hl("qfSeparator1", { link = "qfSeparator" })
	hl("qfSeparator2", { link = "qfSeparator" })
	--TODO: fg0
	hl("qfLineNr", { link = "Function" })
	hl("qfFileName", { link = "Function" })

	--NOTE: lsp
	hl("LspReferenceText", { bg = colors.gre4 })
	hl("LspReferenceRead", { bg = colors.gre4 })
	hl("LspReferenceWrite", { bg = colors.gre4 })
	hl("LspReferenceTarget", { bg = colors.gre4 })
	hl("LspInlayHint", { bg = colors.fg2, italic = true })
	hl("LspCodeLens", { bg = colors.fg2 })
	hl("LspCodeLensSeparator", { fg = colors.fg0 })
	hl("LspSignatureActiveParameter", { bg = colors.gre2, bold = true })
	-- Diagnostics (LSP)
	hl("DiagnosticError", { fg = colors.red0 })
	hl("DiagnosticWarn", { fg = colors.ora0 })
	hl("DiagnosticInfo", { fg = colors.blu6 })
	hl("DiagnosticHint", { fg = colors.pur0 })
	hl("DiagnosticOk", { fg = colors.gre5 })

	hl("DiagnosticSignError", { fg = colors.red0 })
	hl("DiagnosticSignWarn", { fg = colors.ora0 })
	hl("DiagnosticSignInfo", { fg = colors.blu6 })
	hl("DiagnosticSignHint", { fg = colors.pur0 })
	hl("DiagnosticSignOk", { fg = colors.gre5 })

	hl("DiagnosticFloatingError", { fg = colors.red0 })
	hl("DiagnosticFloatingWarn", { fg = colors.ora0 })
	hl("DiagnosticFloatingInfo", { fg = colors.blu6 })
	hl("DiagnosticFloatingHint", { fg = colors.pur0 })
	hl("DiagnosticFloatingOk", { fg = colors.gre5 })

	hl("DiagnosticUnderlineError", { sp = colors.red0, undercurl = true })
	hl("DiagnosticUnderlineWarn", { sp = colors.bro1, undercurl = true })
	hl("DiagnosticUnderlineInfo", { sp = colors.blu6, undercurl = true })
	hl("DiagnosticUnderlineHint", { sp = colors.pur0, undercurl = true })
	hl("DiagnosticUnderlineOk", { sp = colors.gre5, undercurl = true })

	hl("DiagnosticVirtualTextError", { sp = colors.red0, undercurl = true })
	hl("DiagnosticVirtualTextWarn", { sp = colors.bro1, undercurl = true })
	hl("DiagnosticVirtualTextInfo", { sp = colors.blu6, undercurl = true })
	hl("DiagnosticVirtualTextHint", { sp = colors.pur0, undercurl = true })
	hl("DiagnosticVirtualTextOk", { sp = colors.gre5, undercurl = true })

	hl("DiagnosticVirtualLinesError", { sp = colors.red0, undercurl = true })
	hl("DiagnosticVirtualLinesWarn", { sp = colors.bro1, undercurl = true })
	hl("DiagnosticVirtualLinesInfo", { sp = colors.blu6, undercurl = true })
	hl("DiagnosticVirtualLinesHint", { sp = colors.pur0, undercurl = true })
	hl("DiagnosticVirtualLinesOk", { sp = colors.gre5, undercurl = true })

	hl("DiagnosticDeprecated", { fg = colors.fg2 })
	hl("DiagnosticUnnecessary", { fg = colors.fg2 })

	-- NOTE: Syntax  https://neovim.io/doc/user/syntax/#group-name

	--- 1white
	hl("Function", { fg = colors.fg0 })
	hl("Identifier", { link = "Function" })
	hl("Statement", { link = "Function" })
	hl("Tag", { link = "Function" })
	hl("Include", { link = "Function" })
	--- 2blue
	hl("Keyword", { fg = colors.blu0 })
	hl("Repeat", { fg = colors.blu0 })
	hl("Exception", { link = "Keyword" })
	hl("PreProc", { link = "Keyword" })
	hl("Define", { link = "Keyword" })
	hl("Conditional", { link = "Keyword" })
	hl("PreCondit", { link = "Keyword" })
	--- 3purple
	hl("Type", { fg = colors.pur0 })
	hl("Typedef", { link = "Type" })
	hl("Structure", { link = "Type" })
	hl("StorageClass", { link = "Type" })
	hl("Special", { link = "Type" })
	--- 4brown
	hl("Boolean", { fg = colors.bro0 })
	hl("Macro", { link = "Boolean" })
	hl("SpecialChar", { link = "Boolean" })
	hl("Debug", { link = "Boolean" })
	--- 5red
	hl("Constant", { fg = colors.red0 })
	hl("Label", { fg = colors.red0 })
	--- 6blue
	-- hl("Statement", { fg = colors.blue4 })
	hl("Number", { fg = colors.blu1 })
	hl("Float", { link = "Number" })
	--- comment
	hl("Comment", { fg = colors.gra0 })
	hl("SpecialComment", { fg = colors.cya0 })
	--- string
	hl("String", { fg = colors.gre0 })
	hl("Character", { link = "String" })
	--- delimiter
	hl("Delimiter", { fg = colors.cya0 })
	hl("Operator", { fg = colors.pur0 })
	--- other
	hl("Underlined", { underline = true })
	hl("Ignore", { link = "Normal" })
	hl("Error", { sp = colors.red1, undercurl = true })

	--NOTE: Treesitter  https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
	--- 1white
	hl("@function", { link = "Function" })
	hl("@function.builtin", { link = "Function" })
	hl("@variable", { link = "Function" })
	hl("@variable.builtin", { link = "Function" })
	hl("@property", { link = "Function" })
	hl("@tag", { link = "Function" })
	hl("@module", { link = "Function" })
	--- 2blue
	hl("@keyword", { link = "Keyword" })
	hl("@keyword.repeat", { link = "Repeat" })
	--- 3purple
	hl("@type", { link = "Type" })
	hl("@type.builtin", { link = "Type" })
	hl("@constructor", { link = "Type" })
	hl("@tag.attribute", { link = "Type" })
	--- 4brown
	hl("@boolean", { link = "Boolean" })
	hl("@constant.builtin", { link = "Boolean" })
	hl("@attribute", { link = "Boolean" })
	--- 5red
	hl("@label", { link = "Constant" })
	hl("@constant", { link = "Constant" })
	--- 6blue
	hl("@number", { link = "Number" })
	--- comment
	hl("@comment", { link = "Comment" })
	hl("@comment.documentation", { fg = colors.bro1 })
	--- operator delimiter
	hl("@operator", { link = "Operator" })
	hl("@punctuation.delimiter", { link = "Delimiter" })
	hl("@punctuation.bracket", { link = "Delimiter" })
	hl("@punctuation.special", { link = "Type" })
	--- markdown
	hl("@markup.heading", { fg = colors.blu1 })
	hl("@markup.heading.1", { fg = colors.red0 })
	hl("@markup.heading.2", { fg = colors.pur0 })
	hl("@markup.heading.3", { link = "@markup.heading" })
	hl("@markup.heading.4", { link = "@markup.heading" })
	hl("@markup.heading.5", { link = "@markup.heading" })
	hl("@markup.heading.6", { link = "@markup.heading" })
	hl("@markup.strong", { bold = true })
	hl("@markup.italic", { italic = true })
	hl("@markup.strikethrough", { strikethrough = true })
	hl("@markup.underline", { underline = true })
	hl("@markup.list", { fg = colors.bule4 })
	hl("@markup.quote", { fg = colors.fg1 })
	hl("@markup.math", { fg = colors.pur0 })
	hl("@markup.link", { fg = colors.fg1, underline = true })

	--NOTE: plugin

	--- indent
	hl("IndentLine", { link = "Whitespace" })
	hl("IndentLineCurrent", { link = "Whitespace" })
	---flash
	hl("FlashLabel", { fg = colors.red3, bold = true })
	hl("FlashCurrent", { link = "Function" })
	hl("FlashMatch", { link = "Function" })
	---cmp
	hl("BlinkCmpKind", { fg = colors.pur0 })
	---fzf
	hl("FzfLuaBorder", { bg = colors.bg, fg = colors.fg3 })
	hl("FzfLuaTitle", { fg = colors.fg1 })
	hl("FzfFgPlus", { fg = colors.gre5 })
	hl("FzfBgPlus", { bg = colors.blu2 })
	---nvimtree
	hl("NvimTreeIndentMarker", { link = "Whitespace" })
	hl("NvimTreeGitFolderDirtyHL", { fg = colors.red0 })
	hl("NvimTreeGitFileDirtyHL", { link = "NvimTreeGitFolderDirtyHL" })
	hl("NvimTreeGitFileNewHL", { fg = colors.gre5 })
	---alpha
	hl("AlphaHeader", { fg = colors.miku })
	---heirline
	hl("HeirlineA", { fg = colors.blu0 })
	hl("HeirlineB", { fg = colors.pur0 })
	---dap
	hl("DapBreakpointHighlight", { fg = colors.red0 })
	hl("DapStoppedHiglight", { fg = colors.gre5 })
	---yazi
	hl("YaziFloatBorder", { fg = colors.fg3, bg = colors.bg0 })

	vim.g.terminal_color_background = colors.bg0
	vim.g.terminal_color_foreground = colors.fg0

	vim.g.terminal_color_0 = colors.fg0
	vim.g.terminal_color_1 = colors.red0
	vim.g.terminal_color_2 = colors.gre5
	vim.g.terminal_color_3 = colors.yel0
	vim.g.terminal_color_4 = colors.blu0
	vim.g.terminal_color_5 = colors.pur0
	vim.g.terminal_color_6 = colors.cya0
	vim.g.terminal_color_7 = colors.bg0

	vim.g.terminal_color_8 = colors.fg1
	vim.g.terminal_color_9 = colors.red0
	vim.g.terminal_color_10 = colors.gre5
	vim.g.terminal_color_11 = colors.yel0
	vim.g.terminal_color_12 = colors.blu1
	vim.g.terminal_color_13 = colors.pur0
	vim.g.terminal_color_14 = colors.cya0
	vim.g.terminal_color_15 = colors.fg4
end

m39k()
