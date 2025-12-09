-- Theme Switcher
-- Easily switch between different colorschemes

local M = {}

-- Available themes with their configurations
M.themes = {
  { name = "Kanagawa Dragon", scheme = "kanagawa", variant = "dragon" },
  { name = "Kanagawa Wave", scheme = "kanagawa", variant = "wave" },
  { name = "Kanagawa Paper", scheme = "kanagawa-paper", variant = nil },
}

-- File to store theme preference
local preference_file = vim.fn.stdpath("config") .. "/theme-preference.txt"

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

-- Apply a theme
function M.apply_theme(theme)
  -- Ensure the plugin is loaded first
  if theme.scheme == "kanagawa-paper" then
    require("lazy").load({ plugins = { "kanagawa-paper.nvim" } })
  elseif theme.scheme == "kanagawa" then
    require("lazy").load({ plugins = { "kanagawa.nvim" } })
  end

  if theme.variant and theme.scheme == "kanagawa" then
    -- For kanagawa variants, apply full config with variant
    require("kanagawa").setup({
      compile = false, -- Disable compile to allow runtime transparent switching
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = {
          all = {
            ui = { bg_gutter = "none" },
          },
        },
      },
      overrides = function(colors)
        local theme_colors = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          SignColumn = { bg = "none" },
          StatusLine = { bg = "none" },
          StatusLineNC = { bg = "none" },
          LazyNormal = { bg = "none", fg = theme_colors.ui.fg },
          LazyButton = { bg = "none" },
          LazyButtonActive = { bg = "none" },
        }
      end,
      theme = theme.variant,
      background = {
        dark = theme.variant,
        light = "wave",
      },
    })
  end

  -- Safely apply colorscheme
  local ok, err = pcall(vim.cmd.colorscheme, theme.scheme)
  if ok then
    vim.notify("Theme: " .. theme.name, vim.log.levels.INFO)
  else
    vim.notify("Failed to load theme: " .. theme.name .. "\n" .. err, vim.log.levels.ERROR)
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

-- Initialize with saved preference
function M.init()
  local saved_index = M.load_preference()
  local theme = M.themes[saved_index]
  M.apply_theme(theme)
end

return M
