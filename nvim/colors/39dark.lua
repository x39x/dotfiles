local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local colors = {
	miku = "#ACB5DE",
	-- base
	fg0 = "#f8f8f8",
	fg1 = "#888888",
	fg2 = "#636363",
	bg0 = "#1F1F1F",
	bg1 = "#2A2A2A",
	bg2 = "#363636",
	-- ui
	gra3 = "#444444",
	blu1 = "#6db0fc",
	blu2 = "#316bcd",
	blu3 = "#264F78",
	blu4 = "#385570",
	blu5 = "#25323E",
	gre1 = "#274B34",
	gre2 = "#32fa6d",
	gre3 = "#1B7F37",
	gre4 = "#192C20",
	gre5 = "#0FBC79",
	red1 = "#cd3131",
	red2 = "#ff2e2e",
	red3 = "#6D3136",
	red4 = "#3F1E21",
	ora1 = "#FF9800",
	ora2 = "#d68349",
	-- syntax
	gra0 = "#6b737c",
	gre0 = "#94cc7f",
	red0 = "#f97583",
	blu0 = "#79b8ff",
	pur0 = "#b392f0",
	yel0 = "#FCE094",
	ora0 = "#ffab70",

	-- "#a485de",
}

local function m39k()
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	vim.o.background = "dark"
	vim.g.colors_name = "39dark"

	--NOTE: ui
	hl("Title", { fg = colors.red0 })
	hl("Directory", { fg = colors.blu0 })

	hl("Normal", { fg = colors.fg0, bg = colors.bg0 })
	hl("NormalNC", { link = "Normal" })

	hl("NormalFloat", { fg = colors.fg0, bg = colors.bg1 })
	hl("FloatBorder", { fg = colors.fg1, bg = colors.bg1 })
	hl("FloatShadow", { fg = colors.fg1, bg = colors.bg0 })
	hl("FloatShadowThrough", { fg = colors.fg1, bg = colors.bg0 })
	hl("FloatTitle", { fg = colors.red0 })
	hl("FloatFooter", { fg = colors.red0 })

	hl("Pmenu", { fg = colors.fg0, bg = colors.bg1 })
	hl("PmenuBorder", { fg = colors.fg1, bg = colors.bg1 })
	hl("PmenuSel", { reverse = true })
	hl("PmenuKind", { fg = colors.blu0 })
	hl("PmenuKindSel", { reverse = true })
	hl("PmenuExtra", { fg = colors.pur0 })
	hl("PmenuExtraSel", { reverse = true })
	hl("PmenuShadow", { link = "Pmenu" })
	hl("PmenuShadowThrough", { link = "Pmenu" })
	hl("PmenuSbar", { link = "PmenuBorder" })
	hl("PmenuThumb", { link = "PmenuBorder" })
	hl("PmenuMatch", { fg = colors.fg0 })
	hl("PmenuMatchSel", { reverse = true })
	hl("ComplMatchIns", { fg = colors.fg1 })
	hl("PreInsert", { link = "ComplMatchIns" })
	hl("ComplHint", { link = "ComplMatchIns" })
	hl("ComplHintMore", { link = "ComplMatchIns" })
	hl("SnippetTabstop", { bg = colors.blu3 })
	hl("SnippetTabstopActive", { bg = colors.gre1 })
	hl("WildMenu", { link = "ComplMatchIns" })

	hl("TabLine", { fg = colors.fg1, bg = colors.bg0 })
	hl("TabLineSel", { fg = colors.blu0, bg = colors.bg0 })
	hl("TabLineFill", { link = "TabLine" })
	hl("WinBar", { fg = colors.pur0, bg = colors.bg0 })
	hl("WinBarNC", { link = "WinBar" })
	hl("StatusLine", { fg = colors.fg0, bg = colors.bg0 })
	hl("StatusLineNC", { link = "StatusLine" })
	hl("StatusLineTerm", { link = "StatusLine" })
	hl("StatusLineTermNC", { link = "StatusLine" })

	hl("MsgArea", { bg = colors.bg0, fg = colors.gra0 })
	hl("ModeMsg", { link = "MsgAred" })
	hl("MoreMsg", { link = "MsgAred" })
	hl("MsgSeparator", { bg = colors.bg0, fg = colors.fg2 })
	hl("OkMsg", { bg = colors.bg0, fg = colors.gre3 })
	hl("WarningMsg", { bg = colors.bg0, fg = colors.ora1 })
	hl("ErrorMsg", { bg = colors.bg0, fg = colors.red1 })
	hl("StdoutMsg", { link = "OkMsg" })
	hl("StderrMsg", { link = "ErrorMsg" })
	hl("Question", { fg = colors.fg0 })

	hl("WinSeparator", { fg = colors.bg2 })
	hl("SignColumn", { bg = colors.bg0 })
	hl("FoldColumn", { bg = colors.bg0 })
	hl("Folded", { bg = colors.bg1 })
	hl("ColorColumn", { link = "Folded" })
	hl("CursorColumn", { link = "Folded" })
	hl("CursorLine", { bg = colors.bg0 })
	hl("CursorLineFold", { link = "CursorLine" })
	hl("CursorLineSign", { link = "CursorLine" })
	hl("CursorLineNr", { link = "CursorLine" })
	hl("LineNr", { bg = colors.bg0, fg = colors.fg2 })
	hl("LineNrAbove", { link = "LineNr" })
	hl("LineNrBelow", { link = "LineNr" })

	hl("Visual", { bg = colors.blu3 })
	hl("VisualNOS", { link = "Visual" })
	hl("MatchParen", { link = "Visual" })
	hl("Search", { link = "Visual" })
	hl("IncSearch", { link = "Visual" })
	hl("CurSearch", { bg = colors.gre1 })
	hl("Substitute", { bg = colors.gre1 })

	hl("Whitespace", { fg = colors.bg1 })
	hl("Conceal", { fg = colors.bg1 })
	hl("EndOfBuffer", { fg = colors.bg1 })
	hl("SpecialKey", { fg = colors.pur0 })
	hl("NonText", { fg = colors.pur0 })

	hl("SpellBad", { undercurl = true, sp = colors.red1 })
	hl("SpellCap", { undercurl = true, sp = colors.gre3 })
	hl("SpellLocal", { undercurl = true, sp = colors.gre3 })
	hl("SpellRare", { undercurl = true, sp = colors.ora1 })

	--NOTE: diff
	hl("DiffAdd", { bg = colors.gre4 })
	hl("DiffDelete", { bg = colors.red4, fg = colors.gra3 })
	hl("DiffChange", { bg = colors.blu5 })
	hl("DiffText", { bg = colors.blu4, fg = colors.gre2 })
	hl("DiffTextAdd", { link = "DiffText" })
	hl("@diff.plus", { link = "DiffAdd" })
	hl("@diff.minus", { link = "DiffDelete" })
	hl("@diff.delta", { link = "DiffChange" })
	hl("Added", { fg = colors.gre3 })
	hl("Removed", { fg = colors.red1 })
	hl("Changed", { fg = colors.ora2 })
	hl("diffAdded", { link = "Added" })
	hl("diffRemoved", { link = "Removed" })
	hl("diffChanged", { link = "Changed" })
	hl("GitSignsAdd", { link = "Added" })
	hl("GitSignsDelete", { link = "Removed" })
	hl("GitSignsChange", { link = "Changed" })
	hl("CodeDiffCharInsert", { bg = colors.gre1 })
	hl("CodeDiffCharDelete", { bg = colors.red3 })
	hl("CodeDiffFiller", { fg = colors.gra3 })

	--NOTE: quickfix
	hl("QuickFixLine", { fg = colors.blu0 })
	hl("QuickFixError", { fg = colors.red1 })
	hl("qfSeparator", { fg = colors.gra3 })
	hl("qfSeparator1", { link = "qfSeparator" })
	hl("qfSeparator2", { link = "qfSeparator" })
	hl("qfLineNr", { link = "Function" })
	hl("qfFileName", { link = "Function" })

	--NOTE: lsp
	hl("LspReferenceText", { bg = colors.gre1 })
	hl("LspReferenceRead", { bg = colors.gre1 })
	hl("LspReferenceWrite", { bg = colors.gre1 })
	hl("LspReferenceTarget", { bg = colors.gre1 })
	hl("LspInlayHint", { bg = colors.fg1, italic = true })
	hl("LspCodeLens", { bg = colors.fg1 })
	hl("LspCodeLensSeparator", { fg = colors.fg0 })
	hl("LspSignatureActiveParameter", { bg = colors.gre1, bold = true })
	-- Diagnostics (LSP)
	hl("DiagnosticError", { fg = colors.red1 })
	hl("DiagnosticWarn", { fg = colors.ora1 })
	hl("DiagnosticInfo", { fg = colors.blu2 })
	hl("DiagnosticHint", { fg = colors.pur0 })
	hl("DiagnosticOk", { fg = colors.gre5 })

	hl("DiagnosticSignError", { fg = colors.red1 })
	hl("DiagnosticSignWarn", { fg = colors.ora1 })
	hl("DiagnosticSignInfo", { fg = colors.blu2 })
	hl("DiagnosticSignHint", { fg = colors.pur0 })
	hl("DiagnosticSignOk", { fg = colors.gre5 })

	hl("DiagnosticFloatingError", { fg = colors.red1 })
	hl("DiagnosticFloatingWarn", { fg = colors.ora1 })
	hl("DiagnosticFloatingInfo", { fg = colors.blu2 })
	hl("DiagnosticFloatingHint", { fg = colors.pur0 })
	hl("DiagnosticFloatingOk", { fg = colors.gre5 })

	hl("DiagnosticUnderlineError", { sp = colors.red1, undercurl = true })
	hl("DiagnosticUnderlineWarn", { sp = colors.ora1, undercurl = true })
	hl("DiagnosticUnderlineInfo", { sp = colors.blu2, undercurl = true })
	hl("DiagnosticUnderlineHint", { sp = colors.pur0, undercurl = true })
	hl("DiagnosticUnderlineOk", { sp = colors.gre5, undercurl = true })

	hl("DiagnosticVirtualTextError", { fg = colors.red1, italic = true })
	hl("DiagnosticVirtualTextWarn", { fg = colors.ora1, italic = true })
	hl("DiagnosticVirtualTextInfo", { fg = colors.blu2, italic = true })
	hl("DiagnosticVirtualTextHint", { fg = colors.pur0, italic = true })
	hl("DiagnosticVirtualTextOk", { fg = colors.gre5, italic = true })

	hl("DiagnosticVirtualLinesError", { sp = colors.red1, undercurl = true })
	hl("DiagnosticVirtualLinesWarn", { sp = colors.ora1, undercurl = true })
	hl("DiagnosticVirtualLinesInfo", { sp = colors.blu2, undercurl = true })
	hl("DiagnosticVirtualLinesHint", { sp = colors.pur0, undercurl = true })
	hl("DiagnosticVirtualLinesOk", { sp = colors.gre5, undercurl = true })

	hl("DiagnosticDeprecated", { fg = colors.fg1 })
	hl("DiagnosticUnnecessary", { fg = colors.fg1 })

	--NOTE: syntax

	--- 1white
	hl("Function", { fg = colors.fg0 })
	hl("Identifier", { link = "Function" })
	hl("Statement", { link = "Function" })
	hl("Tag", { link = "Function" })
	hl("Include", { link = "Function" })
	--- 2red
	hl("Keyword", { fg = colors.red0 })
	hl("Repeat", { fg = colors.red0 })
	hl("Label", { link = "Keyword" })
	hl("Exception", { link = "Keyword" })
	hl("PreProc", { link = "Keyword" })
	hl("Define", { link = "Keyword" })
	hl("Conditional", { link = "Keyword" })
	hl("PreCondit", { link = "Keyword" })
	--- 3blue
	hl("Type", { fg = colors.blu0 })
	hl("Typedef", { link = "Type" })
	hl("Structure", { link = "Type" })
	hl("StorageClass", { link = "Type" })
	hl("Special", { link = "Type" })
	--- 4yellow
	hl("Boolean", { fg = colors.yel0 })
	hl("Constant", { link = "Boolean" })
	hl("Macro", { link = "Boolean" })
	hl("SpecialChar", { link = "Boolean" })
	hl("Debug", { link = "Boolean" })
	--- 5purple
	-- hl("Conditional", { fg = colors.pur0 })
	-- hl("PreCondit", { link = "Conditional" })
	--- 6orange
	hl("Number", { fg = colors.ora0 })
	hl("Float", { link = "Number" })
	--- comment
	hl("Comment", { fg = colors.gra0 })
	hl("SpecialComment", { fg = colors.blu0 })
	--- string
	hl("String", { fg = colors.gre0 })
	hl("Character", { link = "String" })
	--- operator delimiter
	hl("Delimiter", { fg = colors.fg1 })
	hl("Operator", { fg = colors.blu0 })
	--- other
	hl("Underlined", { underline = true })
	hl("Ignore", { link = "Normal" })
	hl("Error", { sp = colors.red1, undercurl = true })

	--NOTE: treesitter

	--- 1white
	hl("@function", { link = "Function" })
	hl("@function.builtin", { link = "Function" })
	hl("@variable", { link = "Function" })
	hl("@variable.builtin", { link = "Function" })
	hl("@property", { link = "Function" })
	hl("@tag", { link = "Function" })
	hl("@module", { link = "Function" })
	--- 2red
	hl("@keyword", { link = "Keyword" })
	hl("@keyword.repeat", { link = "Repeat" })
	--- 3blue
	hl("@type", { link = "Type" })
	hl("@type.builtin", { link = "Type" })
	hl("@constructor", { link = "Type" })
	hl("@tag.attribute", { link = "Type" })
	--- 4yellow
	hl("@boolean", { link = "Boolean" })
	hl("@constant", { link = "Boolean" })
	hl("@constant.builtin", { link = "Boolean" })
	hl("@label", { link = "Boolean" })
	hl("@attribute", { link = "Boolean" })
	--- 5purple
	-- hl("@keyword.conditional", { link = "Conditional" })
	--- 6orange
	hl("@number", { link = "Number" })
	--- comment
	hl("@comment", { link = "Comment" })
	hl("@comment.documentation", { fg = colors.blu0 })
	--- string
	hl("@string", { link = "String" })
	hl("@string.documentation", { fg = colors.ora0 })
	hl("@string.regexp", { fg = colors.blu0 })
	hl("@string.escape", { fg = colors.pur0 })
	hl("@string.special", { fg = colors.red0 })
	hl("@character", { link = "Character" })
	hl("@character.special", { link = "@string.special" })
	hl("@character.printf", { link = "@string.special" })
	--- operator delimiter
	hl("@operator", { link = "Operator" })
	hl("@punctuation.delimiter", { link = "Delimiter" })
	hl("@punctuation.bracket", { link = "Delimiter" })
	hl("@punctuation.special", { link = "Type" })
	--- markdown
	hl("@markup.heading", { fg = colors.blu0 })
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
	hl("@markup.list", { fg = colors.bul0 })
	hl("@markup.quote", { fg = colors.fg1 })
	hl("@markup.math", { fg = colors.pur0 })
	hl("@markup.link", { fg = colors.fg1, underline = true })

	--NOTE: plugin

	--- indent
	hl("IndentLine", { link = "Whitespace" })
	hl("IndentLineCurrent", { link = "Whitespace" })
	---flash
	hl("FlashLabel", { fg = colors.red2, bold = true })
	hl("FlashCurrent", { link = "Function" })
	hl("FlashMatch", { link = "Function" })
	---cmp
	hl("BlinkCmpKind", { fg = colors.pur0 })
	---fzf
	hl("FzfLuaBorder", { bg = colors.bg0, fg = colors.gra3 })
	hl("FzfLuaTitle", { fg = colors.fg1 })
	hl("FzfFgPlus", { fg = colors.gre5 })
	hl("FzfBgPlus", { bg = colors.bg0 })
	---nvimtree
	hl("NvimTreeIndentMarker", { link = "Whitespace" })
	hl("NvimTreeGitFolderDirtyHL", { fg = colors.red1 })
	hl("NvimTreeGitFileDirtyHL", { link = "NvimTreeGitFolderDirtyHL" })
	hl("NvimTreeGitFileNewHL", { fg = colors.gre5 })
	---alpha
	hl("AlphaHeader", { fg = colors.miku })
	---heirline
	hl("HeirlineA", { fg = colors.blu1 })
	hl("HeirlineB", { fg = colors.pur0 })
	---dap
	hl("DapBreakpointHighlight", { fg = colors.red1 })
	hl("DapStoppedHiglight", { fg = colors.gre5 })
	---yazi
	hl("YaziFloatBorder", { fg = colors.fg2, bg = colors.bg0 })

	--NOTE: term
	vim.g.terminal_color_background = colors.bg0
	vim.g.terminal_color_foreground = colors.fg0
	vim.g.terminal_color_0 = colors.bg0
	vim.g.terminal_color_1 = colors.red0
	vim.g.terminal_color_2 = colors.gre0
	vim.g.terminal_color_3 = colors.yel0
	vim.g.terminal_color_4 = colors.blu1
	vim.g.terminal_color_5 = colors.pur0
	vim.g.terminal_color_6 = colors.blu0
	vim.g.terminal_color_7 = colors.fg0
	vim.g.terminal_color_8 = colors.fg2
	vim.g.terminal_color_9 = colors.red1
	vim.g.terminal_color_10 = colors.gre0
	vim.g.terminal_color_11 = colors.ora0
	vim.g.terminal_color_12 = colors.blu1
	vim.g.terminal_color_13 = colors.pur0
	vim.g.terminal_color_14 = colors.blu0
	vim.g.terminal_color_15 = colors.fg0
end

m39k()
