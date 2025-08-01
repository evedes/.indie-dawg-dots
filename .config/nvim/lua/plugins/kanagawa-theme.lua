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
          wave = {},
          lotus = {},
          dragon = {},
          all = {
            ui = { bg_gutter = "none" },
          },
        },
      },
      theme = "dragon",
      background = {
        dark = "dragon",
        light = "lotus",
      },
    })
    vim.cmd("colorscheme kanagawa")

    -- Custom search highlighting
    vim.api.nvim_set_hl(0, "Search", { bg = "#FFFF00", fg = "#000000" })
    vim.api.nvim_set_hl(0, "IncSearch", { bg = "#FFFF00", fg = "#000000" })
  end,
  build = function()
    vim.cmd("KanagawaCompile")
  end,
}
