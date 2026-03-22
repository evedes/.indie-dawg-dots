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
  config = function()
    require("nvim-treesitter").setup()

    -- Enable treesitter highlighting for all buffers
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
