return {
  "supermaven-inc/supermaven-nvim",
  enabled = true,
  lazy = false,
  priority = 1000,
  cmd = {
    "SupermavenToggle",
    "SupermavenStart",
    "SupermavenStop",
    "SupermavenRestart",
    "SupermavenStatus",
    "SupermavenUsePro",
    "SupermavenUseFree",
    "SupermavenLogout",
  },
  keys = {
    {
      "<leader>sm",
      "<cmd>SupermavenStatus<cr>",
      desc = "Supermaven Status",
    },
  },
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-l>",
        clear_suggestion = "<C-k>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { cpp = true },
      color = {
        suggestion_color = "#888888",
        cterm = 244,
      },
      log_level = "info",
      disable_inline_completion = false,
      disable_keymaps = false,
      condition = function()
        return true
      end,
    })
    vim.api.nvim_create_autocmd("BufReadPost", {
      once = true,
      callback = function()
        vim.schedule(function()
          pcall(function() vim.cmd("SupermavenStart") end)
          pcall(function() vim.cmd("SupermavenUsePro") end)
        end)
      end,
    })
  end,
}
