vim.pack.add {
	"https://github.com/lewis6991/gitsigns.nvim",
}

require("gitsigns").setup()

-- Keymaps
local gs = require("gitsigns")

vim.keymap.set("n", "]h", function() gs.nav_hunk("next") end, { desc = "Next hunk" })
vim.keymap.set("n", "[h", function() gs.nav_hunk("prev") end, { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
