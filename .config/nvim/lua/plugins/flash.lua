return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    -- Highlight cursor when jumping (beacon-like behavior)
    highlight = {
      backdrop = false,
      matches = true,
      priority = 5000,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel"
      }
    },
    -- Enable jump highlighting for large movements
    jump = {
      jumplist = true,
      pos = "start",
      history = false,
      register = false,
      nohlsearch = false,
      autojump = false,
      inclusive = nil,
      offset = nil,
    },
    -- Configure modes for automatic cursor highlighting
    modes = {
      search = {
        enabled = true,
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = true },
      },
      char = {
        enabled = true,
        config = function(opts)
          opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"
          opts.jump_labels = vim.v.count == 0 and vim.fn.reg_executing() == ""
            and vim.fn.reg_recording() == ""
        end,
        autohide = false,
        jump_labels = false,
        multi_line = true,
        label = { after = { 0, 0 } },
        keys = { "f", "F", "t", "T", ";" },
      },
      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash Jump",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
  },
}
