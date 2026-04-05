-- Install with: npm i -g vscode-langservers-extracted

---@type vim.lsp.Config
return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
  init_options = {
    embeddedLanguages = { css = true, javascript = true },
  },
}
