-- Ruff's built-in language server (ruff >= 0.5.3): linting + code actions +
-- import organization. Formatting is done via conform (ruff_format) — see
-- lua/plugins/conform.lua.
--
-- Install with
-- mac:  brew install ruff
-- Arch: sudo pacman -S ruff
-- any:  pipx install ruff   (or: uv tool install ruff)

---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  -- Let basedpyright own hover/completion; ruff only contributes lint
  -- diagnostics and code actions.
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
