-- Yank highlight that briefly flashes the yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})

-- Custom split divider color (adapts to light/dark background)
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Set split divider color",
  group = vim.api.nvim_create_augroup("custom-winseparator", { clear = true }),
  callback = function()
    local bg = vim.o.background
    local fg = bg == "light" and "#c8c093" or "#54546d"
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = fg })
  end,
})

-- Rebalance splits when Neovim is resized (e.g., tmux pane changes)
vim.api.nvim_create_autocmd("VimResized", {
  desc = "Equalize splits on resize",
  group = vim.api.nvim_create_augroup("equalize-splits", { clear = true }),
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Open help in a vertical split to the right
vim.api.nvim_create_autocmd("FileType", {
  desc = "Open help in vertical split",
  group = vim.api.nvim_create_augroup("help-vertical", { clear = true }),
  pattern = "help",
  callback = function()
    vim.cmd("wincmd L")
  end,
})
