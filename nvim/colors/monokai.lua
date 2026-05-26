local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local colors = {
	-- base
	bg0 = "#272822",
	bg1 = "#33342d",
	bg2 = "#3e3f36",
	fg0 = "#f8f8f2",
	fg1 = "#c0c1b5",
	fg2 = "#919288",
	--ui
	blu1 = "#385570",
	blu2 = "#25323E",
	gre1 = "#0FBC79",
	gre2 = "#3e872f",
	gre3 = "#3D452D",
	gre4 = "#32fa6d",
	red1 = "#a1384a",
	red2 = "#532821",
	gra1 = "#57584F",
	gra2 = "#444444",
	-- syntax
	gra0 = "#6e7066",
	red0 = "#F92672",
	yel0 = "#E6DB74",
	blu0 = "#66D9EF",
	gre0 = "#A6E22E",
	pur0 = "#AE81FF",
	ora0 = "#FD971F",
}

local function m39k()
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	vim.o.background = "dark"
	vim.g.colors_name = "monokai"

	--NOTE: UI

	hl("Title", { fg = colors.red0 })
	hl("Directory", { fg = colors.blu0 })

	hl("Normal", { fg = colors.fg0, bg = colors.bg0 })
	hl("NormalNC", { link = "Normal" })

	hl("NormalFloat", { fg = colors.fg0, bg = colors.bg1 })
	hl("FloatBorder", { fg = colors.fg2, bg = colors.bg1 })
	hl("FloatShadow", { fg = colors.fg2, bg = colors.bg0 })
	hl("FloatShadowThrough", { fg = colors.fg2, bg = colors.bg0 })
	hl("FloatTitle", { fg = colors.red0 })
	hl("FloatFooter", { fg = colors.red0 })

	hl("Pmenu", { fg = colors.fg0, bg = colors.bg1 })
	hl("PmenuBorder", { fg = colors.fg2, bg = colors.bg1 })
	hl("PmenuSel", { bg = colors.fg0, fg = colors.bg0 })
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
	hl("SnippetTabstop", { bg = colors.gra1 })
	hl("SnippetTabstopActive", { bg = colors.gre2 })
	hl("WildMenu", { link = "ComplMatchIns" })

	hl("TabLine", { fg = colors.fg2, bg = colors.bg0 })
	hl("TabLineSel", { fg = colors.red0, bg = colors.bg0, bold = true })
	hl("TabLineFill", { link = "TabLine" })
	hl("WinBar", { fg = colors.pur0, bg = colors.bg0 })
	hl("WinBarNC", { link = "WinBar" })
	hl("StatusLine", { fg = colors.fg0, bg = colors.bg0 })
	hl("StatusLineNC", { link = "StatusLine" })
	hl("StatusLineTerm", { link = "StatusLine" })
	hl("StatusLineTermNC", { link = "StatusLine" })

	hl("MsgArea", { bg = colors.bg0, fg = colors.fg1 })
	hl("ModeMsg", { link = "MsgAred" })
	hl("MoreMsg", { link = "MsgAred" })
	hl("MsgSeparator", { bg = colors.bg0, fg = colors.gra1 })
	hl("OkMsg", { bg = colors.bg0, fg = colors.gre0 })
	hl("WarningMsg", { bg = colors.bg0, fg = colors.ora0 })
	hl("ErrorMsg", { bg = colors.bg0, fg = colors.red0 })
	hl("StdoutMsg", { link = "OkMsg" })
	hl("StderrMsg", { link = "ErrorMsg" })
	hl("Question", { fg = colors.fg0 })

	hl("WinSeparator", { fg = colors.gra1 })
	hl("SignColumn", { bg = colors.bg0 })
	hl("FoldColumn", { bg = colors.bg0 })
	hl("Folded", { bg = colors.gra2 })
	hl("ColorColumn", { link = "Folded" })
	hl("CursorColumn", { link = "Folded" })
	hl("CursorLine", { bg = colors.bg0 })
	hl("CursorLineFold", { link = "CursorLine" })
	hl("CursorLineSign", { link = "CursorLine" })
	hl("CursorLineNr", { link = "CursorLine" })
	hl("LineNr", { bg = colors.bg0, fg = colors.gra1 })
	hl("LineNrAbove", { link = "LineNr" })
	hl("LineNrBelow", { link = "LineNr" })

	hl("Visual", { bg = colors.gra1 })
	hl("VisualNOS", { link = "Visual" })
	hl("MatchParen", { link = "Visual" })
	hl("Search", { link = "Visual" })
	hl("IncSearch", { link = "Visual" })
	hl("CurSearch", { bg = colors.gre2 })
	hl("Substitute", { bg = colors.gre2 })

	hl("Whitespace", { fg = colors.bg2 })
	hl("Conceal", { fg = colors.bg2 })
	hl("EndOfBuffer", { fg = colors.bg2 })
	hl("SpecialKey", { fg = colors.pur0 })
	hl("NonText", { fg = colors.pur0 })

	hl("SpellBad", { undercurl = true, sp = colors.red0 })
	hl("SpellCap", { undercurl = true, sp = colors.gre0 })
	hl("SpellLocal", { undercurl = true, sp = colors.gre0 })
	hl("SpellRare", { undercurl = true, sp = colors.ora0 })

	--NOTE:  Diff
	hl("DiffAdd", { bg = colors.gre3 })
	hl("DiffDelete", { bg = colors.red2, fg = colors.gra1 })
	hl("DiffChange", { bg = colors.blu2 })
	hl("DiffText", { bg = colors.blu1, fg = colors.gre4 })
	hl("DiffTextAdd", { link = "DiffText" })
	hl("@diff.plus", { link = "DiffAdd" })
	hl("@diff.minus", { link = "DiffDelete" })
	hl("@diff.delta", { link = "DiffChange" })
	hl("Added", { fg = colors.gre0 })
	hl("Removed", { fg = colors.red0 })
	hl("Changed", { fg = colors.ora0 })
	hl("diffAdded", { link = "Added" })
	hl("diffRemoved", { link = "Removed" })
	hl("diffChanged", { link = "Changed" })
	hl("GitSignsAdd", { link = "diffAdded" })
	hl("GitSignsChange", { link = "diffChanged" })
	hl("GitSignsDelete", { link = "diffRemoved" })
	hl("CodeDiffCharInsert", { bg = colors.gre2 })
	hl("CodeDiffCharDelete", { bg = colors.red1 })
	hl("CodeDiffFiller", { fg = colors.gra2 })

	--NOTE: quickfix
	hl("QuickFixLine", { fg = colors.blu0 })
	hl("QuickFixError", { fg = colors.red0 })
	hl("qfSeparator", { fg = colors.gra2 })
	hl("qfSeparator1", { link = "qfSeparator" })
	hl("qfSeparator2", { link = "qfSeparator" })
	hl("qfLineNr", { fg = colors.fg0 })
	hl("qfFileName", { fg = colors.fg0 })

	--NOTE: lsp
	hl("LspReferenceText", { bg = colors.gre2 })
	hl("LspReferenceRead", { bg = colors.gre2 })
	hl("LspReferenceWrite", { bg = colors.gre2 })
	hl("LspReferenceTarget", { bg = colors.gre2 })
	hl("LspInlayHint", { bg = colors.fg2, italic = true })
	hl("LspCodeLens", { bg = colors.fg2 })
	hl("LspCodeLensSeparator", { fg = colors.fg0 })
	hl("LspSignatureActiveParameter", { bg = colors.gre2, bold = true })
	-- Diagnostics (LSP)
	hl("DiagnosticError", { fg = colors.red0 })
	hl("DiagnosticWarn", { fg = colors.ora0 })
	hl("DiagnosticInfo", { fg = colors.blu0 })
	hl("DiagnosticHint", { fg = colors.pur0 })
	hl("DiagnosticOk", { fg = colors.gre0 })

	hl("DiagnosticSignError", { fg = colors.red0 })
	hl("DiagnosticSignWarn", { fg = colors.ora0 })
	hl("DiagnosticSignInfo", { fg = colors.blu0 })
	hl("DiagnosticSignHint", { fg = colors.pur0 })
	hl("DiagnosticSignOk", { fg = colors.gre0 })

	hl("DiagnosticFloatingError", { fg = colors.red0 })
	hl("DiagnosticFloatingWarn", { fg = colors.ora0 })
	hl("DiagnosticFloatingInfo", { fg = colors.blu0 })
	hl("DiagnosticFloatingHint", { fg = colors.pur0 })
	hl("DiagnosticFloatingOk", { fg = colors.gre0 })

	hl("DiagnosticUnderlineError", { sp = colors.red0, undercurl = true })
	hl("DiagnosticUnderlineWarn", { sp = colors.ora0, undercurl = true })
	hl("DiagnosticUnderlineInfo", { sp = colors.blu0, undercurl = true })
	hl("DiagnosticUnderlineHint", { sp = colors.pur0, undercurl = true })
	hl("DiagnosticUnderlineOk", { sp = colors.gre0, undercurl = true })

	hl("DiagnosticVirtualTextError", { fg = colors.red0, italic = true })
	hl("DiagnosticVirtualTextWarn", { fg = colors.ora0, italic = true })
	hl("DiagnosticVirtualTextInfo", { fg = colors.blu0, italic = true })
	hl("DiagnosticVirtualTextHint", { fg = colors.pur0, italic = true })
	hl("DiagnosticVirtualTextOk", { fg = colors.gre0, italic = true })

	hl("DiagnosticVirtualLinesError", { sp = colors.red0, undercurl = true })
	hl("DiagnosticVirtualLinesWarn", { sp = colors.ora0, undercurl = true })
	hl("DiagnosticVirtualLinesInfo", { sp = colors.blu0, undercurl = true })
	hl("DiagnosticVirtualLinesHint", { sp = colors.pur0, undercurl = true })
	hl("DiagnosticVirtualLinesOk", { sp = colors.gre0, undercurl = true })

	hl("DiagnosticDeprecated", { fg = colors.fg2 })
	hl("DiagnosticUnnecessary", { fg = colors.fg2 })

	--NOTE: Syntax

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
	hl("Debug", { link = "Boolean" })
	--- 5purple
	hl("Number", { fg = colors.pur0 })
	hl("Float", { link = "Number" })
	--- comment
	hl("Comment", { fg = colors.gra0 })
	hl("SpecialComment", { fg = colors.ora0 })
	--- string
	hl("String", { fg = colors.gre0 })
	hl("Character", { link = "String" })
	hl("SpecialChar", { fg = colors.red0 })
	--- operator delimiter
	hl("Delimiter", { fg = colors.fg1 })
	hl("Operator", { fg = colors.blu0 })
	--- other
	hl("Underlined", { underline = true })
	hl("Ignore", { link = "Normal" })
	hl("Error", { sp = colors.red0, undercurl = true })

	--NOTE: Treesitter

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
	hl("@keyword.conditional", { link = "Conditional" })
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
	hl("@number", { link = "Number" })
	--- comment
	hl("@comment", { link = "Comment" })
	hl("@comment.documentation", { link = "SpecialComment" })
	--- string
	hl("@string", { link = "String" })
	hl("@string.documentation", { fg = colors.ora0 })
	hl("@string.regexp", { fg = colors.blu0 })
	hl("@string.escape", { fg = colors.pur0 })
	hl("@string.special", { link = "SpecialChar" })
	hl("@character", { link = "Character" })
	hl("@character.special", { link = "SpecialChar" })
	hl("@character.printf", { link = "SpecialChar" })
	--- operator delimiter
	hl("@operator", { link = "Operator" })
	hl("@punctuation.delimiter", { link = "Delimiter" })
	hl("@punctuation.bracket", { link = "Delimiter" })
	hl("@punctuation.special", { link = "Type" })
	--- markdown
	hl("@markup.heading", { fg = colors.blu0 })
	hl("@markup.heading.1", { fg = colors.red0 })
	hl("@markup.heading.2", { fg = colors.pur0 })
	hl("@markup.heading.3", { fg = colors.yel0 })
	hl("@markup.heading.4", { link = "@markup.heading" })
	hl("@markup.heading.5", { link = "@markup.heading" })
	hl("@markup.heading.6", { link = "@markup.heading" })
	hl("@markup.strong", { bold = true })
	hl("@markup.italic", { italic = true })
	hl("@markup.strikethrough", { strikethrough = true })
	hl("@markup.underline", { underline = true })
	hl("@markup.list", { fg = colors.bul0 })
	hl("@markup.quote", { fg = colors.fg2 })
	hl("@markup.math", { fg = colors.pur0 })
	hl("@markup.link", { fg = colors.fg2, underline = true })
	hl("@markup.raw", { fg = colors.gre0 })
	hl("@variable.parameter.vimdoc", { fg = colors.gre0 })

	--NOTE: custom
	hl("@keyword.directive", { link = "Number" }) -- define ifdef in c

	--NOTE: plug

	--- indent
	hl("IndentLine", { link = "Whitespace" })
	hl("IndentLineCurrent", { link = "Whitespace" })
	---flash
	hl("FlashLabel", { fg = colors.gre4, bold = true })
	hl("FlashCurrent", { link = "Function" })
	hl("FlashMatch", { link = "Function" })
	---cmp
	hl("BlinkCmpKind", { fg = colors.pur0 })
	---fzf
	hl("FzfLuaBorder", { bg = colors.bg0, fg = colors.gra2 })
	hl("FzfLuaTitle", { fg = colors.fg1 })
	hl("FzfFgPlus", { fg = colors.gre1 })
	hl("FzfBgPlus", { bg = colors.bg0 })
	---nvimtree
	hl("NvimTreeIndentMarker", { link = "Whitespace" })
	hl("NvimTreeGitFolderDirtyHL", { fg = colors.red0 })
	hl("NvimTreeGitFileDirtyHL", { link = "NvimTreeGitFolderDirtyHL" })
	hl("NvimTreeGitFileNewHL", { fg = colors.gre1 })
	---alpha
	hl("AlphaHeader", { fg = colors.red0 })
	---heirline
	hl("HeirlineA", { fg = colors.blu0 })
	hl("HeirlineB", { fg = colors.pur0 })
	---dap
	hl("DapBreakpointHighlight", { fg = colors.red0 })
	hl("DapStoppedHiglight", { fg = colors.gre1 })
	hl("NvimDapViewWatchUpdated", { fg = colors.red0 })
	---yazi
	hl("YaziFloatBorder", { fg = colors.fg2, bg = colors.bg0 })

	--NOTE: term
	vim.g.terminal_color_background = colors.bg0
	vim.g.terminal_color_foreground = colors.fg0
	vim.g.terminal_color_0 = colors.bg0
	vim.g.terminal_color_1 = colors.red0
	vim.g.terminal_color_2 = colors.gre0
	vim.g.terminal_color_3 = colors.yel0
	vim.g.terminal_color_4 = colors.blu0
	vim.g.terminal_color_5 = colors.pur0
	vim.g.terminal_color_6 = colors.blu0
	vim.g.terminal_color_7 = colors.fg0
	vim.g.terminal_color_8 = colors.fg2
	vim.g.terminal_color_9 = colors.red0
	vim.g.terminal_color_10 = colors.gre0
	vim.g.terminal_color_11 = colors.ora0
	vim.g.terminal_color_12 = colors.blu0
	vim.g.terminal_color_13 = colors.pur0
	vim.g.terminal_color_14 = colors.blu0
	vim.g.terminal_color_15 = colors.fg0
end

m39k()
