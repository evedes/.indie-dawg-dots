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

-- jupytext.nvim only converts on BufReadCmd, i.e. files that already exist on
-- disk — `nvim new.ipynb` would open an empty buffer that isn't valid notebook
-- JSON. :NewNotebook writes a minimal skeleton first, then opens it through
-- the normal conversion pipeline.
local default_notebook = [[
{
  "cells": [
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "outputs": [],
      "source": []
    }
  ],
  "metadata": {
    "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
    },
    "language_info": {
      "name": "python"
    }
  },
  "nbformat": 4,
  "nbformat_minor": 5
}
]]

vim.api.nvim_create_user_command("NewNotebook", function(opts)
  local path = opts.args
  if not path:match("%.ipynb$") then
    path = path .. ".ipynb"
  end
  if vim.fn.filereadable(path) == 1 then
    vim.notify("NewNotebook: " .. path .. " already exists", vim.log.levels.ERROR)
    return
  end
  local file = io.open(path, "w")
  if not file then
    vim.notify("NewNotebook: cannot write " .. path, vim.log.levels.ERROR)
    return
  end
  file:write(default_notebook)
  file:close()
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end, {
  nargs = 1,
  complete = "file",
  desc = "Create a new .ipynb and open it as percent cells",
})
