-- Multiverse vault pickers.
-- Snacks pickers scoped to the personal notes vault, usable from any cwd
-- (e.g. while coding in a project) without changing the session's directory.
-- snacks is required lazily inside each mapping because this file may load
-- before lua/plugins/snacks.lua adds snacks to the pack path.

local vault = vim.fn.expand("~/Nextcloud/Multiverse")

-- Find a note by filename.
vim.keymap.set("n", "<leader>nf", function()
  require("snacks").picker.files({ cwd = vault })
end, { desc = "Find note" })

-- Live grep across all notes.
vim.keymap.set("n", "<leader>n/", function()
  require("snacks").picker.grep({ cwd = vault })
end, { desc = "Grep notes" })

-- Recently edited notes (by mtime, so it also surfaces notes changed
-- outside Neovim — phone, sync, Obsidian, etc.).
vim.keymap.set("n", "<leader>nr", function()
  require("snacks").picker.pick({
    title = "Recent Notes",
    cwd = vault,
    format = "file",
    sort = { fields = { "score:desc", "mtime:desc", "idx" } },
    finder = function()
      local items = {}
      for _, file in ipairs(vim.fn.globpath(vault, "**/*.md", false, true)) do
        local stat = vim.uv.fs_stat(file)
        items[#items + 1] = {
          file = file,
          text = vim.fn.fnamemodify(file, ":t"),
          mtime = stat and stat.mtime.sec or 0,
        }
      end
      return items
    end,
  })
end, { desc = "Recent notes" })

-- Backlinks: grep the vault for links to the current note.
vim.keymap.set("n", "<leader>nb", function()
  local fname = vim.fn.expand("%:t")
  if fname == "" then
    vim.notify("No file name for current buffer", vim.log.levels.WARN)
    return
  end
  -- Match the filename as it appears in Markdown links, e.g. `](note-name.md)`.
  local pattern = vim.fn.escape(fname, ".")
  require("snacks").picker.grep({
    cwd = vault,
    search = pattern,
    live = false,
    title = "Backlinks: " .. fname,
  })
end, { desc = "Backlinks to current note" })
