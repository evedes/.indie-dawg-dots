vim.pack.add {
	"https://github.com/nvim-mini/mini.pick",
}
require("mini.pick").setup()

-- Keymaps
vim.keymap.set("n", "<leader>ff", function() MiniPick.builtin.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>/", function() MiniPick.builtin.grep_live() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>bb", function() MiniPick.builtin.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", function() MiniPick.builtin.help() end, { desc = "Help" })
vim.keymap.set("n", "<leader>cc", function() MiniPick.builtin.resume() end, { desc = "Resume last picker" })
