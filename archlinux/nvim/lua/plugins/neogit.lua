vim.pack.add {
	"https://github.com/NeogitOrg/neogit",
	"https://github.com/nvim-lua/plenary.nvim",
}

require("neogit").setup()

-- Keymaps
vim.keymap.set("n", "<leader>gg", function() require("neogit").open() end, { desc = "Neogit" })
