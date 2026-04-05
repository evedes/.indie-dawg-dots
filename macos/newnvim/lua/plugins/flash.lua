vim.pack.add {
  "https://github.com/folke/flash.nvim",
}

require("flash").setup({
  modes = {
    search = {
      enabled = true,
    },
  },
})

-- Keymaps (no s/S — using / with flash search instead)
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<C-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
