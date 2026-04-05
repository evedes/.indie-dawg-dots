vim.pack.add {
	"https://github.com/nvim-mini/mini.diff",
}

require("mini.diff").setup()

-- Keymaps
vim.keymap.set("n", "<leader>go", function() MiniDiff.toggle_overlay() end, { desc = "Toggle diff overlay" })
