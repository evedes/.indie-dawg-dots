-- Install with
-- mac: brew install elixir-ls
-- Arch: yay -S elixir-ls

---@type vim.lsp.Config
return {
  cmd = { "elixir-ls" },
  filetypes = { "elixir", "eelixir", "heex", "surface" },
  root_markers = { "mix.exs", ".git" },
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps = false,
      enableTestLenses = false,
      suggestSpecs = true,
    },
  },
}
