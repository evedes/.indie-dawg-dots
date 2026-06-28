-- Role: inline working-tree overlay rendered in the buffer. Use to see
-- line-level changes overlaid on the file; per-hunk ops are gitsigns.
-- (See CLAUDE.md → "Git Workflow".)
vim.pack.add({
  "https://github.com/nvim-mini/mini.diff",
})

require("mini.diff").setup()

-- Keymaps
vim.keymap.set("n", "<leader>go", function()
  MiniDiff.toggle_overlay()
end, { desc = "Toggle diff overlay" })
