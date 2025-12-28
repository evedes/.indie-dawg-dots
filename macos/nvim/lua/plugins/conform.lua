return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    notify_on_error = false,
    formatters = {
      prettier = {
        -- Use default Prettier config if project doesn't have one
        prepend_args = function(self, ctx)
          -- Check if fallback is enabled
          if not vim.g.prettier_fallback then
            return {}
          end

          -- Only add defaults if no config file is found
          local has_config = vim.fs.find({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.json5",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
          }, { upward = true, path = ctx.dirname })[1]

          if not has_config then
            return {
              "--print-width=100",
              "--tab-width=2",
              "--use-tabs=false",
              "--semi=true",
              "--single-quote=false",
              "--trailing-comma=es5",
              "--bracket-spacing=true",
              "--arrow-parens=always",
            }
          end
          return {}
        end,
      },
    },
    formatters_by_ft = {
      javascript = { "prettier", "dprint", lsp_format = "fallback" },
      javascriptreact = { "prettier", "dprint", lsp_format = "fallback" },
      json = { "prettier", "dprint" },
      jsonc = { "prettier", "dprint" },
      less = { "prettier" },
      lua = { "stylua" },
      -- markdown = { "prettier" },
      scss = { "prettier" },
      sh = { "shfmt" },
      typescript = { "prettier", "dprint", lsp_format = "fallback" },
      typescriptreact = { "prettier", "dprint", lsp_format = "fallback" },
      elixir = { "mix" },
      heex = { "mix" },
      vue = { "prettier" },
      -- For filetypes without a formatter:
      ["_"] = { "trim_whitespace", "trim_newlines" },
    },

    format_on_save = function(bufnr)
      -- Don't format when minifiles is open, since that triggers the "confirm without
      -- synchronization" message.
      if vim.g.minifiles_active then
        return nil
      end

      -- Check buffer-local setting first, then global setting
      local autoformat = vim.b[bufnr].autoformat
      if autoformat == nil then
        autoformat = vim.g.autoformat
      end

      -- Stop if we disabled auto-formatting
      if not autoformat then
        return nil
      end

      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  },
  init = function()
    -- Use conform for gq.
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    -- Start auto-formatting by default (and disable with my ToggleFormat command).
    vim.g.autoformat = true

    -- Enable prettier fallback defaults by default
    vim.g.prettier_fallback = true

    -- Toggle prettier fallback defaults
    vim.keymap.set("n", "<leader>up", function()
      vim.g.prettier_fallback = not vim.g.prettier_fallback
      local status = vim.g.prettier_fallback and "enabled" or "disabled"
      vim.notify("Prettier fallback defaults " .. status, vim.log.levels.INFO)
    end, { desc = "Toggle Prettier Fallback" })
  end,
}
