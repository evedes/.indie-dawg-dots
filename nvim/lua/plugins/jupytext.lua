-- Edit .ipynb notebooks as plain-text Python percent files (`# %%` cell
-- markers), so LSP, completion, and formatting all work on the cells. Saving
-- converts back to .ipynb transparently.
--
-- Requires the `jupytext` CLI:
--   pipx install jupytext   (or: uv tool install jupytext / pip install jupytext)
vim.pack.add({
  "https://github.com/GCBallesteros/jupytext.nvim",
})

require("jupytext").setup({
  -- "percent" keeps the buffer as a real Python file with `# %%` cell markers,
  -- which molten's run-cell mapping (<leader>jr) relies on.
  style = "percent",
  output_extension = "auto",
  force_ft = nil,
})
