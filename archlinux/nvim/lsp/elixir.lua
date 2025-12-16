-- Install with
-- Arch: yay -S elixir-ls
-- macOS: brew install elixir-ls
-- Or via Mason: :MasonInstall elixir-ls

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
