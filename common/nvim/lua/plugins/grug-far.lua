return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        require("grug-far").open({ transient = false })
      end,
      desc = "Search and Replace (GrugFar)",
    },
    {
      "<leader>sw",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      desc = "Search word under cursor",
    },
    {
      "<leader>sf",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Search in current file",
    },
    {
      "<leader>sr",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.getreg("/") } })
      end,
      mode = { "n", "v" },
      desc = "Search last search pattern",
    },
  },
  opts = {
    headerMaxWidth = 80,
    icons = {
      enabled = true,
    },
    keymaps = {
      replace = "<C-r>",
      qflist = "<C-q>",
      syncLocations = "<C-s>",
      syncLine = "<C-l>",
      close = "<C-c>",
      historyOpen = "<C-h>",
      historyAdd = "<C-a>",
      refresh = "<C-f>",
      openLocation = "<CR>",
      gotoLocation = "<C-g>",
      pickHistoryEntry = "<CR>",
      abort = "<C-b>",
      help = "?",
      toggleShowCommand = "<C-p>",
    },
    startInInsertMode = false,
    transient = false,
    wraparound = true,
    engineConfig = {
      ripgrep = {
        placeholders = {
          enabled = true,
        },
      },
    },
  },
}