return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  event = "InsertEnter",
  priority = 1000,  -- Load before other plugins
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "default",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-d>"] = { "show_documentation", "hide_documentation" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    appearance = {
      nerd_font_variant = "normal",
      use_nvim_cmp_as_default = true,
      kind_icons = {
        Text = "󰉿",
        Method = "󰊕",
        Function = "󰊕",
        Constructor = "󰒓",
        Field = "󰜢",
        Variable = "󰆦",
        Property = "󰖷",
        Class = "󱡠",
        Interface = "󱡠",
        Struct = "󱡠",
        Module = "󰅩",
        Unit = "󰪚",
        Value = "󰦨",
        Enum = "󰦨",
        EnumMember = "󰦨",
        Keyword = "󰻾",
        Constant = "󰏿",
        Snippet = "󱄽",
        Color = "󰏘",
        File = "󰈔",
        Reference = "󰬲",
        Folder = "󰉋",
        Event = "󱐋",
        Operator = "󰪚",
        TypeParameter = "󰬛",
      },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      trigger = {
        signature_help = { enabled = true },
        show_on_insert_on_trigger_character = true,
      },
      list = {
        max_items = 200,
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
      menu = {
        auto_show = true,
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
          },
        },
      },
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          name = "LSP",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          fallbacks = { "buffer" },
          score_offset = 100,
        },
        path = {
          name = "Path",
          enabled = true,
          score_offset = 3,
        },
        snippets = {
          name = "Snippets",
          enabled = true,
          score_offset = 80,
        },
        buffer = {
          name = "Buffer",
          enabled = true,
          max_items = 10,
          min_keyword_length = 3,
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      prebuilt_binaries = {
        download = true,
      },
    },
  },
  opts_extend = { "sources.default" },
}
