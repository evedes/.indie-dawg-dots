vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("auto-format", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Completely disable native completion and omnifunc
vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter" }, {
  desc = "Disable native completion and omnifunc",
  group = vim.api.nvim_create_augroup("disable-native-completion", { clear = true }),
  callback = function()
    vim.bo.omnifunc = ""
    vim.bo.completefunc = ""
    vim.bo.tagfunc = ""
    vim.opt_local.complete = ""
  end,
})


-- Disable CSS LSP diagnostics for Waybar and other GTK CSS files
-- (GTK CSS uses @define-color and other extensions not recognized by standard CSS LSP)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Disable CSS LSP diagnostics for GTK CSS files (waybar, etc.)",
  group = vim.api.nvim_create_augroup("disable-css-lsp-gtk", { clear = true }),
  pattern = { "*/waybar/*.css", "*/gtk-*/*.css", "*/.config/gtk-*/*.css" },
  callback = function(ev)
    vim.defer_fn(function()
      -- Disable diagnostics from CSS language server for this buffer
      vim.diagnostic.enable(false, { bufnr = ev.buf })
    end, 100)
  end,
})
