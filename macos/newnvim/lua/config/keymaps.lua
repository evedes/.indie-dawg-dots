-- Keymap Options and Auxiliar Functions
local opts = { remap = false, silent = true }
local keymap = vim.keymap
local function with_desc(description)
	return vim.tbl_extend("force", opts, { desc = description })
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
keymap.set("n", "<leader>kk", "<CMD>w<CR>", with_desc("Close buffer"))

-- Splits
keymap.set("n", "<leader>ss", ":split<CR>", with_desc("Horizontal split"))
keymap.set("n", "<leader>sj", ":vsplit<CR>", with_desc("Vertical Split"))

-- Built-in tools
keymap.set("n", "<leader>uu", "<CMD>Undotree<CR>", with_desc("Undo tree"))
keymap.set("n", "<leader>ud", "<CMD>DiffTool<CR>", with_desc("Diff tool"))

-- Resize window
keymap.set("n", "<C-A-h>", "<C-w><", with_desc("Resize left"))
keymap.set("n", "<C-A-l>", "<C-w>>", with_desc("Resize right"))
keymap.set("n", "<C-A-k>", "<C-w>+", with_desc("Resize up"))
keymap.set("n", "<C-A-j>", "<C-w>-", with_desc("Resize down"))

