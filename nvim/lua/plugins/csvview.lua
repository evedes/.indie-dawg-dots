-- Deferred: csvview only matters in csv/tsv buffers. Renders delimited files as
-- an aligned table (virtual-text padding + column borders) without touching the
-- file's bytes, plus a sticky header row and field textobjects.
require("util.lazy").on_filetype({ "csv", "tsv" }, function(ev)
  vim.pack.add({
    "https://github.com/hat0uma/csvview.nvim",
  })

  require("csvview").setup({
    parser = {
      comments = { "#", "//" },
    },
    view = {
      -- "border" draws real column separators; "highlight" only tints fields.
      display_mode = "border",
      header_lnum = 1,
      sticky_header = { enabled = true },
    },
    keymaps = {
      -- Field textobjects: `if` inner field, `af` field + delimiter.
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      -- Tab/S-Tab move by column, Enter/S-Enter by row.
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      jump_next_row = { "<Enter>", mode = { "n", "v" } },
      jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
    },
  })

  vim.keymap.set("n", "<leader>uc", "<Cmd>CsvViewToggle<CR>", { desc = "Toggle CSV table view" })

  -- Auto-enable for every csv/tsv buffer opened from here on...
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "csv", "tsv" },
    callback = function(a)
      vim.api.nvim_buf_call(a.buf, function()
        vim.cmd("CsvViewEnable")
      end)
    end,
  })

  -- ...and for the buffer that triggered this load (its FileType already fired).
  if ev and vim.api.nvim_buf_is_valid(ev.buf) then
    vim.api.nvim_buf_call(ev.buf, function()
      vim.cmd("CsvViewEnable")
    end)
  end
end)
