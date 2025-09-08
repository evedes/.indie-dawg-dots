local M = {}

-- Available themes configuration
M.themes = {
  {
    name = "kanagawa-dragon",
    colorscheme = "kanagawa",
    variant = "dragon",
    setup = function()
      require("kanagawa").setup({
        theme = "dragon",
        background = {
          dark = "dragon",
          light = "lotus",
        },
      })
    end,
  },
  {
    name = "kanagawa-wave",
    colorscheme = "kanagawa",
    variant = "wave",
    setup = function()
      require("kanagawa").setup({
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
    end,
  },
  {
    name = "kanagawa-lotus",
    colorscheme = "kanagawa",
    variant = "lotus",
    setup = function()
      require("kanagawa").setup({
        theme = "lotus",
        background = {
          dark = "dragon",
          light = "lotus",
        },
      })
    end,
  },
  {
    name = "catppuccin-mocha",
    colorscheme = "catppuccin",
    variant = "mocha",
    setup = function()
      vim.g.catppuccin_flavour = "mocha"
    end,
  },
  {
    name = "catppuccin-macchiato",
    colorscheme = "catppuccin",
    variant = "macchiato",
    setup = function()
      vim.g.catppuccin_flavour = "macchiato"
    end,
  },
  {
    name = "catppuccin-frappe",
    colorscheme = "catppuccin",
    variant = "frappe",
    setup = function()
      vim.g.catppuccin_flavour = "frappe"
    end,
  },
  {
    name = "catppuccin-latte",
    colorscheme = "catppuccin",
    variant = "latte",
    setup = function()
      vim.g.catppuccin_flavour = "latte"
    end,
  },
}

-- Current theme index
M.current_theme_index = 1

-- Save theme preference to a file
local function save_theme_preference(theme_name)
  local config_path = vim.fn.stdpath("config") .. "/theme-preference.txt"
  local file = io.open(config_path, "w")
  if file then
    file:write(theme_name)
    file:close()
  end
end

-- Load theme preference from file
local function load_theme_preference()
  local config_path = vim.fn.stdpath("config") .. "/theme-preference.txt"
  local file = io.open(config_path, "r")
  if file then
    local theme_name = file:read("*l")
    file:close()
    return theme_name
  end
  return nil
end

-- Apply a theme by index
local function apply_theme(index)
  local theme = M.themes[index]
  if theme then
    -- Run setup if provided
    if theme.setup then
      theme.setup()
    end
    
    -- Apply colorscheme
    vim.cmd("colorscheme " .. theme.colorscheme)
    
    -- Apply custom search highlighting (from original kanagawa config)
    vim.api.nvim_set_hl(0, "Search", { bg = "#FFFF00", fg = "#000000" })
    vim.api.nvim_set_hl(0, "IncSearch", { bg = "#FFFF00", fg = "#000000" })
    
    -- Save preference
    save_theme_preference(theme.name)
    
    -- Update current index
    M.current_theme_index = index
    
    -- Notify user
    vim.notify("Theme switched to: " .. theme.name, vim.log.levels.INFO)
  end
end

-- Initialize theme on startup
M.init = function()
  local saved_theme = load_theme_preference()
  if saved_theme then
    for i, theme in ipairs(M.themes) do
      if theme.name == saved_theme then
        M.current_theme_index = i
        apply_theme(i)
        return
      end
    end
  end
  -- Default to first theme if no preference found
  apply_theme(1)
end

-- Cycle to next theme
M.cycle_theme = function()
  local next_index = M.current_theme_index % #M.themes + 1
  apply_theme(next_index)
end

-- Show theme picker using vim.ui.select
M.pick_theme = function()
  local theme_names = {}
  for i, theme in ipairs(M.themes) do
    table.insert(theme_names, theme.name)
  end
  
  vim.ui.select(theme_names, {
    prompt = "Select theme:",
    format_item = function(item)
      return item == M.themes[M.current_theme_index].name and "● " .. item or "  " .. item
    end,
  }, function(choice, idx)
    if idx then
      apply_theme(idx)
    end
  end)
end

return M