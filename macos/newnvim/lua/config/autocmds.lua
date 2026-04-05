-- Yank highlight that briefly flashes the yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})
