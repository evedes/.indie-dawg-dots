-- In-terminal image rendering — used by molten to show plot/image cell outputs.
--
-- backend "kitty":   the kitty graphics protocol, which Ghostty implements, so
--                    images render directly in the terminal.
-- processor "magick_cli": uses the ImageMagick CLI (`magick`) instead of the
--                    `magick` luarock, so the only dependency is ImageMagick
--                    (`brew install imagemagick` / `pacman -S imagemagick`).
--
-- tmux caveat: image passthrough needs `set -g allow-passthrough on` in
-- .tmux.conf. Zellij does not currently forward the kitty graphics protocol —
-- run Ghostty directly (or in tmux) when you need inline plots.
vim.pack.add({
  "https://github.com/3rd/image.nvim",
})

require("image").setup({
  backend = "kitty",
  processor = "magick_cli",
  -- molten drives rendering directly; no markdown/neorg auto-render integrations
  -- (markview already handles Markdown).
  integrations = {},
  max_width = 100,
  max_height = 12,
  max_height_window_percentage = math.huge,
  max_width_window_percentage = math.huge,
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "" },
})
