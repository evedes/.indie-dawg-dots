vim.pack.add {
	"https://github.com/nvim-mini/mini.pick",
}
require("mini.pick").setup({
	mappings = {
		move_down = "<C-j>",
		move_up = "<C-k>",
	},
	window = {
		config = function()
			return {
				anchor = "NW",
				row = math.floor(vim.o.lines * 0.5) - 1,
				col = 0,
				width = vim.o.columns,
			}
		end,
	},
})

-- Keymaps
vim.keymap.set("n", "<leader>ff", function() MiniPick.builtin.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>/", function() MiniPick.builtin.grep_live() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>bb", function() MiniPick.builtin.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", function() MiniPick.builtin.help() end, { desc = "Help" })
vim.keymap.set("n", "<leader>cc", function() MiniPick.builtin.resume() end, { desc = "Resume last picker" })
