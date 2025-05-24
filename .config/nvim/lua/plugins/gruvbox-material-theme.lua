return {
  "sainnhe/gruvbox-material",
  enabled = true,
  priority = 1000,
  config = function()
    -- Set contrast and background darkness
    vim.g.gruvbox_material_background = "hard" -- Options: 'hard', 'medium'(default), 'soft'
    vim.g.gruvbox_material_foreground = "material" -- Options: 'material', 'mix', 'original'
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_dim_inactive_windows = 1
    vim.g.gruvbox_material_visual = "reverse"
    vim.g.gruvbox_material_current_word = "bold"
    vim.g.gruvbox_material_ui_contrast = "high" -- Options: 'low', 'high'
    -- Apply the colorscheme
    vim.cmd("colorscheme gruvbox-material")
  end,
}
