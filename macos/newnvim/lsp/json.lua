-- Install with: npm i -g vscode-langservers-extracted

---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git" },
  settings = {
    json = {
      validate = { enable = true },
    },
  },
}
