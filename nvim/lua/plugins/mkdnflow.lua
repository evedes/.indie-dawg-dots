-- Deferred: mkdnflow only matters in Markdown buffers, so load it on the first
-- one. Its setup() ends with `doautocmd FileType`, which re-fires for the
-- triggering buffer and attaches mkdnflow's maps/conceal to it.
require("util.lazy").on_filetype("markdown", function()
  vim.pack.add({
    "https://github.com/jakewvincent/mkdnflow.nvim",
  })

  require("mkdnflow").setup({
    path_resolution = {
      primary = "current",
      fallback = "current",
      sync_cwd = false,
    },
    links = {
      style = "markdown",
      transform_on_create = function(text)
        local slug = text:lower()
        slug = slug:gsub("%.md$", "")
        slug = slug:gsub("[^%w%s-]", "")
        slug = slug:gsub("%s+", "-")
        slug = slug:gsub("-+", "-")
        slug = slug:gsub("^-", ""):gsub("-$", "")
        return slug .. ".md"
      end,
    },
    mappings = {
      MkdnEnter = { { "n", "v" }, "<CR>" },
      MkdnGoBack = { "n", "<BS>" },
      MkdnGoForward = { "n", "<Del>" },
      MkdnNextLink = { "n", "<Tab>" },
      MkdnPrevLink = { "n", "<S-Tab>" },
      MkdnMoveSource = { "n", "<leader>mr" },
      MkdnDestroyLink = { "n", "<leader>md" },
      MkdnTagSpan = false,
      MkdnYankAnchorLink = { "n", "<leader>ma" },
      MkdnYankFileAnchorLink = { "n", "<leader>mA" },
      MkdnToggleToDo = { { "n", "v" }, "<leader>mx" },
      MkdnCreateLink = { { "n", "v" }, "<leader>ml" },
      MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>mL" },
      MkdnBacklinks = { "n", "<leader>mb" },
      MkdnBacklinksRefresh = { "n", "<leader>mB" },
      MkdnFoldSection = false,
      MkdnUnfoldSection = false,
      MkdnUpdateNumbering = false,
      MkdnTableNewRowBelow = false,
      MkdnTableNewRowAbove = false,
      MkdnTableNewColAfter = false,
      MkdnTableNewColBefore = false,
      MkdnTableDeleteRow = false,
      MkdnTableDeleteCol = false,
      MkdnTableAlignLeft = false,
      MkdnTableAlignRight = false,
      MkdnTableAlignCenter = false,
      MkdnTableAlignDefault = false,
    },
  })
end)
