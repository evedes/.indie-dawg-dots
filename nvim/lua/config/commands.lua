-- User commands not tied to a specific plugin.

-- Run the dotfiles health check (see lua/dotfiles/health.lua).
vim.api.nvim_create_user_command("DotfilesHealth", function()
  vim.cmd("checkhealth dotfiles")
end, { desc = "Check external tools this config expects" })
