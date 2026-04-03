-- Dark Pastel colorscheme for Neovim
-- Matches the Kitty terminal dark-pastel theme
-- Palette based on the classic 0x55 high-saturation pastel pattern

local M = {}

-- ┌──────────────────────────────────────────┐
-- │             Palette                       │
-- └──────────────────────────────────────────┘

local c = {
    -- Base
    bg = "#000000",
    fg = "#ffffff",

    -- Terminal 16 colors (normal = bright in this scheme)
    black = "#555555",
    red = "#ff5555",
    green = "#55ff55",
    yellow = "#ffff55",
    blue = "#5555ff",
    magenta = "#ff55ff",
    cyan = "#55ffff",
    white = "#bbbbbb",

    -- Extended palette (derived for UI depth)
    bg_01 = "#0a0a0a",    -- very slightly lighter bg
    bg_02 = "#111111",    -- subtle bg for floats/popups
    bg_03 = "#1a1a1a",    -- cursorline, visual selection bg
    bg_04 = "#222222",    -- statusline, tabline bg
    bg_05 = "#333333",    -- borders, separators
    bg_06 = "#444444",    -- inactive UI elements

    fg_dim = "#888888",   -- comments, line numbers
    fg_muted = "#aaaaaa", -- less prominent text

    -- Accent variants (slightly dimmed for less aggressive highlights)
    red_dim = "#cc4444",
    green_dim = "#44cc44",
    yellow_dim = "#cccc44",
    blue_dim = "#4444cc",
    magenta_dim = "#cc44cc",
    cyan_dim = "#44cccc",

    -- Kitty tab accents
    lavender = "#7976ab",
    soft_pink = "#f2cdcd",

    -- Semantic
    error = "#ff5555",
    warn = "#ffff55",
    info = "#55ffff",
    hint = "#55ff55",
    ok = "#55ff55",

    none = "NONE",
}

-- ┌──────────────────────────────────────────┐
-- │             Helper                        │
-- └──────────────────────────────────────────┘

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ┌──────────────────────────────────────────┐
-- │             Terminal Colors                │
-- └──────────────────────────────────────────┘

vim.g.terminal_color_0 = c.black
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.magenta
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.white
vim.g.terminal_color_8 = c.black
vim.g.terminal_color_9 = c.red
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.yellow
vim.g.terminal_color_12 = c.blue
vim.g.terminal_color_13 = c.magenta
vim.g.terminal_color_14 = c.cyan
vim.g.terminal_color_15 = c.white

-- ┌──────────────────────────────────────────┐
-- │             Editor                        │
-- └──────────────────────────────────────────┘

hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = c.bg_02 })
hi("NormalNC", { fg = c.fg_muted, bg = c.bg })
hi("FloatBorder", { fg = c.bg_05, bg = c.bg_02 })
hi("FloatTitle", { fg = c.cyan, bg = c.bg_02, bold = true })
hi("Cursor", { fg = c.bg, bg = c.yellow })
hi("lCursor", { fg = c.bg, bg = c.yellow })
hi("CursorIM", { fg = c.bg, bg = c.yellow })
hi("CursorLine", { bg = c.bg_03 })
hi("CursorLineNr", { fg = c.yellow, bold = true })
hi("CursorColumn", { bg = c.bg_03 })
hi("ColorColumn", { bg = c.bg_01 })
hi("LineNr", { fg = c.bg_06 })
hi("SignColumn", { fg = c.fg, bg = c.bg })
hi("FoldColumn", { fg = c.bg_05, bg = c.bg })
hi("Folded", { fg = c.fg_dim, bg = c.bg_03 })
hi("VertSplit", { fg = c.bg_05, bg = c.bg })
hi("WinSeparator", { fg = c.bg_05, bg = c.bg })
hi("Visual", { bg = c.bg_05 })
hi("VisualNOS", { bg = c.bg_05 })
hi("Search", { fg = c.bg, bg = c.yellow })
hi("IncSearch", { fg = c.bg, bg = c.magenta })
hi("CurSearch", { fg = c.bg, bg = c.cyan })
hi("Substitute", { fg = c.bg, bg = c.red })
hi("MatchParen", { fg = c.magenta, bg = c.bg_05, bold = true })
hi("Pmenu", { fg = c.fg, bg = c.bg_02 })
hi("PmenuSel", { fg = c.bg, bg = c.blue })
hi("PmenuSbar", { bg = c.bg_04 })
hi("PmenuThumb", { bg = c.bg_06 })
hi("WildMenu", { fg = c.bg, bg = c.cyan })
hi("StatusLine", { fg = c.fg, bg = c.bg_04 })
hi("StatusLineNC", { fg = c.fg_dim, bg = c.bg_02 })
hi("WinBar", { fg = c.fg_muted, bg = c.bg })
hi("WinBarNC", { fg = c.fg_dim, bg = c.bg })
hi("TabLine", { fg = c.fg_dim, bg = c.bg_04 })
hi("TabLineFill", { bg = c.bg_02 })
hi("TabLineSel", { fg = c.cyan, bg = c.bg, bold = true })
hi("Title", { fg = c.cyan, bold = true })
hi("NonText", { fg = c.bg_05 })
hi("SpecialKey", { fg = c.bg_05 })
hi("Whitespace", { fg = c.bg_03 })
hi("EndOfBuffer", { fg = c.bg })
hi("Conceal", { fg = c.fg_dim })
hi("Directory", { fg = c.blue })
hi("Question", { fg = c.green })
hi("MoreMsg", { fg = c.green })
hi("ModeMsg", { fg = c.fg, bold = true })
hi("ErrorMsg", { fg = c.red, bold = true })
hi("WarningMsg", { fg = c.yellow })
hi("SpellBad", { sp = c.red, undercurl = true })
hi("SpellCap", { sp = c.yellow, undercurl = true })
hi("SpellLocal", { sp = c.cyan, undercurl = true })
hi("SpellRare", { sp = c.magenta, undercurl = true })
hi("QuickFixLine", { bg = c.bg_03, bold = true })

-- ┌──────────────────────────────────────────┐
-- │             Syntax (base vim groups)      │
-- └──────────────────────────────────────────┘

hi("Comment", { fg = c.fg_dim, italic = true })
hi("Constant", { fg = c.magenta })
hi("String", { fg = c.green })
hi("Character", { fg = c.green })
hi("Number", { fg = c.magenta })
hi("Boolean", { fg = c.magenta })
hi("Float", { fg = c.magenta })
hi("Identifier", { fg = c.fg })
hi("Function", { fg = c.cyan, bold = true })
hi("Statement", { fg = c.red })
hi("Conditional", { fg = c.red })
hi("Repeat", { fg = c.red })
hi("Label", { fg = c.red })
hi("Operator", { fg = c.yellow })
hi("Keyword", { fg = c.red })
hi("Exception", { fg = c.red })
hi("PreProc", { fg = c.yellow })
hi("Include", { fg = c.blue })
hi("Define", { fg = c.yellow })
hi("Macro", { fg = c.yellow })
hi("PreCondit", { fg = c.yellow })
hi("Type", { fg = c.cyan })
hi("StorageClass", { fg = c.yellow })
hi("Structure", { fg = c.cyan })
hi("Typedef", { fg = c.cyan })
hi("Special", { fg = c.yellow })
hi("SpecialChar", { fg = c.yellow })
hi("Tag", { fg = c.red })
hi("Delimiter", { fg = c.fg_muted })
hi("SpecialComment", { fg = c.lavender, italic = true })
hi("Debug", { fg = c.red })
hi("Underlined", { fg = c.blue, underline = true })
hi("Ignore", { fg = c.bg_05 })
hi("Error", { fg = c.red, bold = true })
hi("Todo", { fg = c.bg, bg = c.yellow, bold = true })
hi("Added", { fg = c.green })
hi("Changed", { fg = c.yellow })
hi("Removed", { fg = c.red })

-- ┌──────────────────────────────────────────┐
-- │             Treesitter                    │
-- └──────────────────────────────────────────┘

hi("@comment", { link = "Comment" })
hi("@comment.documentation", { fg = c.fg_dim, italic = true })
hi("@comment.error", { fg = c.red, italic = true })
hi("@comment.warning", { fg = c.yellow, italic = true })
hi("@comment.todo", { fg = c.bg, bg = c.yellow, bold = true })
hi("@comment.note", { fg = c.cyan, italic = true })

hi("@constant", { link = "Constant" })
hi("@constant.builtin", { fg = c.magenta, italic = true })
hi("@constant.macro", { fg = c.magenta })

hi("@string", { link = "String" })
hi("@string.escape", { fg = c.yellow })
hi("@string.regex", { fg = c.yellow })
hi("@string.special", { fg = c.yellow })

hi("@character", { link = "Character" })
hi("@number", { link = "Number" })
hi("@number.float", { link = "Float" })
hi("@boolean", { link = "Boolean" })

hi("@function", { fg = c.cyan, bold = true })
hi("@function.builtin", { fg = c.cyan })
hi("@function.call", { fg = c.cyan })
hi("@function.macro", { fg = c.yellow })
hi("@function.method", { fg = c.cyan })
hi("@function.method.call", { fg = c.cyan })

hi("@constructor", { fg = c.yellow })
hi("@operator", { link = "Operator" })

hi("@keyword", { fg = c.red })
hi("@keyword.coroutine", { fg = c.red, italic = true })
hi("@keyword.function", { fg = c.red })
hi("@keyword.operator", { fg = c.red })
hi("@keyword.import", { fg = c.blue })
hi("@keyword.storage", { fg = c.red })
hi("@keyword.repeat", { fg = c.red })
hi("@keyword.return", { fg = c.red })
hi("@keyword.debug", { fg = c.red })
hi("@keyword.exception", { fg = c.red })
hi("@keyword.conditional", { fg = c.red })
hi("@keyword.conditional.ternary", { fg = c.red })
hi("@keyword.directive", { fg = c.yellow })
hi("@keyword.directive.define", { fg = c.yellow })

hi("@type", { fg = c.cyan })
hi("@type.builtin", { fg = c.cyan, italic = true })
hi("@type.definition", { fg = c.cyan })
hi("@type.qualifier", { fg = c.red })

hi("@variable", { fg = c.fg })
hi("@variable.builtin", { fg = c.magenta, italic = true })
hi("@variable.parameter", { fg = c.soft_pink })
hi("@variable.member", { fg = c.fg })

hi("@property", { fg = c.fg })

hi("@module", { fg = c.lavender })
hi("@module.builtin", { fg = c.lavender, italic = true })

hi("@label", { fg = c.blue })

hi("@punctuation.bracket", { fg = c.fg_muted })
hi("@punctuation.delimiter", { fg = c.fg_muted })
hi("@punctuation.special", { fg = c.yellow })

hi("@tag", { fg = c.red })
hi("@tag.attribute", { fg = c.yellow, italic = true })
hi("@tag.delimiter", { fg = c.fg_muted })

hi("@markup.heading", { fg = c.cyan, bold = true })
hi("@markup.heading.1", { fg = c.red, bold = true })
hi("@markup.heading.2", { fg = c.yellow, bold = true })
hi("@markup.heading.3", { fg = c.green, bold = true })
hi("@markup.heading.4", { fg = c.cyan, bold = true })
hi("@markup.heading.5", { fg = c.blue, bold = true })
hi("@markup.heading.6", { fg = c.magenta, bold = true })
hi("@markup.strong", { bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.strikethrough", { strikethrough = true })
hi("@markup.underline", { underline = true })
hi("@markup.raw", { fg = c.green })
hi("@markup.raw.block", { fg = c.green })
hi("@markup.link", { fg = c.blue, underline = true })
hi("@markup.link.url", { fg = c.blue, underline = true })
hi("@markup.link.label", { fg = c.cyan })
hi("@markup.list", { fg = c.red })
hi("@markup.quote", { fg = c.fg_dim, italic = true })
hi("@markup.math", { fg = c.yellow })

-- ┌──────────────────────────────────────────┐
-- │             LSP Semantic Tokens           │
-- └──────────────────────────────────────────┘

hi("@lsp.type.class", { fg = c.cyan })
hi("@lsp.type.comment", { link = "Comment" })
hi("@lsp.type.decorator", { fg = c.yellow })
hi("@lsp.type.enum", { fg = c.cyan })
hi("@lsp.type.enumMember", { fg = c.magenta })
hi("@lsp.type.function", { fg = c.cyan, bold = true })
hi("@lsp.type.interface", { fg = c.cyan, italic = true })
hi("@lsp.type.keyword", { fg = c.red })
hi("@lsp.type.macro", { fg = c.yellow })
hi("@lsp.type.method", { fg = c.cyan })
hi("@lsp.type.namespace", { fg = c.lavender })
hi("@lsp.type.number", { link = "Number" })
hi("@lsp.type.operator", { link = "Operator" })
hi("@lsp.type.parameter", { fg = c.soft_pink })
hi("@lsp.type.property", { fg = c.fg })
hi("@lsp.type.string", { link = "String" })
hi("@lsp.type.struct", { fg = c.cyan })
hi("@lsp.type.type", { fg = c.cyan })
hi("@lsp.type.typeParameter", { fg = c.cyan, italic = true })
hi("@lsp.type.variable", { fg = c.fg })

hi("@lsp.mod.defaultLibrary", { italic = true })
hi("@lsp.mod.deprecated", { strikethrough = true })
hi("@lsp.mod.readonly", { italic = true })

-- ┌──────────────────────────────────────────┐
-- │             Diagnostics                   │
-- └──────────────────────────────────────────┘

hi("DiagnosticError", { fg = c.error })
hi("DiagnosticWarn", { fg = c.warn })
hi("DiagnosticInfo", { fg = c.info })
hi("DiagnosticHint", { fg = c.hint })
hi("DiagnosticOk", { fg = c.ok })

hi("DiagnosticVirtualTextError", { fg = c.red_dim, italic = true })
hi("DiagnosticVirtualTextWarn", { fg = c.yellow_dim, italic = true })
hi("DiagnosticVirtualTextInfo", { fg = c.cyan_dim, italic = true })
hi("DiagnosticVirtualTextHint", { fg = c.green_dim, italic = true })
hi("DiagnosticVirtualTextOk", { fg = c.green_dim, italic = true })

hi("DiagnosticUnderlineError", { sp = c.error, undercurl = true })
hi("DiagnosticUnderlineWarn", { sp = c.warn, undercurl = true })
hi("DiagnosticUnderlineInfo", { sp = c.info, undercurl = true })
hi("DiagnosticUnderlineHint", { sp = c.hint, undercurl = true })
hi("DiagnosticUnderlineOk", { sp = c.ok, undercurl = true })

hi("DiagnosticFloatingError", { fg = c.error })
hi("DiagnosticFloatingWarn", { fg = c.warn })
hi("DiagnosticFloatingInfo", { fg = c.info })
hi("DiagnosticFloatingHint", { fg = c.hint })
hi("DiagnosticFloatingOk", { fg = c.ok })

hi("DiagnosticSignError", { fg = c.error })
hi("DiagnosticSignWarn", { fg = c.warn })
hi("DiagnosticSignInfo", { fg = c.info })
hi("DiagnosticSignHint", { fg = c.hint })
hi("DiagnosticSignOk", { fg = c.ok })

-- ┌──────────────────────────────────────────┐
-- │             LSP                           │
-- └──────────────────────────────────────────┘

hi("LspReferenceText", { bg = c.bg_03 })
hi("LspReferenceRead", { bg = c.bg_03 })
hi("LspReferenceWrite", { bg = c.bg_03, bold = true })
hi("LspSignatureActiveParameter", { fg = c.yellow, bold = true })
hi("LspCodeLens", { fg = c.fg_dim })
hi("LspCodeLensSeparator", { fg = c.bg_05 })
hi("LspInlayHint", { fg = c.bg_06, italic = true })

-- ┌──────────────────────────────────────────┐
-- │             Git / Diff                    │
-- └──────────────────────────────────────────┘

hi("DiffAdd", { bg = "#0d2a0d" })
hi("DiffChange", { bg = "#2a2a0d" })
hi("DiffDelete", { bg = "#2a0d0d" })
hi("DiffText", { bg = "#3a3a0d", bold = true })
hi("DiffTextAdd", { bg = "#1a3a1a", bold = true })

hi("diffAdded", { fg = c.green })
hi("diffRemoved", { fg = c.red })
hi("diffChanged", { fg = c.yellow })
hi("diffOldFile", { fg = c.red, italic = true })
hi("diffNewFile", { fg = c.green, italic = true })
hi("diffFile", { fg = c.blue })
hi("diffLine", { fg = c.fg_dim })
hi("diffIndexLine", { fg = c.magenta })

-- ┌──────────────────────────────────────────┐
-- │             GitSigns                      │
-- └──────────────────────────────────────────┘

hi("GitSignsAdd", { fg = c.green })
hi("GitSignsChange", { fg = c.yellow })
hi("GitSignsDelete", { fg = c.red })
hi("GitSignsCurrentLineBlame", { fg = c.bg_06, italic = true })

-- ┌──────────────────────────────────────────┐
-- │             Completion (blink.cmp / cmp)  │
-- └──────────────────────────────────────────┘

hi("CmpItemAbbr", { fg = c.fg })
hi("CmpItemAbbrDeprecated", { fg = c.fg_dim, strikethrough = true })
hi("CmpItemAbbrMatch", { fg = c.cyan, bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.cyan })
hi("CmpItemKind", { fg = c.magenta })
hi("CmpItemMenu", { fg = c.fg_dim })

hi("CmpItemKindClass", { fg = c.cyan })
hi("CmpItemKindColor", { fg = c.yellow })
hi("CmpItemKindConstant", { fg = c.magenta })
hi("CmpItemKindConstructor", { fg = c.yellow })
hi("CmpItemKindEnum", { fg = c.cyan })
hi("CmpItemKindEnumMember", { fg = c.magenta })
hi("CmpItemKindEvent", { fg = c.yellow })
hi("CmpItemKindField", { fg = c.fg })
hi("CmpItemKindFile", { fg = c.blue })
hi("CmpItemKindFolder", { fg = c.blue })
hi("CmpItemKindFunction", { fg = c.cyan })
hi("CmpItemKindInterface", { fg = c.cyan })
hi("CmpItemKindKeyword", { fg = c.red })
hi("CmpItemKindMethod", { fg = c.cyan })
hi("CmpItemKindModule", { fg = c.lavender })
hi("CmpItemKindOperator", { fg = c.yellow })
hi("CmpItemKindProperty", { fg = c.fg })
hi("CmpItemKindReference", { fg = c.magenta })
hi("CmpItemKindSnippet", { fg = c.green })
hi("CmpItemKindStruct", { fg = c.cyan })
hi("CmpItemKindText", { fg = c.fg })
hi("CmpItemKindTypeParameter", { fg = c.cyan })
hi("CmpItemKindUnit", { fg = c.magenta })
hi("CmpItemKindValue", { fg = c.magenta })
hi("CmpItemKindVariable", { fg = c.fg })

-- ┌──────────────────────────────────────────┐
-- │             Telescope                     │
-- └──────────────────────────────────────────┘

hi("TelescopeNormal", { fg = c.fg, bg = c.bg_02 })
hi("TelescopeBorder", { fg = c.bg_05, bg = c.bg_02 })
hi("TelescopeTitle", { fg = c.cyan, bold = true })
hi("TelescopePromptNormal", { fg = c.fg, bg = c.bg_03 })
hi("TelescopePromptBorder", { fg = c.bg_05, bg = c.bg_03 })
hi("TelescopePromptTitle", { fg = c.red, bold = true })
hi("TelescopePromptPrefix", { fg = c.red })
hi("TelescopeSelection", { bg = c.bg_03, bold = true })
hi("TelescopeSelectionCaret", { fg = c.red })
hi("TelescopeMatching", { fg = c.cyan, bold = true })
hi("TelescopePreviewTitle", { fg = c.green, bold = true })

-- ┌──────────────────────────────────────────┐
-- │             FZF-Lua                       │
-- └──────────────────────────────────────────┘

hi("FzfLuaNormal", { fg = c.fg, bg = c.bg_02 })
hi("FzfLuaBorder", { fg = c.bg_05, bg = c.bg_02 })
hi("FzfLuaTitle", { fg = c.cyan, bold = true })
hi("FzfLuaPreviewTitle", { fg = c.green, bold = true })
hi("FzfLuaCursorLine", { bg = c.bg_03 })
hi("FzfLuaSearch", { fg = c.cyan, bold = true })

-- ┌──────────────────────────────────────────┐
-- │             Trouble                       │
-- └──────────────────────────────────────────┘

hi("TroubleNormal", { fg = c.fg, bg = c.bg_02 })
hi("TroubleCount", { fg = c.magenta, bold = true })
hi("TroubleText", { fg = c.fg_muted })

-- ┌──────────────────────────────────────────┐
-- │             Neogit                        │
-- └──────────────────────────────────────────┘

hi("NeogitDiffAdd", { fg = c.green, bg = "#0d2a0d" })
hi("NeogitDiffDelete", { fg = c.red, bg = "#2a0d0d" })
hi("NeogitDiffContext", { fg = c.fg_dim })
hi("NeogitHunkHeader", { fg = c.blue, bg = c.bg_03, bold = true })
hi("NeogitBranch", { fg = c.magenta, bold = true })
hi("NeogitRemote", { fg = c.green, bold = true })

-- ┌──────────────────────────────────────────┐
-- │             Which-Key                     │
-- └──────────────────────────────────────────┘

hi("WhichKey", { fg = c.cyan })
hi("WhichKeyGroup", { fg = c.blue })
hi("WhichKeySeparator", { fg = c.bg_05 })
hi("WhichKeyDesc", { fg = c.fg })
hi("WhichKeyFloat", { bg = c.bg_02 })
hi("WhichKeyBorder", { fg = c.bg_05, bg = c.bg_02 })
hi("WhichKeyValue", { fg = c.fg_dim })

-- ┌──────────────────────────────────────────┐
-- │             Todo Comments                 │
-- └──────────────────────────────────────────┘

hi("TodoBgFIX", { fg = c.bg, bg = c.red, bold = true })
hi("TodoBgHACK", { fg = c.bg, bg = c.yellow, bold = true })
hi("TodoBgNOTE", { fg = c.bg, bg = c.cyan, bold = true })
hi("TodoBgPERF", { fg = c.bg, bg = c.magenta, bold = true })
hi("TodoBgTODO", { fg = c.bg, bg = c.green, bold = true })
hi("TodoBgWARN", { fg = c.bg, bg = c.yellow, bold = true })
hi("TodoFgFIX", { fg = c.red })
hi("TodoFgHACK", { fg = c.yellow })
hi("TodoFgNOTE", { fg = c.cyan })
hi("TodoFgPERF", { fg = c.magenta })
hi("TodoFgTODO", { fg = c.green })
hi("TodoFgWARN", { fg = c.yellow })

-- ┌──────────────────────────────────────────┐
-- │             Harpoon                       │
-- └──────────────────────────────────────────┘

hi("HarpoonWindow", { fg = c.fg, bg = c.bg_02 })
hi("HarpoonBorder", { fg = c.bg_05, bg = c.bg_02 })

-- ┌──────────────────────────────────────────┐
-- │             Snacks                        │
-- └──────────────────────────────────────────┘

hi("SnacksNormal", { fg = c.fg, bg = c.bg })
hi("SnacksDashboardHeader", { fg = c.cyan })
hi("SnacksDashboardFooter", { fg = c.fg_dim })
hi("SnacksDashboardDesc", { fg = c.fg })
hi("SnacksDashboardKey", { fg = c.yellow })
hi("SnacksDashboardIcon", { fg = c.blue })
hi("SnacksNotifierInfo", { fg = c.info })
hi("SnacksNotifierWarn", { fg = c.warn })
hi("SnacksNotifierError", { fg = c.error })
hi("SnacksIndent", { fg = c.bg_03 })
hi("SnacksIndentScope", { fg = c.bg_05 })

-- ┌──────────────────────────────────────────┐
-- │             DAP                           │
-- └──────────────────────────────────────────┘

hi("DapBreakpoint", { fg = c.red })
hi("DapBreakpointCondition", { fg = c.yellow })
hi("DapLogPoint", { fg = c.blue })
hi("DapStopped", { fg = c.green })

hi("DapUIScope", { fg = c.cyan })
hi("DapUIType", { fg = c.cyan })
hi("DapUIValue", { fg = c.fg })
hi("DapUIModifiedValue", { fg = c.yellow, bold = true })
hi("DapUIDecoration", { fg = c.cyan })
hi("DapUIThread", { fg = c.green })
hi("DapUIStoppedThread", { fg = c.cyan })
hi("DapUIFrameName", { fg = c.fg })
hi("DapUISource", { fg = c.magenta })
hi("DapUILineNumber", { fg = c.cyan })
hi("DapUIFloatNormal", { fg = c.fg, bg = c.bg_02 })
hi("DapUIFloatBorder", { fg = c.bg_05, bg = c.bg_02 })
hi("DapUIWatchesEmpty", { fg = c.red })
hi("DapUIWatchesValue", { fg = c.green })
hi("DapUIWatchesError", { fg = c.red })

-- ┌──────────────────────────────────────────┐
-- │             Neotest                       │
-- └──────────────────────────────────────────┘

hi("NeotestPassed", { fg = c.green })
hi("NeotestFailed", { fg = c.red })
hi("NeotestRunning", { fg = c.yellow })
hi("NeotestSkipped", { fg = c.fg_dim })
hi("NeotestNamespace", { fg = c.cyan })
hi("NeotestFile", { fg = c.blue })
hi("NeotestDir", { fg = c.blue })
hi("NeotestAdapterName", { fg = c.magenta, bold = true })

-- ┌──────────────────────────────────────────┐
-- │             Mini                          │
-- └──────────────────────────────────────────┘

hi("MiniCursorword", { bg = c.bg_03, bold = true })
hi("MiniIndentscopeSymbol", { fg = c.bg_05 })
hi("MiniIndentscopePrefix", { nocombine = true })
hi("MiniJump", { fg = c.bg, bg = c.yellow })
hi("MiniJump2dSpot", { fg = c.magenta, bold = true })
hi("MiniStatuslineDevinfo", { fg = c.fg_muted, bg = c.bg_04 })
hi("MiniStatuslineFileinfo", { fg = c.fg_muted, bg = c.bg_04 })
hi("MiniStatuslineFilename", { fg = c.fg_dim, bg = c.bg_02 })
hi("MiniStatuslineInactive", { fg = c.fg_dim, bg = c.bg_02 })
hi("MiniStatuslineModeCommand", { fg = c.bg, bg = c.yellow, bold = true })
hi("MiniStatuslineModeInsert", { fg = c.bg, bg = c.green, bold = true })
hi("MiniStatuslineModeNormal", { fg = c.bg, bg = c.blue, bold = true })
hi("MiniStatuslineModeOther", { fg = c.bg, bg = c.cyan, bold = true })
hi("MiniStatuslineModeReplace", { fg = c.bg, bg = c.red, bold = true })
hi("MiniStatuslineModeVisual", { fg = c.bg, bg = c.magenta, bold = true })

-- ┌──────────────────────────────────────────┐
-- │             Glance                        │
-- └──────────────────────────────────────────┘

hi("GlancePreviewNormal", { fg = c.fg, bg = c.bg_02 })
hi("GlancePreviewMatch", { fg = c.cyan, bold = true })
hi("GlancePreviewBorderBottom", { fg = c.bg_05 })
hi("GlanceListNormal", { fg = c.fg, bg = c.bg_01 })
hi("GlanceListMatch", { fg = c.cyan, bold = true })
hi("GlanceListBorderBottom", { fg = c.bg_05 })
hi("GlanceFoldIcon", { fg = c.fg_dim })
hi("GlanceListCount", { fg = c.magenta, bold = true })
hi("GlanceListFilename", { fg = c.fg_dim })
hi("GlanceListFilepath", { fg = c.fg_dim })

-- ┌──────────────────────────────────────────┐
-- │             Navic                         │
-- └──────────────────────────────────────────┘

hi("NavicIconsFile", { fg = c.blue })
hi("NavicIconsModule", { fg = c.lavender })
hi("NavicIconsNamespace", { fg = c.lavender })
hi("NavicIconsPackage", { fg = c.lavender })
hi("NavicIconsClass", { fg = c.cyan })
hi("NavicIconsMethod", { fg = c.cyan })
hi("NavicIconsProperty", { fg = c.fg })
hi("NavicIconsField", { fg = c.fg })
hi("NavicIconsConstructor", { fg = c.yellow })
hi("NavicIconsEnum", { fg = c.cyan })
hi("NavicIconsInterface", { fg = c.cyan })
hi("NavicIconsFunction", { fg = c.cyan })
hi("NavicIconsVariable", { fg = c.fg })
hi("NavicIconsConstant", { fg = c.magenta })
hi("NavicIconsString", { fg = c.green })
hi("NavicIconsNumber", { fg = c.magenta })
hi("NavicIconsBoolean", { fg = c.magenta })
hi("NavicIconsArray", { fg = c.yellow })
hi("NavicIconsObject", { fg = c.yellow })
hi("NavicIconsKey", { fg = c.red })
hi("NavicIconsNull", { fg = c.magenta })
hi("NavicIconsEnumMember", { fg = c.magenta })
hi("NavicIconsStruct", { fg = c.cyan })
hi("NavicIconsEvent", { fg = c.yellow })
hi("NavicIconsOperator", { fg = c.yellow })
hi("NavicIconsTypeParameter", { fg = c.cyan })
hi("NavicText", { fg = c.fg })
hi("NavicSeparator", { fg = c.fg_dim })

-- ┌──────────────────────────────────────────┐
-- │             Oil                           │
-- └──────────────────────────────────────────┘

hi("OilDir", { fg = c.blue, bold = true })
hi("OilDirIcon", { fg = c.blue })
hi("OilSocket", { fg = c.magenta })
hi("OilLink", { fg = c.cyan })
hi("OilFile", { fg = c.fg })
hi("OilCreate", { fg = c.green })
hi("OilDelete", { fg = c.red })
hi("OilMove", { fg = c.yellow })
hi("OilCopy", { fg = c.cyan })
hi("OilChange", { fg = c.yellow })

-- ┌──────────────────────────────────────────┐
-- │             Lightspeed                    │
-- └──────────────────────────────────────────┘

hi("LightspeedLabel", { fg = c.magenta, bold = true, underline = true })
hi("LightspeedLabelDistant", { fg = c.cyan, bold = true, underline = true })
hi("LightspeedShortcut", { fg = c.bg, bg = c.magenta, bold = true })
hi("LightspeedMaskedChar", { fg = c.fg_dim })
hi("LightspeedUnlabeledMatch", { fg = c.fg, bold = true })
hi("LightspeedGreyWash", { fg = c.bg_06 })

-- ┌──────────────────────────────────────────┐
-- │             UFO (folds)                   │
-- └──────────────────────────────────────────┘

hi("UfoFoldedFg", { fg = c.fg })
hi("UfoFoldedBg", { bg = c.bg_03 })
hi("UfoCursorFoldedLine", { bg = c.bg_03 })
hi("UfoFoldedEllipsis", { fg = c.fg_dim })
hi("UfoPreviewSbar", { bg = c.bg_04 })
hi("UfoPreviewThumb", { bg = c.bg_06 })

-- ┌──────────────────────────────────────────┐
-- │             Markup / Markdown             │
-- └──────────────────────────────────────────┘

hi("markdownH1", { fg = c.red, bold = true })
hi("markdownH2", { fg = c.yellow, bold = true })
hi("markdownH3", { fg = c.green, bold = true })
hi("markdownH4", { fg = c.cyan, bold = true })
hi("markdownH5", { fg = c.blue, bold = true })
hi("markdownH6", { fg = c.magenta, bold = true })
hi("markdownCode", { fg = c.green })
hi("markdownCodeBlock", { fg = c.green })
hi("markdownBold", { bold = true })
hi("markdownItalic", { italic = true })
hi("markdownUrl", { fg = c.blue, underline = true })
hi("markdownLinkText", { fg = c.cyan })
hi("markdownListMarker", { fg = c.red })

-- ┌──────────────────────────────────────────┐
-- │             Misc                          │
-- └──────────────────────────────────────────┘

hi("healthError", { fg = c.error })
hi("healthSuccess", { fg = c.ok })
hi("healthWarning", { fg = c.warn })

hi("qfFileName", { fg = c.blue })
hi("qfLineNr", { fg = c.yellow })

-- Expose palette for other configs (heirline, etc.)
M.palette = c

return M
