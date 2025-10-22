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

-- Clear search highlighting and selections
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", with_desc("Clear search highlight"))

-- Write & Quit
keymap.set("n", "<leader>w", "<cmd>w<cr>", with_desc("Write"))
keymap.set("n", "<leader>q", "<cmd>q<cr>", with_desc("Quit (close this window)"))
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", with_desc("Quit vim"))
keymap.set("n", "<leader>kk", "<cmd>bd<cr>", with_desc("Close Buffer"))

-- Splits
keymap.set("n", "<leader>ss", ":split<Return>", opts)
keymap.set("n", "<leader>sj", ":vsplit<Return>", opts)

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

-- Git
keymap.set("n", "<leader>go", "<cmd>lua MiniDiff.toggle_overlay()<cr>", with_desc("MiniDiff"))
keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", with_desc("Neogit"))

-- Dadbod
keymap.set("n", "<leader>D", "<cmd>DBUI<cr>", with_desc("Open Dadbod"))

-- Quickfix Navigation
keymap.set("n", "<leader>xq", "<cmd>copen<cr>", with_desc("Open quickfix"))
keymap.set("n", "<leader>xc", "<cmd>cclose<cr>", with_desc("Close quickfix"))

-- UI Toggles
keymap.set("n", "<leader>ud", function()
  vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end, with_desc("Toggle diagnostic virtual text"))

-- File Navigation (mini.files and mini.pick)
keymap.set("n", "<leader>fe", function()
  MiniFiles.open()
  -- Set up Esc to close mini.files when open
  vim.schedule(function()
    if vim.bo.filetype == "minifiles" then
      keymap.set("n", "<Esc>", function()
        MiniFiles.close()
      end, with_desc("Close file explorer"))
    end
  end)
end, with_desc("File explorer"))

keymap.set("n", "<leader>ee", function()
  MiniFiles.open(vim.fn.expand("%:p:h"))
  -- Set up Esc to close mini.files when open
  vim.schedule(function()
    if vim.bo.filetype == "minifiles" then
      keymap.set("n", "<Esc>", function()
        MiniFiles.close()
      end, with_desc("Close file explorer"))
    end
  end)
end, with_desc("Explorer at current file"))

keymap.set("n", "<leader>ff", function()
  MiniPick.builtin.files()
end, with_desc("Find files"))

keymap.set("n", "<leader>/", function()
  MiniPick.builtin.grep_live()
end, with_desc("Live grep"))

keymap.set("n", "<leader>bb", function()
  MiniPick.builtin.buffers()
end, with_desc("Buffers"))

keymap.set("n", "<leader>fh", function()
  MiniPick.builtin.help()
end, with_desc("Help"))

keymap.set("n", "<leader>cc", function()
  MiniPick.builtin.resume()
end, with_desc("Resume picker"))

keymap.set("n", "<leader>gs", function()
  MiniPick.builtin.git_files()
end, with_desc("Git status files"))

keymap.set("n", "<leader>fr", function()
  MiniPick.builtin.recent()
end, with_desc("Recent files"))

keymap.set("n", "<leader>:", function()
  MiniPick.builtin.history()
end, with_desc("Command history"))
