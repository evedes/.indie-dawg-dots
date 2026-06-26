-- sourcerer — ported from doom-emacs' doom-sourcerer (xero's Sourcerer palette)
-- A warm, muted, low-saturation dark theme. Native Neovim colorscheme: no plugin.

vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd.syntax("reset")
end
vim.g.colors_name = "sourcerer"
vim.o.background = "dark"

local c = {
  bg = "#171717",
  bg_alt = "#222222",
  base0 = "#1d2127",
  base1 = "#1d2127",
  base2 = "#272727",
  base3 = "#32353f",
  base4 = "#494952",
  base5 = "#62686e",
  base6 = "#757b80",
  base7 = "#9ca0a4",
  base8 = "#faf4c6",
  fg = "#c2c2b0",
  fg_alt = "#5d656b",
  grey = "#686858",
  red = "#aa4450",
  orange = "#ff9800",
  green = "#87875f",
  green_br = "#719611",
  teal = "#578f8f",
  yellow = "#faf4c6", -- base8
  blue = "#87afd7",
  dark_blue = "#6688aa",
  magenta = "#8787af",
  violet = "#8181a6",
  cyan = "#87ceeb",
  dark_cyan = "#528b8b",
  none = "NONE",
}

local function hl(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

local groups = {
  -- Editor UI
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { fg = c.fg, bg = c.bg },
  NormalFloat = { fg = c.fg, bg = c.bg_alt },
  FloatBorder = { fg = c.base4, bg = c.bg_alt },
  FloatTitle = { fg = c.base8, bg = c.bg_alt, bold = true },
  ColorColumn = { bg = c.base2 },
  Cursor = { fg = c.bg, bg = c.fg },
  CursorLine = { bg = c.base2 },
  CursorColumn = { bg = c.base2 },
  CursorLineNr = { fg = c.base8, bold = true },
  LineNr = { fg = c.base4 },
  SignColumn = { fg = c.base4, bg = c.bg },
  FoldColumn = { fg = c.base4, bg = c.bg },
  Folded = { fg = c.base6, bg = c.base2 },
  VertSplit = { fg = c.base3 },
  WinSeparator = { fg = c.base3 },
  EndOfBuffer = { fg = c.bg },
  Visual = { bg = c.base4 },
  VisualNOS = { bg = c.base4 },
  Search = { fg = c.bg, bg = c.yellow },
  IncSearch = { fg = c.bg, bg = c.orange },
  CurSearch = { fg = c.bg, bg = c.orange },
  Substitute = { fg = c.bg, bg = c.red },
  MatchParen = { fg = c.cyan, bold = true, underline = true },
  NonText = { fg = c.base4 },
  Whitespace = { fg = c.base3 },
  SpecialKey = { fg = c.base4 },
  Conceal = { fg = c.base5 },
  Directory = { fg = c.blue },
  Title = { fg = c.base8, bold = true },
  ErrorMsg = { fg = c.red, bold = true },
  WarningMsg = { fg = c.orange },
  ModeMsg = { fg = c.fg },
  MoreMsg = { fg = c.teal },
  Question = { fg = c.teal },
  QuickFixLine = { bg = c.base2, bold = true },
  Wildmenu = { fg = c.fg, bg = c.base3 },
  WinBar = { fg = c.fg, bg = c.bg },
  WinBarNC = { fg = c.base5, bg = c.bg },

  -- Statusline / tabline
  StatusLine = { fg = c.fg, bg = c.base2 },
  StatusLineNC = { fg = c.base5, bg = c.base1 },
  TabLine = { fg = c.base6, bg = c.base1 },
  TabLineFill = { bg = c.base1 },
  TabLineSel = { fg = c.base8, bg = c.bg },

  -- Popup menu
  Pmenu = { fg = c.fg, bg = c.bg_alt },
  PmenuSel = { fg = c.bg, bg = c.blue },
  PmenuSbar = { bg = c.base2 },
  PmenuThumb = { bg = c.base5 },
  PmenuKind = { fg = c.violet, bg = c.bg_alt },
  PmenuExtra = { fg = c.base6, bg = c.bg_alt },

  -- Diff
  DiffAdd = { fg = c.green_br, bg = c.base2 },
  DiffChange = { fg = c.yellow, bg = c.base2 },
  DiffDelete = { fg = c.red, bg = c.base2 },
  DiffText = { fg = c.base8, bg = c.base3 },
  diffAdded = { fg = c.green_br },
  diffRemoved = { fg = c.red },
  diffChanged = { fg = c.yellow },

  -- Spell
  SpellBad = { sp = c.red, undercurl = true },
  SpellCap = { sp = c.yellow, undercurl = true },
  SpellLocal = { sp = c.teal, undercurl = true },
  SpellRare = { sp = c.violet, undercurl = true },

  -- Syntax (legacy groups)
  Comment = { fg = c.grey, italic = true },
  Constant = { fg = c.teal },
  String = { fg = c.green },
  Character = { fg = c.green },
  Number = { fg = c.yellow },
  Boolean = { fg = c.yellow },
  Float = { fg = c.yellow },
  Identifier = { fg = c.base8 },
  Function = { fg = c.base8 },
  Statement = { fg = c.blue },
  Conditional = { fg = c.blue },
  Repeat = { fg = c.blue },
  Label = { fg = c.blue },
  Operator = { fg = c.green_br },
  Keyword = { fg = c.blue },
  Exception = { fg = c.blue },
  PreProc = { fg = c.magenta },
  Include = { fg = c.magenta },
  Define = { fg = c.magenta },
  Macro = { fg = c.magenta },
  PreCondit = { fg = c.magenta },
  Type = { fg = c.violet },
  StorageClass = { fg = c.violet },
  Structure = { fg = c.violet },
  Typedef = { fg = c.violet },
  Special = { fg = c.orange },
  SpecialChar = { fg = c.orange },
  Tag = { fg = c.blue },
  Delimiter = { fg = c.fg },
  SpecialComment = { fg = c.dark_cyan, italic = true },
  Debug = { fg = c.red },
  Underlined = { fg = c.blue, underline = true },
  Ignore = { fg = c.base4 },
  Error = { fg = c.red, bold = true },
  Todo = { fg = c.bg, bg = c.yellow, bold = true },

  -- Diagnostics
  DiagnosticError = { fg = c.red },
  DiagnosticWarn = { fg = c.orange },
  DiagnosticInfo = { fg = c.blue },
  DiagnosticHint = { fg = c.teal },
  DiagnosticOk = { fg = c.green_br },
  DiagnosticUnderlineError = { sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.orange, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.teal, undercurl = true },
  DiagnosticVirtualTextError = { fg = c.red, bg = c.base2 },
  DiagnosticVirtualTextWarn = { fg = c.orange, bg = c.base2 },
  DiagnosticVirtualTextInfo = { fg = c.blue, bg = c.base2 },
  DiagnosticVirtualTextHint = { fg = c.teal, bg = c.base2 },

  -- LSP
  LspReferenceText = { bg = c.base3 },
  LspReferenceRead = { bg = c.base3 },
  LspReferenceWrite = { bg = c.base3 },
  LspInlayHint = { fg = c.fg_alt, bg = c.base2, italic = true },
  LspSignatureActiveParameter = { fg = c.orange, bold = true },

  -- Treesitter
  ["@comment"] = { link = "Comment" },
  ["@comment.error"] = { fg = c.red },
  ["@comment.warning"] = { fg = c.orange },
  ["@comment.todo"] = { link = "Todo" },
  ["@comment.note"] = { fg = c.teal },
  ["@constant"] = { fg = c.teal },
  ["@constant.builtin"] = { fg = c.yellow },
  ["@constant.macro"] = { fg = c.magenta },
  ["@string"] = { fg = c.green },
  ["@string.escape"] = { fg = c.orange },
  ["@string.special"] = { fg = c.orange },
  ["@string.regexp"] = { fg = c.dark_cyan },
  ["@character"] = { fg = c.green },
  ["@number"] = { fg = c.yellow },
  ["@boolean"] = { fg = c.yellow },
  ["@float"] = { fg = c.yellow },
  ["@function"] = { fg = c.base8 },
  ["@function.builtin"] = { fg = c.base8 },
  ["@function.call"] = { fg = c.base8 },
  ["@function.macro"] = { fg = c.magenta },
  ["@function.method"] = { fg = c.base8 },
  ["@function.method.call"] = { fg = c.base8 },
  ["@constructor"] = { fg = c.violet },
  ["@parameter"] = { fg = c.fg },
  ["@keyword"] = { fg = c.blue },
  ["@keyword.function"] = { fg = c.blue },
  ["@keyword.operator"] = { fg = c.blue },
  ["@keyword.return"] = { fg = c.blue },
  ["@keyword.import"] = { fg = c.magenta },
  ["@keyword.exception"] = { fg = c.blue },
  ["@conditional"] = { fg = c.blue },
  ["@repeat"] = { fg = c.blue },
  ["@label"] = { fg = c.blue },
  ["@operator"] = { fg = c.green_br },
  ["@exception"] = { fg = c.blue },
  ["@variable"] = { fg = c.base8 },
  ["@variable.builtin"] = { fg = c.red },
  ["@variable.parameter"] = { fg = c.fg },
  ["@variable.member"] = { fg = c.teal },
  ["@property"] = { fg = c.teal },
  ["@field"] = { fg = c.teal },
  ["@type"] = { fg = c.violet },
  ["@type.builtin"] = { fg = c.violet },
  ["@type.definition"] = { fg = c.violet },
  ["@type.qualifier"] = { fg = c.blue },
  ["@storageclass"] = { fg = c.violet },
  ["@attribute"] = { fg = c.magenta },
  ["@namespace"] = { fg = c.violet },
  ["@module"] = { fg = c.violet },
  ["@punctuation.delimiter"] = { fg = c.fg },
  ["@punctuation.bracket"] = { fg = c.base7 },
  ["@punctuation.special"] = { fg = c.orange },
  ["@tag"] = { fg = c.blue },
  ["@tag.attribute"] = { fg = c.teal },
  ["@tag.delimiter"] = { fg = c.fg_alt },

  -- Markup (treesitter, markdown etc.)
  ["@markup.heading"] = { fg = c.base8, bold = true },
  ["@markup.heading.1"] = { fg = c.red, bold = true },
  ["@markup.heading.2"] = { fg = c.orange, bold = true },
  ["@markup.heading.3"] = { fg = c.yellow, bold = true },
  ["@markup.heading.4"] = { fg = c.green, bold = true },
  ["@markup.heading.5"] = { fg = c.blue, bold = true },
  ["@markup.heading.6"] = { fg = c.violet, bold = true },
  ["@markup.raw"] = { fg = c.green },
  ["@markup.link"] = { fg = c.cyan, underline = true },
  ["@markup.link.url"] = { fg = c.dark_blue, underline = true },
  ["@markup.link.label"] = { fg = c.blue },
  ["@markup.list"] = { fg = c.orange },
  ["@markup.strong"] = { fg = c.fg, bold = true },
  ["@markup.italic"] = { fg = c.fg, italic = true },
  ["@markup.strikethrough"] = { fg = c.base6, strikethrough = true },
  ["@markup.quote"] = { fg = c.base6, italic = true },

  -- LSP semantic tokens
  ["@lsp.type.namespace"] = { link = "@namespace" },
  ["@lsp.type.type"] = { link = "@type" },
  ["@lsp.type.class"] = { link = "@type" },
  ["@lsp.type.enum"] = { link = "@type" },
  ["@lsp.type.interface"] = { link = "@type" },
  ["@lsp.type.struct"] = { link = "@type" },
  ["@lsp.type.parameter"] = { link = "@variable.parameter" },
  ["@lsp.type.variable"] = { link = "@variable" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.function"] = { link = "@function" },
  ["@lsp.type.method"] = { link = "@function.method" },
  ["@lsp.type.macro"] = { link = "@function.macro" },
  ["@lsp.type.keyword"] = { link = "@keyword" },

  -- Git signs (gitsigns.nvim)
  GitSignsAdd = { fg = c.green_br },
  GitSignsChange = { fg = c.yellow },
  GitSignsDelete = { fg = c.red },

  -- mini.diff / diff overlay
  MiniDiffSignAdd = { fg = c.green_br },
  MiniDiffSignChange = { fg = c.yellow },
  MiniDiffSignDelete = { fg = c.red },

  -- Snacks picker / explorer
  SnacksPickerDir = { fg = c.base6 },
  SnacksPickerMatch = { fg = c.orange, bold = true },
  SnacksNormal = { fg = c.fg, bg = c.bg_alt },
  SnacksWinBar = { fg = c.base8, bg = c.bg_alt, bold = true },

  -- Which-key
  WhichKey = { fg = c.blue },
  WhichKeyGroup = { fg = c.violet },
  WhichKeyDesc = { fg = c.fg },
  WhichKeySeparator = { fg = c.base5 },
  WhichKeyFloat = { bg = c.bg_alt },

  -- Flash
  FlashLabel = { fg = c.bg, bg = c.orange, bold = true },
  FlashMatch = { fg = c.fg, bg = c.base3 },
  FlashCurrent = { fg = c.bg, bg = c.yellow },
}

for group, spec in pairs(groups) do
  hl(group, spec)
end

-- Terminal colors
vim.g.terminal_color_0 = c.base2
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.violet
vim.g.terminal_color_6 = c.teal
vim.g.terminal_color_7 = c.fg
vim.g.terminal_color_8 = c.base5
vim.g.terminal_color_9 = c.red
vim.g.terminal_color_10 = c.green_br
vim.g.terminal_color_11 = c.orange
vim.g.terminal_color_12 = c.dark_blue
vim.g.terminal_color_13 = c.magenta
vim.g.terminal_color_14 = c.cyan
vim.g.terminal_color_15 = c.base8
