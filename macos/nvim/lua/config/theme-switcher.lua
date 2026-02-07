-- Theme Switcher
-- Easily switch between different colorschemes

local M = {}

-- Available themes with their configurations
M.themes = {
  { name = "Kanagawa Dragon", scheme = "kanagawa", variant = "dragon" },
  { name = "Kanagawa Wave", scheme = "kanagawa", variant = "wave" },
  { name = "Kanagawa Paper", scheme = "kanagawa-paper", variant = nil },
  { name = "Oxocarbon", scheme = "oxocarbon", variant = nil },
  { name = "Blue Moon", scheme = "blue-moon", variant = nil },
  { name = "Apprentice", scheme = "apprentice", variant = nil },
  { name = "Everforest", scheme = "everforest", variant = nil },
  { name = "Gruvbox Material", scheme = "gruvbox-material", variant = nil },
  { name = "Melange", scheme = "melange", variant = nil },
  { name = "Nord", scheme = "nord", variant = nil },
  { name = "Nordic", scheme = "nordic", variant = nil },
  { name = "Atomize", scheme = "atomize", variant = nil },
  { name = "Sonoma", scheme = "sonoma", variant = nil },
  { name = "Green Forest", scheme = "green-forest", variant = nil },
  { name = "White Nord", scheme = "white-nord", variant = nil },
  { name = "Rainbow", scheme = "rainbow", variant = nil },
  { name = "Dark Fantasy", scheme = "dark-fantasy", variant = nil },
}

-- File to store theme preference
local themes_dir = vim.fn.expand("$HOME/.indie-dawg-dots/macos/nvim/lua/themes")
local preference_file = themes_dir .. "/theme-preference.txt"
local transparency_file = themes_dir .. "/transparency-preference.txt"

-- Transparency state
M.transparent = false

-- Highlight groups to make transparent
local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "SignColumn",
  "EndOfBuffer",
  "MsgArea",
  "FloatBorder",
  "WinBar",
  "WinBarNC",
  "LineNr",
  "CursorLineNr",
  "CursorLine",
  "FoldColumn",
  "Folded",
  "GitSignsAdd",
  "GitSignsChange",
  "GitSignsDelete",
}

-- Get current theme index
function M.get_current_index()
  local current_scheme = vim.g.colors_name
  for i, theme in ipairs(M.themes) do
    if theme.scheme == current_scheme then
      return i
    end
  end
  return 1
end

-- Apply transparency to current colorscheme
function M.apply_transparency()
  for _, group in ipairs(transparent_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group })
    hl.bg = nil
    hl.ctermbg = nil
    vim.api.nvim_set_hl(0, group, hl)
  end
  -- Set a background for nvim-notify so it remains readable
  vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#1a1a1a" })
end

-- Save transparency preference
function M.save_transparency()
  local file = io.open(transparency_file, "w")
  if file then
    file:write(M.transparent and "1" or "0")
    file:close()
  end
end

-- Load transparency preference
function M.load_transparency()
  local file = io.open(transparency_file, "r")
  if file then
    local value = file:read("*a")
    file:close()
    M.transparent = value == "1"
  end
end

-- Toggle transparency
function M.toggle_transparency()
  M.transparent = not M.transparent
  M.save_transparency()
  if M.transparent then
    M.apply_transparency()
    vim.notify("Transparency: ON", vim.log.levels.INFO)
  else
    -- Re-apply current theme to restore backgrounds
    local index = M.get_current_index()
    M.apply_theme(M.themes[index], true)
    vim.notify("Transparency: OFF", vim.log.levels.INFO)
  end
end

-- Apply a theme
function M.apply_theme(theme, silent)
  -- Ensure the plugin is loaded first
  if theme.scheme == "kanagawa-paper" then
    require("lazy").load({ plugins = { "kanagawa-paper.nvim" } })
  elseif theme.scheme == "kanagawa" then
    require("lazy").load({ plugins = { "kanagawa.nvim" } })
  elseif theme.scheme == "oxocarbon" then
    require("lazy").load({ plugins = { "oxocarbon.nvim" } })
  elseif theme.scheme == "blue-moon" then
    require("lazy").load({ plugins = { "blue-moon" } })
  elseif theme.scheme == "apprentice" then
    require("lazy").load({ plugins = { "apprentice.nvim" } })
  elseif theme.scheme == "everforest" then
    require("lazy").load({ plugins = { "everforest" } })
  elseif theme.scheme == "gruvbox-material" then
    require("lazy").load({ plugins = { "gruvbox-material" } })
  elseif theme.scheme == "melange" then
    require("lazy").load({ plugins = { "melange-nvim" } })
  elseif theme.scheme == "nord" then
    require("lazy").load({ plugins = { "nord.nvim" } })
  elseif theme.scheme == "nordic" then
    require("lazy").load({ plugins = { "nordic.nvim" } })
  end

  if theme.variant and theme.scheme == "kanagawa" then
    -- For kanagawa variants, set the variant before applying
    require("kanagawa").setup({
      compile = false,
      transparent = false,
      theme = theme.variant,
      background = {
        dark = theme.variant,
        light = "lotus",
      },
    })
  end

  -- Safely apply colorscheme
  local ok, err = pcall(vim.cmd.colorscheme, theme.scheme)
  if not ok then
    vim.notify("Failed to load theme: " .. theme.name .. "\n" .. err, vim.log.levels.ERROR)
  else
    -- Apply transparency if enabled
    if M.transparent then
      M.apply_transparency()
    end
    if not silent then
      vim.notify("Theme: " .. theme.name, vim.log.levels.INFO)
    end
  end
end

-- Save theme preference
function M.save_preference(index)
  local file = io.open(preference_file, "w")
  if file then
    file:write(tostring(index))
    file:close()
  end
end

-- Load theme preference
function M.load_preference()
  local file = io.open(preference_file, "r")
  if file then
    local index = tonumber(file:read("*a"))
    file:close()
    -- Ensure index is within valid range
    if index and index >= 1 and index <= #M.themes then
      return index
    end
  end
  return 1
end

-- Cycle to next theme
function M.cycle_theme()
  local current = M.get_current_index()
  local next_index = (current % #M.themes) + 1
  local theme = M.themes[next_index]
  M.apply_theme(theme)
  M.save_preference(next_index)
end

-- Show theme picker
function M.pick_theme()
  local items = {}
  for i, theme in ipairs(M.themes) do
    table.insert(items, { text = theme.name, index = i })
  end

  MiniPick.start({
    source = {
      items = items,
      name = "Themes",
      choose = function(item)
        local theme = M.themes[item.index]
        M.apply_theme(theme)
        M.save_preference(item.index)
      end,
    },
  })
end

-- Initialize with saved preference (silent on startup)
function M.init()
  M.load_transparency()
  local saved_index = M.load_preference()
  local theme = M.themes[saved_index]
  M.apply_theme(theme, true)
end

return M
