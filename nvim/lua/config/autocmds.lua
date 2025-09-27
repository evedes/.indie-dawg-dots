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
