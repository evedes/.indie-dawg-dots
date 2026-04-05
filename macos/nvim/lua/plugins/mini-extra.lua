vim.pack.add {
	"https://github.com/nvim-mini/mini.extra",
}

require("mini.extra").setup()

-- Keymaps
vim.keymap.set("n", "<leader>fd", function() MiniExtra.pickers.diagnostic() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fq", function() MiniExtra.pickers.list({ scope = "quickfix" }) end, { desc = "Quickfix" })
vim.keymap.set("n", "<leader>fl", function() MiniExtra.pickers.list({ scope = "location" }) end, { desc = "Location list" })
vim.keymap.set("n", "<leader>fk", function() MiniExtra.pickers.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fo", function() MiniExtra.pickers.oldfiles() end, { desc = "Recent files" })
