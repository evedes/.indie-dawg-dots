vim.pack.add {
	"https://github.com/iamcco/markdown-preview.nvim",
}

-- Keymaps
vim.keymap.set("n", "<leader>mp", "<CMD>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
