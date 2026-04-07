vim.pack.add {
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
}

vim.g.db_ui_use_nerd_fonts = 1

vim.keymap.set("n", "<leader>D", "<cmd>DBUI<cr>", { desc = "Dadbod UI" })

-- Close snacks explorer when DBUI opens to avoid two sidebars at once.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "dbui", "dbout" },
	callback = function()
		local ok, Snacks = pcall(require, "snacks")
		if not ok then
			return
		end
		for _, p in ipairs(Snacks.picker.get({ source = "explorer" })) do
			p:close()
		end
	end,
})
