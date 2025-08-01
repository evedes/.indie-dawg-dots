return {
  "OXY2DEV/markview.nvim",
  lazy = true,
  ft = { "markdown", "md" },
  cmd = { "Markview" },

  dependencies = {
    "saghen/blink.cmp",
  },

  config = function()
    require("markview").setup({
      preview = {
        debounce = 100,
      },
      schedule_update = { enable = false },
      render_time_limit = 50,
    })
  end,
}
