-- Install with: npm i -g add yaml-language-server

---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      schemastore = { enable = true },
    },
  },
}
