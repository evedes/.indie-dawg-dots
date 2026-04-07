vim.pack.add {
	"https://github.com/folke/which-key.nvim",
}

require("which-key").setup({
	preset = "modern",
	delay = 500,
	icons = {
		mappings = false,
	},
})

require("which-key").add({
	-- Leader groups
	{ "<leader>b", group = "Buffers" },
	{ "<leader>c", group = "Code" },
	{ "<leader>e", group = "Explorer" },
	{ "<leader>f", group = "Find" },
	{ "<leader>g", group = "Git" },
	{ "<leader>k", group = "Close" },
	{ "<leader>m", group = "Markdown" },
	{ "<leader>o", group = "Obsidian" },
	{ "<leader>s", group = "Splits" },
	{ "<leader>u", group = "Toggle" },
	{ "<leader>x", group = "Quickfix" },

	-- LSP namespace (Neovim 0.12 built-in defaults under `gr`)
	{ "gr", group = "LSP" },
})
