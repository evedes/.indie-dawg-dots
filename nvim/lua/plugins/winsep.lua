return {
  "nvim-zh/colorful-winsep.nvim",
  event = "WinNew",
  opts = {
    -- Highlight for Window separator
    hi = {
      bg = "NONE",
      fg = "#7B99D4",
    },
    -- Timer refresh interval for smooth appearance
    interval = 30,
    -- Disable in specific filetypes
    no_exec_files = {
      "packer",
      "TelescopePrompt",
      "mason",
      "neo-tree",
      "lazy",
      "minifiles",
      "Trouble",
    },
    -- Symbols for the separator line
    symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
  },
}
