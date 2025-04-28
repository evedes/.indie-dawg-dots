return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  checkbox = {
    enabled = false,
    render_modes = false,
    right_pad = 10,
    unchecked = {
      icon = "󰄱 ",
      highlight = "RenderMarkdownUnchecked",
      scope_highlight = nil,
    },
    checked = {
      icon = "󰱒",
      highlight = "RenderMarkdownChecked",
      scope_highlight = nil,
    },
    custom = {
      todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
    },
  },
}
