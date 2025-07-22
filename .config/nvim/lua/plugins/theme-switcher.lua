return {
  "theme-switcher",
  dir = vim.fn.stdpath("config"),
  config = function()
    local themes = {
      "kanagawa",
      "catppuccin-mocha",
    }

    local current_theme_index = 1

    local function switch_theme()
      current_theme_index = current_theme_index % #themes + 1
      local theme = themes[current_theme_index]

      if theme == "catppuccin-mocha" then
        vim.cmd("colorscheme catppuccin-mocha")
      else
        vim.cmd("colorscheme " .. theme)
      end

      vim.notify("Switched to " .. theme .. " theme", vim.log.levels.INFO)
    end

    vim.cmd("colorscheme kanagawa")

    vim.keymap.set("n", "<leader>tt", switch_theme, { desc = "Toggle between themes" })
  end,
}

