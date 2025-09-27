return {
  "rebelot/kanagawa.nvim",
  enabled = true,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      compile = true,
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
      theme = "dragon", -- Set default theme variant
      background = {
        dark = "dragon",
        light = "lotus",
      },
    })
    -- Load the colorscheme
    vim.cmd("colorscheme kanagawa")
  end,
  build = ":KanagawaCompile",
}
