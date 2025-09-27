return {
  "supermaven-inc/supermaven-nvim",
  enabled = true,
  event = { "InsertEnter", "BufReadPost" },
  cmd = {
    "SupermavenStart",
    "SupermavenStop",
    "SupermavenRestart",
    "SupermavenToggle",
    "SupermavenStatus",
    "SupermavenUseFree",
    "SupermavenUsePro",
    "SupermavenLogout",
    "SupermavenShowLog",
    "SupermavenClearLog",
  },
  opts = {
    keymaps = {
      accept_suggestion = "<C-l>",
      clear_suggestion = "<C-k>",
      accept_word = "<C-j>",
    },
    ignore_filetypes = { cpp = true }, -- Add any filetypes to ignore
    color = {
      suggestion_color = "#ffffff",
      cterm = 244,
    },
    disable_inline_completion = false, -- Show inline completions
    disable_keymaps = false, -- Use the keymaps defined above
    log_level = "info", -- Add logging for debugging
  },
}
