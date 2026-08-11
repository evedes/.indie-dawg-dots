-- User commands not tied to a specific plugin.

-- Run the dotfiles health check (see lua/dotfiles/health.lua).
vim.api.nvim_create_user_command("DotfilesHealth", function()
  vim.cmd("checkhealth dotfiles")
end, { desc = "Check external tools this config expects" })

vim.api.nvim_create_user_command("Dictionary", function(opts)
  require("config.dictionary").lookup(opts.args)
end, { desc = "Look up a word in a scrollable dictionary tab", nargs = 1 })
