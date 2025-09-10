-- Install with: npm i -g @vue/language-server typescript

---@type vim.lsp.Config
return {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json", "vue.config.js", "nuxt.config.js", "nuxt.config.ts", "vite.config.js", "vite.config.ts", ".git" },
  init_options = {
    typescript = {
      -- Use the TypeScript version from @vue/language-server installation
      tsdk = "/opt/homebrew/lib/node_modules/@vue/language-server/node_modules/typescript/lib",
    },
    vue = {
      hybridMode = false,
    },
    languageFeatures = {
      implementation = true,
      references = true,
      definition = true,
      typeDefinition = true,
      callHierarchy = true,
      hover = true,
      rename = true,
      renameFileRefactoring = true,
      signatureHelp = true,
      codeAction = true,
      workspaceSymbol = true,
      completion = {
        defaultTagNameCase = "kebab",
        defaultAttrNameCase = "kebab",
        getDocumentNameCasesRequest = false,
        getDocumentSelectionRequest = false,
      },
      schemaRequestService = {
        getDocumentContentRequest = false,
      },
    },
  },
  settings = {
    typescript = {
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
      suggest = {
        autoImports = true,
        completeFunctionCalls = true,
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        includeCompletionsWithSnippetText = true,
        includeAutomaticOptionalChainCompletions = true,
      },
      preferences = {
        importModuleSpecifier = "shortest",
        preferTypeOnlyAutoImports = false,
        includePackageJsonAutoImports = "auto",
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
      format = {
        enable = false, -- We use prettier
      },
    },
    javascript = {
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
      suggest = {
        autoImports = true,
        completeFunctionCalls = true,
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        includeCompletionsWithSnippetText = true,
        includeAutomaticOptionalChainCompletions = true,
      },
      preferences = {
        importModuleSpecifier = "shortest",
        includePackageJsonAutoImports = "auto",
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
      format = {
        enable = false, -- We use prettier
      },
    },
    vue = {
      autoInsert = {
        dotValue = true,
        bracketSpacing = true,
        parentheses = true,
      },
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
    volar = {
      autoCompleteRefs = true,
      codeLens = {
        references = true,
        pugTools = true,
        scriptSetupTools = true,
      },
      completion = {
        autoImportComponent = true,
        preferredTagNameCase = "kebab",
        preferredAttrNameCase = "kebab",
      },
      takeOverMode = {
        enabled = false, -- We're using vtsls for TS files
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Don't let Volar handle formatting, we use Prettier
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}