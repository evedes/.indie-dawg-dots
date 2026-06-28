-- Role: in-editor Markdown rendering via conceal (headings, lists, tables, code).
-- Owns how Markdown *looks* while editing; navigation is mkdnflow, browser
-- preview is markdown-preview. (See CLAUDE.md → "Markdown Workflow".)
vim.pack.add({
  "https://github.com/OXY2DEV/markview.nvim",
})

require("markview").setup({
  modes = { "n", "no", "c" },
  hybrid_modes = { "n" },
  callbacks = {
    on_enable = function(_, win)
      vim.wo[win].conceallevel = 2
      vim.wo[win].concealcursor = "c"
    end,
  },
})

-- Keymaps
vim.keymap.set("n", "<leader>mt", "<CMD>Markview toggle<CR>", { desc = "Toggle Markview" })
