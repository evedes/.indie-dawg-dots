return {
  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    keys = {
      {
        "<leader>ca",
        function()
          require("tiny-code-action").code_action()
        end,
        desc = "Code Action",
        mode = { "n", "x" },
      },
      {
        "<leader>cd",
        function()
          vim.diagnostic.open_float()
        end,
        desc = "Show Diagnostic Description",
        mode = { "n" },
      },
    },
    opts = {
      backend = "vim",
      telescope_ops = {
        layout_strategy = "vertical",
        layout_config = {
          width = 0.7,
          height = 0.9,
          preview_cutoff = 1,
          preview_height = function(_, _, max_lines)
            local h = math.floor(max_lines * 0.4)
            return math.max(h, 10)
          end,
        },
      },
    },
  },
}
