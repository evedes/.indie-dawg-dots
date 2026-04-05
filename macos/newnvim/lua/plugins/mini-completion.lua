vim.pack.add {
	"https://github.com/nvim-mini/mini.completion",
}

require("mini.completion").setup({
	delay = { completion = 100, info = 100, signature = 50 },
	window = {
		info = { border = "rounded" },
		signature = { border = "rounded" },
	},
	lsp_completion = {
		source_func = "omnifunc",
		auto_setup = true,
	},
})

-- Use <Tab>/<S-Tab> to navigate completion menu
vim.keymap.set("i", "<Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, desc = "Next completion" })

vim.keymap.set("i", "<S-Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true, desc = "Previous completion" })
