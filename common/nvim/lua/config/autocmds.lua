vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("auto-format", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Markview autocmds
local markview_group = vim.api.nvim_create_augroup("markview", { clear = true })

-- Auto-enable markview for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "md" },
  group = markview_group,
  callback = function()
    vim.cmd("Markview enable")
  end,
})

-- Disable markview in insert mode for better performance
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = { "*.md", "*.markdown" },
  group = markview_group,
  callback = function()
    vim.cmd("Markview disable")
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = { "*.md", "*.markdown" },
  group = markview_group,
  callback = function()
    vim.cmd("Markview enable")
  end,
})

-- Toggle markview when entering/leaving diff mode
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  group = markview_group,
  callback = function()
    if vim.v.option_new == "1" then
      vim.cmd("Markview disable")
    else
      vim.cmd("Markview enable")
    end
  end,
})
