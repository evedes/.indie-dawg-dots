-- Jupyter kernel integration: run code cells against a live kernel and show
-- outputs (text + plots/images) inline in the buffer. Pairs with:
--   * jupytext.nvim — edit .ipynb as `# %%` percent cells (lua/plugins/jupytext.lua)
--   * image.nvim    — render image/plot outputs in the terminal (lua/plugins/image.lua)
--
-- Molten is a Neovim *remote* (Python) plugin. ONE-TIME setup after install:
--   1. Homebrew's python3 is PEP 668 externally-managed and can't host pynvim,
--      so give Neovim a dedicated venv (config/options.lua points
--      g:python3_host_prog at ~/.venvs/neovim/bin/python):
--        python3 -m venv ~/.venvs/neovim
--        ~/.venvs/neovim/bin/pip install pynvim jupyter_client ipykernel
--   2. Install the kernel spec from that venv, e.g.:
--        ~/.venvs/neovim/bin/python -m ipykernel install --user
--   3. Run `:UpdateRemotePlugins` and RESTART nvim — this registers the
--      :Molten* commands (they won't exist until you do).
--
-- See nvim/CLAUDE.md → "Python & Jupyter" and `:checkhealth dotfiles`.
vim.pack.add({
  "https://github.com/benlubas/molten-nvim",
})

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20
vim.g.molten_wrap_output = true
-- Output display: use the bordered output *window* (auto-opens on the focused
-- cell) rather than compact virtual text. output_virt_lines pads the buffer so
-- the framed window sits between cells instead of covering the code below.
-- Trade-off: the window shows one cell at a time (the one under the cursor);
-- <leader>jt (MoltenToggleVirtual) flips on the compact all-cells-at-once view.
vim.g.molten_auto_open_output = true
vim.g.molten_output_virt_lines = true
vim.g.molten_virt_text_output = false
vim.g.molten_virt_lines_off_by_1 = true

-- Find the [from, to] line range of the `# %%` percent-cell the cursor is in,
-- plus the line of the next marker (0 if this is the last cell).
local function cell_range()
  local from = vim.fn.search("^# %%", "bcnW")
  from = (from == 0) and 1 or from
  local nxt = vim.fn.search("^# %%", "nW")
  local to = (nxt == 0) and vim.fn.line("$") or (nxt - 1)
  return from, to, nxt
end

-- Evaluate the current `# %%` cell by selecting its range and handing it to
-- MoltenEvaluateVisual (Molten has no native "run this cell" for arbitrary
-- percent files). With `advance`, move to the next cell (Jupyter's Shift+Enter);
-- otherwise restore the cursor so the cell runs in place.
local function run_cell(advance)
  local save = vim.api.nvim_win_get_cursor(0)
  local from, _to, nxt = cell_range()
  vim.api.nvim_win_set_cursor(0, { from, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { _to, 0 })
  vim.cmd("normal! \27") -- <Esc>: leave visual mode so the '< and '> marks are set
  vim.cmd("MoltenEvaluateVisual")
  if advance and nxt ~= 0 then
    vim.api.nvim_win_set_cursor(0, { nxt, 0 })
  else
    vim.api.nvim_win_set_cursor(0, save)
  end
end

-- Buffer-local Molten keymaps for Python / notebook buffers only, so <leader>j
-- stays clean elsewhere.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function(args)
    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, desc = desc, silent = true })
    end
    map("<leader>ji", "<Cmd>MoltenInit<CR>", "Init kernel")
    map("<leader>jr", function()
      run_cell(false)
    end, "Run cell (in place)")
    map("<leader>jj", function()
      run_cell(true)
    end, "Run cell + advance")
    map("<leader>jl", "<Cmd>MoltenEvaluateLine<CR>", "Run line")
    map("<leader>jv", ":<C-u>MoltenEvaluateVisual<CR>gv", "Run selection", "v")
    map("<leader>je", "<Cmd>MoltenEvaluateOperator<CR>", "Run (operator)")
    map("<leader>jc", "<Cmd>MoltenReevaluateCell<CR>", "Re-run cell")
    map("<leader>jo", "<Cmd>MoltenEnterOutput<CR>", "Enter output (scroll)")
    map("<leader>jt", "<Cmd>MoltenToggleVirtual!<CR>", "Toggle inline output (all cells)")
    map("<leader>jd", "<Cmd>MoltenDelete<CR>", "Delete cell")
    map("<leader>jx", "<Cmd>MoltenInterrupt<CR>", "Interrupt kernel")
    map("<leader>jR", "<Cmd>MoltenRestart<CR>", "Restart kernel")
    map("<leader>jb", "<Cmd>MoltenOpenInBrowser<CR>", "Open output in browser")
    map("<leader>jE", "<Cmd>MoltenExportOutput<CR>", "Export outputs to .ipynb")
    map("<leader>jI", "<Cmd>MoltenImportOutput<CR>", "Import outputs from .ipynb")
  end,
})
