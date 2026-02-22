return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        top_down = false,
      },
    },
  },
  keys = {
    { "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "Dismiss notifications" },
  },
  opts = {
    lsp = {
      -- Override markdown rendering so that cmp and other plugins use Treesitter
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      -- Disable LSP progress as you already have mini.nvim
      progress = {
        enabled = false,
      },
    },
    -- Presets for easier configuration
    presets = {
      bottom_search = true, -- Use a classic bottom cmdline for search
      command_palette = true, -- Position the cmdline and popupmenu together
      long_message_to_split = true, -- Long messages will be sent to a split
      inc_rename = false, -- Disable inc-rename preset
      lsp_doc_border = true, -- Add a border to hover docs and signature help
    },
    cmdline = {
      enabled = true,
      view = "cmdline_popup", -- Modern floating popup for commands
      format = {
        cmdline = { pattern = "^:", icon = "  ", lang = "vim", title = " Command " },
        search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex", title = " Search " },
        search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex", title = " Search " },
        filter = { pattern = "^:%s*!", icon = " $ ", lang = "bash", title = " Shell " },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "  ", lang = "lua", title = " Lua " },
        help = { pattern = "^:%s*he?l?p?%s+", icon = " 󰋖 ", title = " Help " },
      },
    },
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },
    popupmenu = {
      enabled = true,
      backend = "nui", -- Use nui for better looking popup menu
    },
    views = {
      cmdline_popup = {
        position = {
          row = "40%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        filter_options = {},
        win_options = {
          winhighlight = {
            Normal = "Normal",
            FloatBorder = "DiagnosticInfo",
            IncSearch = "",
            Search = "",
          },
          cursorline = false,
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "Normal",
            FloatBorder = "DiagnosticInfo",
          },
        },
      },
    },
    routes = {
      -- Hide written messages
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      -- Hide search messages
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
    },
  },
}