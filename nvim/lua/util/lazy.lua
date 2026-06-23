-- Helpers for deferring plugin load until a relevant buffer is opened, without
-- adopting a plugin manager. Native vim.pack only needs a FileType autocmd.

local M = {}

--- Run `load(ev)` once, the first time a buffer whose filetype matches
--- `filetypes` is opened. The autocmd deletes itself *before* calling `load`,
--- so the plugin is free to (re-)fire FileType during its own setup without
--- re-entering this loader.
---
--- Files opened at launch (`nvim note.md`) trigger this naturally: the autocmd
--- is registered while init.lua runs, before the buffer's filetype is set.
--- Subsequent buffers of the same type are handled by the plugin's own
--- autocmds, which it registers during `load`.
---@param filetypes string|string[]
---@param load fun(ev: table)
function M.on_filetype(filetypes, load)
  local id
  id = vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(ev)
      vim.api.nvim_del_autocmd(id)
      -- Run on the next tick: this callback can fire inside filetype-detection's
      -- textlock (`vim._with`), where vim.pack.add (runtimepath + sourcing) is
      -- not allowed. By the next tick we're out of that context.
      vim.schedule(function()
        load(ev)
      end)
    end,
  })
end

return M
