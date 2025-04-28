local opts = { noremap = true, silent = true }
local keymap = vim.keymap

local function with_desc(description)
  return vim.tbl_extend("force", opts, { desc = description })
end

keymap.set("i", "jk", "<Esc>", with_desc("Escape"))
keymap.set("n", "x", '"_x') -- Sends the deleted char to the black hole register

-- Write & Quit
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit (close this window)" })
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit vim (all changes are lost!)" })

-- Splits
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sj", ":vsplit<Return>", opts)

-- Indent while remaining in visual mode.
keymap.set("v", "<", "<gv", with_desc("Shift left"))
keymap.set("v", ">", ">gv", with_desc("Shift right"))

-- Utils
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", with_desc("Lazy"))
keymap.set("n", "<leader>M", "<cmd>Mason<cr>", with_desc("Mason"))

-- Resize window
keymap.set("n", "<C-A-h>", "<C-w><", with_desc("Resize left"))
keymap.set("n", "<C-A-l>", "<C-w>>", with_desc("Resize right"))
keymap.set("n", "<C-A-k>", "<C-w>+", with_desc("Resize up"))
keymap.set("n", "<C-A-j>", "<C-w>-", with_desc("Resize down"))

-- Mini Picker
keymap.set("n", "<leader>fe", "<cmd>lua MiniFiles.open()<cr>", with_desc("Explorer"))
keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", with_desc("Find Files"))

keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", with_desc("Live Grep"))
keymap.set("n", "<leader>bb", "<cmd>Pick buffers<cr>", with_desc("Buffers"))
keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>", with_desc("Help"))
keymap.set("n", "<leader>fr", "<cmd>lua MiniPick.builtin.resume()<cr>", with_desc("Resume"))

-- Git
keymap.set("n", "<leader>go", "<cmd>lua MiniDiff.toggle_overlay()<cr>", with_desc("MiniDiff"))

-- Obsidian
keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<cr>", with_desc("Follow Link"))
keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", with_desc("New Note"))
keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", with_desc("Backlinks"))
