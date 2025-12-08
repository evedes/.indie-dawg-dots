-- Install with: npm i -g vscode-langservers-extracted

---@type vim.lsp.Config
return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore", -- Ignore Tailwind's @tailwind, @apply, @layer, etc.
        unknownProperties = "ignore", -- Ignore GTK CSS custom properties
        propertyIgnoredDueToDisplay = "ignore",
        compatibleVendorPrefixes = "ignore",
        vendorPrefix = "ignore",
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
        unknownProperties = "ignore",
        propertyIgnoredDueToDisplay = "ignore",
        compatibleVendorPrefixes = "ignore",
        vendorPrefix = "ignore",
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
        unknownProperties = "ignore",
        propertyIgnoredDueToDisplay = "ignore",
        compatibleVendorPrefixes = "ignore",
        vendorPrefix = "ignore",
      },
    },
  },
}
