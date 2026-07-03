-- Install with
-- mac/Arch: pipx install basedpyright   (or: uv tool install basedpyright)
-- npm:      npm i -g basedpyright        (also works)

---@type vim.lsp.Config
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      -- ruff owns import organization (see conform + lsp/ruff.lua).
      disableOrganizeImports = true,
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        -- basedpyright defaults to the strict "recommended" mode; "standard"
        -- matches upstream pyright and avoids drowning everyday code in hints.
        typeCheckingMode = "standard",
      },
    },
  },
}
