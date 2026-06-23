-- Deferred: nvim-ts-autotag only matters in markup/web buffers, so load it on
-- the first one. After setup() runs, autotag's own Filetype/InsertEnter
-- autocmds attach the buffer (InsertEnter fires the moment you start typing a
-- tag in the buffer that triggered loading).
require("util.lazy").on_filetype({
  "html",
  "xml",
  "xhtml",
  "markdown",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "svelte",
  "astro",
  "php",
  "eruby",
  "htmldjango",
  "htmlangular",
  "handlebars",
  "hbs",
  "glimmer",
  "templ",
  "liquid",
  "twig",
  "blade",
  "heex",
}, function()
  vim.pack.add({
    "https://github.com/windwp/nvim-ts-autotag",
  })

  require("nvim-ts-autotag").setup()
end)
