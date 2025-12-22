require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
require("lsp")

-- Initialize theme switcher immediately after lazy.nvim setup
-- Must happen before filetype plugins (like markview) load
require("config.theme-switcher").init()
