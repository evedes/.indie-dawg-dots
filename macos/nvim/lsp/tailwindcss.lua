-- Install with: npm i -g @tailwindcss/language-server

---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { 
    "html", "css", "scss", "javascript", "javascriptreact", 
    "typescript", "typescriptreact", "vue", "svelte", "astro"
  },
  root_markers = { 
    "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", 
    "tailwind.config.ts", "postcss.config.js", "postcss.config.cjs",
    "package.json", ".git"
  },
  settings = {
    tailwindCSS = {
      validate = true,
      classAttributes = { "class", "className", "classList", "ngClass" },
      experimental = {
        classRegex = {
          { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
      includeLanguages = {
        typescript = "javascript",
        typescriptreact = "javascript",
      },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning",
      },
    },
  },
}