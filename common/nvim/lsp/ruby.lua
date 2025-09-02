-- Install with: gem install ruby-lsp
-- Alternative: gem install solargraph (older LSP server)

---@type vim.lsp.Config
return {
  cmd = { "ruby-lsp" },
  filetypes = { "ruby", "eruby" },
  root_markers = { "Gemfile", ".git", "Rakefile", "Gemfile.lock" },
  settings = {
    rubyLsp = {
      enabledFeatures = {
        codeActions = true,
        codeLens = true,
        completion = true,
        definition = true,
        diagnostics = true,
        documentHighlight = true,
        documentLink = true,
        documentSymbol = true,
        foldingRange = true,
        formatting = true,
        hover = true,
        inlayHint = true,
        onTypeFormatting = true,
        references = true,
        rename = true,
        selectionRange = true,
        semanticHighlighting = true,
        signatureHelp = true,
        typeHierarchy = true,
        workspaceSymbol = true,
      },
      featuresConfiguration = {
        inlayHint = {
          enableAll = false,
          implicitHashValue = false,
          implicitRescue = false,
        },
      },
    },
  },
}

