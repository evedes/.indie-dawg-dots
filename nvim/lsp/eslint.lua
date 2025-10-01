-- Install with: npm i -g vscode-langservers-extracted

---@type vim.lsp.Config
return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "graphql" },
  root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs", "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs" },
  -- Only attach if ESLint is actually present in the project
  on_attach = function(client, bufnr)
    -- Check if ESLint config exists
    local root_dir = client.config.root_dir
    if not root_dir then
      vim.schedule(function()
        vim.lsp.stop_client(client.id)
      end)
      return
    end

    local has_eslint_config = vim.fs.find({
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.json",
      ".eslintrc.cjs",
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
    }, { path = root_dir, upward = false })[1]

    if not has_eslint_config then
      vim.schedule(function()
        vim.lsp.stop_client(client.id)
      end)
    end
  end,
  settings = {
    validate = "on",
    packageManager = nil,
    useESLintClass = false,
    experimental = { useFlatConfig = false },
    codeActionOnSave = { enable = false, mode = "all" },
    format = false,
    quiet = false,
    onIgnoredFiles = "off",
    options = {},
    rulesCustomizations = {},
    run = "onType",
    problems = { shortenToSingleLine = false },
    nodePath = "",
    workingDirectory = { mode = "location" },
    codeAction = {
      disableRuleComment = { enable = true, location = "separateLine" },
      showDocumentation = { enable = true },
    },
  },
  before_init = function(params, config)
    -- Set the workspace folder setting for correct search of tsconfig.json files etc.
    config.settings.workspaceFolder = {
      uri = params.rootPath,
      name = vim.fn.fnamemodify(params.rootPath, ":t"),
    }
  end,
  ---@type table<string, lsp.Handler>
  handlers = {
    ["eslint/openDoc"] = function(_, params)
      vim.ui.open(params.url)
      return {}
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("LSP[eslint]: Probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("LSP[eslint]: Unable to load ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
}
