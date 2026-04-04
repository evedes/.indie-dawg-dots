require("config.keymaps")

-- Leader key configurations
vim.g.mapleader = " " -- Set space as the leader key
vim.g.maplocalleader = "," -- Set comma as the local leader key

vim.opt.signcolumn = "yes"

-- Line numbering settings
vim.o.relativenumber = true -- Show relative line numbers
vim.o.number = true  -- Show current line number

-- Packages
vim.pack.add {
	"https://github.com/nvim-mini/mini.files",
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/christoomey/vim-tmux-navigator"
}

-- Keymaps
vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<CR>", { desc = "Source init.lua" })
vim.keymap.set("n", "<leader>fe", function() MiniFiles.open() end, { desc = "Open mini.files" })




require("mini.files").setup({})

require("kanagawa").setup({
	theme = "dragon",
	background = {
		dark = "dragon",
		light = "lotus"
	}
})

vim.cmd.colorscheme("kanagawa")

vim.g.tmux_navigator_no_mappings = 1 -- disable default keymaps
vim.keymap.set("n", "<C-h>", "<CMD>TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-l>", "<CMD>TmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-k>", "<CMD>TmuxNavigateUp<CR>")
vim.keymap.set("n", "<C-j>", "<CMD>TmuxNavigateDown<CR>")
