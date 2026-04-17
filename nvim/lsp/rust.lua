-- Install rust-analyzer with:
-- mac:  brew install rust-analyzer
-- Arch: pacman -S rust-analyzer
-- or:   rustup component add rust-analyzer

---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = { enable = true },
      },
      checkOnSave = true,
      check = { command = "clippy" },
      procMacro = { enable = true },
      inlayHints = {
        parameterHints = { enable = true },
        typeHints = { enable = true },
        chainingHints = { enable = true },
      },
    },
  },
}
