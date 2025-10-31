require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
require("lsp")

-- Initialize theme switcher after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.theme-switcher").init()
  end,
})
