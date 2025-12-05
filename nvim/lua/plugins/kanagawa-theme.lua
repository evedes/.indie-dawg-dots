return {
  "rebelot/kanagawa.nvim",
  enabled = true,
  lazy = true,
  priority = 1000,
  opts = {
    compile = false, -- Disable compile to allow runtime transparent switching
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = true,
    dimInactive = false,
    terminalColors = true,
    colors = {
      palette = {},
      theme = {
        all = {
          ui = { bg_gutter = "none" },
        },
      },
    },
    overrides = function(colors)
      local theme_colors = colors.theme
      return {
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },
        SignColumn = { bg = "none" },
        StatusLine = { bg = "none" },
        StatusLineNC = { bg = "none" },
        LazyNormal = { bg = "none", fg = theme_colors.ui.fg },
        LazyButton = { bg = "none" },
        LazyButtonActive = { bg = "none" },
      }
    end,
  },
}
