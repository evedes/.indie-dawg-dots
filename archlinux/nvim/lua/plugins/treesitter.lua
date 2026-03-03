return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        max_lines = 3,
        multiline_threshold = 1,
        min_window_height = 20,
      },
      keys = {
        {
          "[c",
          function()
            if vim.wo.diff then
              return "[c"
            else
              vim.schedule(function()
                require("treesitter-context").go_to_context()
              end)
              return "<Ignore>"
            end
          end,
          desc = "Jump to upper context",
          expr = true,
        },
      },
    },
  },
  version = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "css",
      "clojure",
      "dockerfile",
      "eex",
      "elixir",
      "heex",
      "git_config",
      "gitcommit",
      "git_rebase",
      "gitattributes",
      "gitignore",
      "go",
      "html",
      "jsdoc",
      "json",
      "json5",
      "javascript",
      "lua",
      "markdown",
      "markdown_inline",
      "prisma",
      "python",
      "query",
      "ruby",
      "rust",
      "scss",
      "slim",
      "tmux",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    },
  },
}
