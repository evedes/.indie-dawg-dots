vim.pack.add {
	"https://github.com/supermaven-inc/supermaven-nvim",
}

require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<C-l>",
		clear_suggestion = "<C-]>",
		accept_word = "<C-f>",
	},
	ignore_filetypes = { cpp = true },
	color = {
		suggestion_color = "#ffffff",
	},
	disable_inline_completion = false,
	disable_keymaps = false,
	log_level = "info",
})
