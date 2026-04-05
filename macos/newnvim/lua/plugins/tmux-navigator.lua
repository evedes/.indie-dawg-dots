vim.pack.add {
	"https://github.com/christoomey/vim-tmux-navigator",
}

-- Keymaps
vim.keymap.set("n", "<C-h>", "<CMD>TmuxNavigateLeft<CR>", { desc = "Tmux navigate left" })
vim.keymap.set("n", "<C-j>", "<CMD>TmuxNavigateDown<CR>", { desc = "Tmux navigate down" })
vim.keymap.set("n", "<C-k>", "<CMD>TmuxNavigateUp<CR>", { desc = "Tmux navigate up" })
vim.keymap.set("n", "<C-l>", "<CMD>TmuxNavigateRight<CR>", { desc = "Tmux navigate right" })
