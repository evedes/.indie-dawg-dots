return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Nextcloud/Multiverse/*.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Nextcloud/Multiverse/*.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Nextcloud/Multiverse",
      },
    },
    open_app_foreground = true,
    obsidian_app_path = vim.fn.has("mac") == 1 and "/Applications/Obsidian.app" or "obsidian",
    mappings = {
      ["<leader>og"] = {
        action = function()
          -- Open Obsidian
          vim.fn.system('open -a Obsidian "' .. vim.fn.expand("~/Nextcloud/Multiverse") .. '"')
          -- Wait a bit for Obsidian to open and load
          vim.cmd("sleep 1000m")
          -- Send the keystroke to open graph view
          vim.fn.system(
            'osascript -e \'tell application "Obsidian" to activate\' -e \'tell application "System Events" to keystroke "g" using {command down, shift down}\''
          )
        end,
        desc = "Open Obsidian Graph",
      },
    },
  },
}
