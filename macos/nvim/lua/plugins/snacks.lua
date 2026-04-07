vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

require("snacks").setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  notifier = { enabled = true },
  explorer = { enabled = true },
  picker = {
    enabled = true,
    layout = { preset = "ivy" },
    sources = {
      files = { hidden = true, ignored = false },
      grep = { hidden = true, ignored = false },
      explorer = { hidden = true, ignored = false },
    },
  },
})

local Snacks = require("snacks")

-- Match snacks picker/explorer background to the regular buffer background.
local function link_snacks_hl()
  for _, group in ipairs({
    "SnacksPicker",
    "SnacksPickerList",
    "SnacksPickerInput",
    "SnacksPickerPreview",
    "SnacksPickerTitle",
    "SnacksPickerBorder",
    "SnacksPickerListBorder",
    "SnacksPickerInputBorder",
    "SnacksPickerPreviewBorder",
    "SnacksPickerInputTitle",
    "SnacksPickerPreviewTitle",
  }) do
    vim.api.nvim_set_hl(0, group, { link = "Normal" })
  end
end
link_snacks_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = link_snacks_hl })

-- File explorer
vim.keymap.set("n", "<leader>fe", function()
  Snacks.explorer()
end, { desc = "File explorer" })
vim.keymap.set("n", "<leader>ee", function()
  Snacks.explorer({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Explorer at current file" })

-- File / buffer pickers
vim.keymap.set("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>/", function()
  Snacks.picker.grep()
end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>bb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help" })
vim.keymap.set("n", "<leader>cc", function()
  Snacks.picker.resume()
end, { desc = "Resume last picker" })

-- Replacements for previous mini.extra pickers
vim.keymap.set("n", "<leader>fd", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fq", function()
  Snacks.picker.qflist()
end, { desc = "Quickfix" })
vim.keymap.set("n", "<leader>fl", function()
  Snacks.picker.loclist()
end, { desc = "Location list" })
vim.keymap.set("n", "<leader>fk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fo", function()
  Snacks.picker.recent()
end, { desc = "Recent files" })
