return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = false }, -- using mini.statusline
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true },
      },
      backdrop = {
        transparent = true,
        blend = 0,
      },
    },
    explorer = {
      enabled = true,
      replace_netrw = false,
    },
    picker = {
      enabled = true,
      layout = {
        preset = "ivy",
      },
      win = {
        input = {
          keys = {
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-k>"] = { "list_up", mode = { "i", "n" } },
          },
        },
      },
      -- Configure sources to include all files
      sources = {
        files = {
          git = false, -- Don't use git ls-files
          hidden = true, -- Show hidden files
          ignored = true, -- Show ignored files
        },
        explorer = {
          -- Show all files in explorer
          hidden = true, -- Show hidden files like .env
          ignored = true, -- Show gitignored files
        },
      },
    },
  },
}

