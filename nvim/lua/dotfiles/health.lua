-- Health check for the external tools this config expects.
-- Run with `:checkhealth dotfiles` (or the `:DotfilesHealth` command).
-- Install anything missing with `nvim/scripts/nvim-doctor install`.

local M = {}

-- Keep this list in sync with `nvim/scripts/nvim-doctor`.
-- `bin` is the executable probed with vim.fn.executable().
local groups = {
  {
    name = "LSP servers",
    tools = {
      { bin = "vtsls", desc = "TypeScript/JavaScript (vtsls)" },
      { bin = "vue-language-server", desc = "Vue (volar)" },
      { bin = "lua-language-server", desc = "Lua" },
      { bin = "bash-language-server", desc = "Bash" },
      { bin = "vscode-eslint-language-server", desc = "ESLint" },
      { bin = "vscode-css-language-server", desc = "CSS" },
      { bin = "vscode-html-language-server", desc = "HTML" },
      { bin = "vscode-json-language-server", desc = "JSON" },
      { bin = "yaml-language-server", desc = "YAML" },
      { bin = "tailwindcss-language-server", desc = "Tailwind CSS" },
      { bin = "emmet-ls", desc = "Emmet" },
      { bin = "stylelint-lsp", desc = "Stylelint" },
      { bin = "rust-analyzer", desc = "Rust" },
      { bin = "clangd", desc = "C/C++" },
      { bin = "elixir-ls", desc = "Elixir" },
      { bin = "dprint", desc = "dprint LSP (json/graphql)" },
    },
  },
  {
    name = "Formatters",
    tools = {
      { bin = "stylua", desc = "Lua formatter" },
      { bin = "prettier", desc = "JS/TS/CSS/HTML formatter" },
      { bin = "shfmt", desc = "Shell formatter" },
      { bin = "rustfmt", desc = "Rust formatter" },
      { bin = "mix", desc = "Elixir formatter (mix format)" },
    },
  },
  {
    name = "CLI tools",
    tools = {
      { bin = "rg", desc = "ripgrep (picker grep)" },
      { bin = "fd", desc = "fd (file finding)" },
      { bin = "git", desc = "git (plugin fetching)" },
    },
  },
}

function M.check()
  local health = vim.health

  -- Neovim version: vim.pack.add requires 0.12+.
  health.start("Neovim")
  if vim.fn.has("nvim-0.12") == 1 then
    health.ok("Neovim " .. tostring(vim.version()))
  else
    health.error("Neovim 0.12+ required for vim.pack.add (found " .. tostring(vim.version()) .. ")")
  end

  local missing = 0
  for _, group in ipairs(groups) do
    health.start(group.name)
    for _, tool in ipairs(group.tools) do
      if vim.fn.executable(tool.bin) == 1 then
        health.ok(string.format("%-32s %s", tool.bin, tool.desc))
      else
        missing = missing + 1
        health.warn(string.format("%-32s %s", tool.bin, "MISSING — " .. tool.desc))
      end
    end
  end

  health.start("Summary")
  if missing == 0 then
    health.ok("All expected tools are installed")
  else
    health.warn(missing .. " tool(s) missing — run `nvim/scripts/nvim-doctor install` to install them")
  end
end

return M
