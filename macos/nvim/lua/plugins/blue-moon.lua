return {
  "kyazdani42/blue-moon",
  enabled = true,
  lazy = true,
  priority = 1000,
  config = function()
    -- Blue-moon doesn't define @markup.heading colors that markview needs
    -- Define them to match blue-moon's color palette
    local function set_markup_highlights()
      local colors = {
        "#d06178", -- red (h1)
        "#cfcfbf", -- cream (h2)
        "#b4c4b4", -- green (h3)
        "#89ddff", -- cyan (h4)
        "#959dcb", -- purple (h5)
        "#b9a3eb", -- lavender (h6)
      }
      for i, color in ipairs(colors) do
        vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", { fg = color, bold = true })
      end
      vim.api.nvim_set_hl(0, "@markup.heading", { fg = colors[1], bold = true })
    end

    -- Apply on future colorscheme changes to blue-moon
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "blue-moon",
      callback = set_markup_highlights,
    })

    -- Apply immediately if blue-moon is already/being set
    if vim.g.colors_name == "blue-moon" then
      set_markup_highlights()
    end
  end,
}
