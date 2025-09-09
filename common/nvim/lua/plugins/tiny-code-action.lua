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
      picker = {
        "buffer",
        opts = {
          hotkeys = true,
          -- Use numeric labels.
          hotkeys_mode = function(titles)
            return vim
              .iter(ipairs(titles))
              :map(function(i)
                return tostring(i)
              end)
              :totable()
          end,
          keymap = {
            ["<C-k>"] = "prev_item",
            ["<C-j>"] = "next_item",
          },
        },
      },
    },
  },
}
