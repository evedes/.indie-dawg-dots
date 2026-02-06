return {
  "sho-87/kanagawa-paper.nvim",
  lazy = true,
  priority = 1000,
  opts = {
    undercurl = true,
    transparent = true,
    gutter = false,
    dimInactive = true,
    terminalColors = true,
    commentStyle = { italic = true },
    functionStyle = { italic = false },
    keywordStyle = { italic = false, bold = false },
    statementStyle = { italic = false, bold = false },
    typeStyle = { italic = false },
    colors = {
      theme = {},
      palette = {},
    },
    overrides = function()
      return {}
    end,
  },
}
