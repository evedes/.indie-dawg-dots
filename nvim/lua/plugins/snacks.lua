vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

local explorer_width = 40

local function explorer_item_width(item)
  if not item or not item.file then
    return 0
  end

  local depth = 0
  local parent = item.parent
  while parent do
    depth = depth + 1
    parent = parent.parent
  end

  local name = vim.fn.fnamemodify(item.file, ":t")
  name = name == "" and item.file or name

  -- Tree prefix + file icon + trailing space/right-aligned status padding.
  return (depth * 2) + 2 + vim.api.nvim_strwidth(name) + 3
end

local function update_explorer_width(picker)
  if not picker or picker.closed then
    return
  end

  local width = 40
  for _, item in ipairs(picker:items()) do
    width = math.max(width, explorer_item_width(item))
  end

  width = math.min(width, math.max(40, math.floor(vim.o.columns * 0.45)))
  if width ~= explorer_width then
    explorer_width = width
    if picker.layout.split and picker.layout.root and picker.layout.root:valid() then
      vim.api.nvim_win_set_width(picker.layout.root.win, width)
    end
    picker.layout:update()
  end
end

local function update_open_explorers()
  local Snacks = package.loaded.snacks
  if not Snacks or not Snacks.picker then
    return
  end

  for _, picker in ipairs(Snacks.picker.get({ source = "explorer" })) do
    update_explorer_width(picker)
  end
end

local function schedule_explorer_width(picker)
  update_explorer_width(picker)
  for _, delay in ipairs({ 50, 150, 400 }) do
    vim.defer_fn(function()
      update_explorer_width(picker)
    end, delay)
  end
end

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
      explorer = {
        hidden = true,
        ignored = true,
        layout = {
          layout = {
            width = function()
              return explorer_width
            end,
            min_width = 40,
          },
        },
        matcher = {
          on_done = update_open_explorers,
        },
        on_change = update_explorer_width,
        on_show = schedule_explorer_width,
      },
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
