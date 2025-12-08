return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = {
      char = "┊",
      highlight = "IblIndent",
    },
    scope = {
      show_start = false,
      show_end = false,
    },
  },
  config = function(_, opts)
    -- Set up custom highlights with more transparency
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2A2A37", nocombine = true })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#3A3A47", nocombine = true })

    require("ibl").setup(opts)
  end,
}
