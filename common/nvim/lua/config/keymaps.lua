local opts = { noremap = true, silent = true }
local keymap = vim.keymap

local function with_desc(description)
  return vim.tbl_extend("force", opts, { desc = description })
end

keymap.set("i", "jk", "<Esc>", with_desc("Escape"))

-- Disable native INSERT mode completion only (keep command-line completion working)
keymap.set("i", "<C-n>", "<Nop>", with_desc("Disable native next completion"))
keymap.set("i", "<C-p>", "<Nop>", with_desc("Disable native prev completion"))
keymap.set("i", "<C-x><C-o>", "<Nop>", with_desc("Disable omni completion"))
keymap.set("i", "<C-x><C-n>", "<Nop>", with_desc("Disable native completion"))
keymap.set("i", "<C-x><C-p>", "<Nop>", with_desc("Disable native completion"))
keymap.set("n", "x", '"_x') -- Sends the deleted char to the black hole register

-- Clear search highlighting
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", with_desc("Clear search highlight"))

-- Write & Quit
keymap.set("n", "<leader>w", "<cmd>w<cr>", with_desc("Write"))
keymap.set("n", "<leader>q", "<cmd>q<cr>", with_desc("Quit (close this window)"))
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", with_desc("Quit vim"))
keymap.set("n", "<leader>kk", "<cmd>bd<cr>", with_desc("Close Buffer"))

-- Splits
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sj", ":vsplit<Return>", opts)

-- Window Navigation
keymap.set("n", "<C-h>", "<C-w>h", with_desc("Navigate left"))
keymap.set("n", "<C-j>", "<C-w>j", with_desc("Navigate down"))
keymap.set("n", "<C-k>", "<C-w>k", with_desc("Navigate up"))
keymap.set("n", "<C-l>", "<C-w>l", with_desc("Navigate right"))

-- Indent while remaining in visual mode.
keymap.set("v", "<", "<gv", with_desc("Shift left"))
keymap.set("v", ">", ">gv", with_desc("Shift right"))

-- Resize window
keymap.set("n", "<C-A-h>", "<C-w><", with_desc("Resize left"))
keymap.set("n", "<C-A-l>", "<C-w>>", with_desc("Resize right"))
keymap.set("n", "<C-A-k>", "<C-w>+", with_desc("Resize up"))
keymap.set("n", "<C-A-j>", "<C-w>-", with_desc("Resize down"))

-- Mini Picker
keymap.set("n", "<leader>fe", "<cmd>lua MiniFiles.open()<cr>", with_desc("Explorer"))

keymap.set("n", "<leader>ee", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, with_desc("Current File"))
keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", with_desc("Find Files"))

keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", with_desc("Live Grep"))
keymap.set("n", "<leader>bb", "<cmd>Pick buffers<cr>", with_desc("Buffers"))
keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>", with_desc("Help"))
keymap.set("n", "<leader>cc", "<cmd>lua MiniPick.builtin.resume()<cr>", with_desc("Resume"))

-- Git
keymap.set("n", "<leader>go", "<cmd>lua MiniDiff.toggle_overlay()<cr>", with_desc("MiniDiff"))
keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", with_desc("Neogit"))

-- Dadbod
keymap.set("n", "<leader>D", "<cmd>DBUI<cr>", with_desc("Open Dadbod"))

-- Quickfix Navigation
keymap.set("n", "<leader>xq", "<cmd>copen<cr>", with_desc("Open quickfix"))
keymap.set("n", "<leader>xc", "<cmd>cclose<cr>", with_desc("Close quickfix"))

