-- Role: in-editor Markdown rendering (headings, lists, tables, code, links).
-- Owns how Markdown *looks* while editing; navigation is mkdnflow, browser
-- preview is markdown-preview. (See CLAUDE.md → "Markdown Workflow".)
vim.pack.add({
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  -- Keep markup visible while typing, and render it in normal/command mode.
  render_modes = { "n", "c" },
  pipe_table = {
    -- Unlike Markview, this can wrap cells while preserving the table layout.
    preset = "round",
    cell = "padded",
    wrap = true,
    border_enabled = true,
  },
})

vim.keymap.set("n", "<leader>mt", "<CMD>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown rendering" })
