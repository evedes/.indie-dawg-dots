vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
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

-- Custom split divider color
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Set split divider color",
  group = vim.api.nvim_create_augroup("custom-winseparator", { clear = true }),
  callback = function()
    local bg = vim.o.background
    local fg = bg == "light" and "#c8c093" or "#393836"
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = fg })
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
