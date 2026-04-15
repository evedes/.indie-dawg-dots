vim.pack.add {
  "https://github.com/rebelot/kanagawa.nvim",
  "https://github.com/catppuccin/nvim",
  "https://github.com/thesimonho/kanagawa-paper.nvim"
}

local themes = {
  "kanagawa-dragon",
  "kanagawa-wave",
  "kanagawa-lotus",
  "catppuccin-mocha",
  "catppuccin-macchiato",
  "catppuccin-frappe",
  "catppuccin-latte",
  "kanagawa-paper"
}

local default_theme = "kanagawa-dragon"
local state_file = vim.fn.stdpath("data") .. "/theme-preference.json"

local state = { theme = default_theme, transparent = false }

local function load_state()
  local f = io.open(state_file, "r")
  if not f then return end
  local content = f:read("*a")
  f:close()
  local ok, decoded = pcall(vim.json.decode, content)
  if ok and type(decoded) == "table" then
    state.theme = decoded.theme or state.theme
    state.transparent = decoded.transparent == true
  end
end

local function save_state()
  local f = io.open(state_file, "w")
  if not f then return end
  f:write(vim.json.encode(state))
  f:close()
end

local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "SignColumn",
  "EndOfBuffer",
}

local function apply_transparency()
  if not state.transparent then return end
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_transparency })

load_state()
vim.cmd.colorscheme(state.theme)

vim.keymap.set("n", "<leader>ut", function()
  vim.ui.select(themes, { prompt = "Select theme" }, function(choice)
    if not choice then return end
    state.theme = choice
    vim.cmd.colorscheme(choice)
    save_state()
  end)
end, { silent = true, desc = "Pick theme" })

vim.keymap.set("n", "<leader>ub", function()
  state.transparent = not state.transparent
  if state.transparent then
    apply_transparency()
    vim.notify("Background disabled (transparent)")
  else
    vim.cmd.colorscheme(state.theme)
    vim.notify("Background enabled")
  end
  save_state()
end, { silent = true, desc = "Toggle background" })
