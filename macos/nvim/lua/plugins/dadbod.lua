vim.pack.add {
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
}

vim.g.db_ui_use_nerd_fonts = 1

vim.keymap.set("n", "<leader>D", "<cmd>DBUI<cr>", { desc = "Dadbod UI" })
