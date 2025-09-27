-- Install with: npm i -g emmet-ls

---@type vim.lsp.Config
return {
  cmd = { "emmet-ls", "--stdio" },
  filetypes = {
    "html", "css", "scss", "sass", "less",
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "vue", "svelte", "astro", "xml", "xsl", "pug", "slim", "haml"
  },
  root_markers = { ".git", "package.json" },
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true,
        ["output.indent"] = "  ",
        ["output.selfClosingStyle"] = "html",
      },
    },
    css = {
      options = {
        ["css.fuzzySearchMinScore"] = 0.3,
      },
    },
  },
}