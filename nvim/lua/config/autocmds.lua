vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("auto-format", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Completely disable native completion and omnifunc
vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter" }, {
  desc = "Disable native completion and omnifunc",
  group = vim.api.nvim_create_augroup("disable-native-completion", { clear = true }),
  callback = function()
    vim.bo.omnifunc = ""
    vim.bo.completefunc = ""
    vim.bo.tagfunc = ""
    vim.opt_local.complete = ""
  end,
})

-- Make floating windows transparent
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Set transparent backgrounds for floating windows",
  group = vim.api.nvim_create_augroup("transparent-floats", { clear = true }),
  callback = function()
    local highlights = {
      "NormalFloat",
      "FloatBorder",
      "FloatTitle",
      "LazyNormal",
      "LazyButton",
      "LazyButtonActive",
    }
    for _, group in ipairs(highlights) do
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    end
  end,
})
