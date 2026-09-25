-- Aligned table view for csv/tsv buffers. Renders columns with virtual-text
-- padding and separators; the file's bytes are never touched.
--
-- Loaded on demand rather than at startup, but deliberately NOT via
-- util.lazy.on_filetype: that helper is one-shot, so a failed load (or a first
-- csv buffer that appears in an odd context) would leave the :CsvView*
-- commands permanently missing. A persistent FileType autocmd plus a load
-- guard costs nothing and always recovers.

local loaded = false

--- Install + setup csvview on first use. Returns false (and notifies) on
--- failure, so callers can bail instead of erroring on a missing command.
local function load()
  if loaded then
    return true
  end

  local ok, err = pcall(function()
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
  end)

  if not ok then
    vim.notify("csvview: failed to load: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end

  loaded = true
  return true
end

-- Auto-enable for every csv/tsv buffer. vim.schedule because filetype
-- detection runs inside a `vim._with` textlock, where vim.pack.add's
-- runtimepath changes and file sourcing are disallowed.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "tsv" },
  callback = function(ev)
    vim.schedule(function()
      if not (load() and vim.api.nvim_buf_is_valid(ev.buf)) then
        return
      end
      vim.api.nvim_buf_call(ev.buf, function()
        vim.cmd("CsvViewEnable")
      end)
    end)
  end,
})

-- Works from any buffer, loading csvview on first press, so the toggle is never
-- a missing command.
vim.keymap.set("n", "<leader>uc", function()
  if load() then
    vim.cmd("CsvViewToggle")
  end
end, { desc = "Toggle CSV table view" })
