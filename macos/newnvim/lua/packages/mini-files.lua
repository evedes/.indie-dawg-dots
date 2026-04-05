vim.pack.add({
	"https://github.com/nvim-mini/mini.files",
})
require("mini.files").setup()

vim.keymap.set("n", "<leader>fe", function()
	MiniFiles.open()
end, { desc = "File explorer" })
vim.keymap.set("n", "<leader>ee", function()
	MiniFiles.open(vim.fn.expand("%:p:h"))
end, { desc = "Explorer at current file" })

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		vim.keymap.set("n", "<Esc>", require("mini.files").close, { buffer = args.data.buf_id })
	end,
})
