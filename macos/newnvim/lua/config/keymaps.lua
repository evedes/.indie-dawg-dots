-- Keymap Options and Auxiliar Functions
local keymap = vim.keymap
local function with_desc(description)
  return { silent = true, desc = description }
end

-- Registers
keymap.set("n", "x", '"_x') -- Sends the deleted char to the black hole register

-- Auxiliar Keybinds
keymap.set("i", "jk", "<Esc>", with_desc("Escape"))
keymap.set("n", "<Esc>", "<CMD>nohlsearch<CR>", with_desc("Clear search highlight"))

-- Write & Quit Keybinds
keymap.set("n", "<leader>w", "<CMD>w<CR>", with_desc("Write"))
keymap.set("n", "<leader>q", "<CMD>q<CR>", with_desc("Quit (close this window)"))
keymap.set("n", "<leader>Q", "<CMD>qa!<CR>", with_desc("Quit vim"))

-- Buffers
keymap.set("n", "<leader>kk", "<CMD>bdelete<CR>", with_desc("Close buffer"))

-- Splits
keymap.set("n", "<leader>ss", "<CMD>split<CR>", with_desc("Horizontal split"))
keymap.set("n", "<leader>sj", "<CMD>vsplit<CR>", with_desc("Vertical split"))

-- Built-in tools
keymap.set("n", "<leader>uu", "<CMD>Undotree<CR>", with_desc("Undo tree"))
keymap.set("n", "<leader>ud", "<CMD>DiffTool<CR>", with_desc("Diff tool"))

-- Toggles
keymap.set("n", "<leader>uf", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Autoformat " .. (vim.g.autoformat and "enabled" or "disabled"))
end, with_desc("Toggle autoformat"))

keymap.set("n", "<leader>ui", function()
  vim.g.inlay_hints = not vim.g.inlay_hints
  vim.lsp.inlay_hint.enable(vim.g.inlay_hints)
  vim.notify("Inlay hints " .. (vim.g.inlay_hints and "enabled" or "disabled"))
end, with_desc("Toggle inlay hints"))

-- Resize window
keymap.set("n", "<C-A-h>", "<C-w><", with_desc("Resize left"))
keymap.set("n", "<C-A-l>", "<C-w>>", with_desc("Resize right"))
keymap.set("n", "<C-A-k>", "<C-w>+", with_desc("Resize up"))
keymap.set("n", "<C-A-j>", "<C-w>-", with_desc("Resize down"))
