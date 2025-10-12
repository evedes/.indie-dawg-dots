return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Enable bigfile handling
    bigfile = { enabled = true },

    -- Configure notifier
    notifier = {
      enabled = true,
      timeout = 3000,
    },

    -- Configure quickfile
    quickfile = { enabled = true },

    -- Configure statuscolumn
    statuscolumn = { enabled = true },

    -- Configure words (highlight word under cursor)
    words = { enabled = true },

    -- Configure styles for consistent UI
    styles = {
      notification = {
        wo = { wrap = true },
      },
    },

    -- Configure explorer (replaces mini.files)
    explorer = {
      enabled = true,
      -- Show hidden files and untracked git files
      filters = {
        hidden = false,
        git = false,
      },
      -- Exclude common unnecessary directories and files
      exclude = {
        "node_modules",
        ".git",
        ".cache",
        "__pycache__",
        "*.pyc",
        ".DS_Store",
        "thumbs.db",
        ".tmp",
        ".temp",
        "dist",
        "build",
        "target",
        ".next",
        ".nuxt",
        ".output",
        ".vercel",
        ".turbo",
      },
    },

    -- Configure picker (replaces mini.pick)
    picker = {
      enabled = true,
      -- Use "ivy" layout preset for a compact bottom picker
      layout = "ivy",
      -- Show hidden files and untracked git files by default
      sources = {
        files = {
          hidden = true,
          follow = true,
        },
        grep = {
          hidden = true,
        },
      },
      -- Custom keymaps for the picker
      win = {
        input = {
          keys = {
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-k>"] = { "list_up", mode = { "i", "n" } },
          },
        },
      },
    },
  },

  keys = {
    -- Explorer keymaps
    {
      "<leader>fe",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer",
    },
    {
      "<leader>ee",
      function()
        Snacks.explorer({ cwd = vim.fn.expand("%:p:h") })
      end,
      desc = "Current File",
    },

    -- Picker keymaps
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>bb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help",
    },
    {
      "<leader>cc",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },

    -- Git-related pickers
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gc",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },

    -- Additional useful pickers
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for convenience
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd
      end,
    })
  end,
}
