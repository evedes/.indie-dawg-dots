-- Install with: npm i -g @vue/language-server

---@type vim.lsp.Config
return {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json", "vue.config.js", "nuxt.config.js", "nuxt.config.ts", ".git" },
  init_options = {
    typescript = {
      tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
    },
    vue = {
      hybridMode = false,
    },
  },
  settings = {
    vue = {
      complete = {
        casing = {
          props = "camel",
          tags = "kebab",
        },
      },
      updateImportsOnFileMove = {
        enabled = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Volar 2.0 has renamed the language server to @vue/language-server and has some breaking changes
    -- Disable semantic tokens by Volar to avoid conflicts with tree-sitter highlighting
    client.server_capabilities.semanticTokensProvider = nil
  end,
}