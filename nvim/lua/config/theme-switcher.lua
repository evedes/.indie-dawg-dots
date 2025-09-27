local M = {}

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
}

M.current_theme_index = 1

local function save_theme_preference(theme_name)
  local data_path = vim.fn.stdpath("data") .. "/theme-preference"
  vim.fn.writefile({ theme_name }, data_path)
end

local function load_theme_preference()
  local data_path = vim.fn.stdpath("data") .. "/theme-preference"
  if vim.fn.filereadable(data_path) == 1 then
    local lines = vim.fn.readfile(data_path)
    return lines[1]
  end
  return nil
end

local function apply_theme(index)
  local theme = M.themes[index]
  if theme then
    if theme.setup then
      theme.setup()
    end
    vim.cmd("colorscheme " .. theme.colorscheme)
    vim.api.nvim_set_hl(0, "Search", { bg = "#FFFF00", fg = "#000000" })
    vim.api.nvim_set_hl(0, "IncSearch", { bg = "#FFFF00", fg = "#000000" })
    save_theme_preference(theme.name)
    M.current_theme_index = index
  end
end

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
  apply_theme(1)
end

M.cycle_theme = function()
  local next_index = M.current_theme_index % #M.themes + 1
  apply_theme(next_index)
end

M.pick_theme = function()
  local items = {}
  for i, theme in ipairs(M.themes) do
    local prefix = i == M.current_theme_index and "[x] " or "[ ] "
    table.insert(items, {
      text = prefix .. theme.name,
      index = i,
      name = theme.name,
    })
  end
  
  require("mini.pick").start({
    source = {
      items = items,
      name = "Theme Picker",
      choose = function(item)
        if item then
          apply_theme(item.index)
        end
      end,
    },
  })
end

return M
