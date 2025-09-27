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
        "mini",
        opts = {
          hotkeys = true,
          -- Use alphabetic hotkeys for faster access
          hotkeys_mode = function(titles)
            local letters = "abcdefghijklmnopqrstuvwxyz"
            return vim
              .iter(ipairs(titles))
              :map(function(i)
                return letters:sub(i, i)
              end)
              :totable()
          end,
          -- Better styling
          source = {
            name = "Code Actions",
            show = function(buf_id, items)
              -- Add icons and better formatting
              local formatted_items = {}
              for i, item in ipairs(items) do
                local icon = "⚡"
                if item:match("Refactor") then icon = "🔧"
                elseif item:match("Fix") then icon = "🐛"
                elseif item:match("Import") then icon = "📥"
                elseif item:match("Extract") then icon = "📤"
                end
                formatted_items[i] = string.format("%s %s", icon, item)
              end
              return formatted_items
            end,
          },
        },
      },
    },
  },
}
