vim.pack.add {
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
}

require("nvim-treesitter").install({
	"bash",
	"c",
	"css",
	"clojure",
	"dockerfile",
	"eex",
	"elixir",
	"heex",
	"surface",
	"git_config",
	"gitcommit",
	"git_rebase",
	"gitattributes",
	"gitignore",
	"go",
	"html",
	"jsdoc",
	"json",
	"json5",
	"javascript",
	"lua",
	"markdown",
	"markdown_inline",
	"prisma",
	"python",
	"query",
	"regex",
	"ruby",
	"rust",
	"scss",
	"slim",
	"tmux",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"vue",
	"yaml",
})

require("treesitter-context").setup({
	max_lines = 3,
	multiline_threshold = 1,
	min_window_height = 20,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Keymaps
vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		require("treesitter-context").go_to_context()
	end
end, { desc = "Jump to upper context" })
