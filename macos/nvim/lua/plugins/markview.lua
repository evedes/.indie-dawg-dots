return {
  "OXY2DEV/markview.nvim",
  ft = "markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    modes = { "n", "no", "c" }, -- Normal, no-op, command modes
    hybrid_modes = { "n" }, -- Only show in normal mode
    callbacks = {
      on_enable = function(_, win)
        vim.wo[win].conceallevel = 2
        vim.wo[win].concealcursor = "c"
      end,
    },
  },
  keys = {
    { "<leader>mt", "<cmd>Markview toggle<cr>", desc = "Toggle Markview", ft = "markdown" },
  },
}
