-- Role: full-file / multi-file Git review and history. Use to review a
-- changeset or file history before committing; per-hunk work is gitsigns.
-- (See CLAUDE.md → "Git Workflow".)
vim.pack.add({
  "https://github.com/sindrets/diffview.nvim",
})

require("diffview").setup()

-- Keymaps
vim.keymap.set("n", "<leader>gd", "<CMD>DiffviewOpen<CR>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gh", "<CMD>DiffviewFileHistory %<CR>", { desc = "File history" })
vim.keymap.set("n", "<leader>gx", "<CMD>DiffviewClose<CR>", { desc = "Diffview close" })
