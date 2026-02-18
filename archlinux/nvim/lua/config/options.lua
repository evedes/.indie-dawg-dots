-- Leader key configurations
vim.g.mapleader = " " -- Set space as the leader key
vim.g.maplocalleader = "," -- Set comma as the local leader key

-- Line numbering settings
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.number = true -- Show current line number

-- Tab and indentation settings
vim.opt.tabstop = 2 -- Number of spaces a tab counts for
vim.opt.shiftwidth = 2 -- Size of indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line when starting new line

-- Search settings
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search contains uppercase
vim.opt.cursorline = true -- Highlight the current line

-- Color settings
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.background = "dark" -- Use dark color scheme
vim.opt.signcolumn = "yes" -- Always show the sign column

-- Backspace behavior
vim.opt.backspace = "indent,eol,start" -- Make backspace work as expected

-- Split window behavior
vim.opt.splitright = true -- Open new vertical splits to the right
vim.opt.splitbelow = true -- Open new horizontal splits below

-- Window separator configuration (dashed style with spacing)
vim.opt.fillchars = {
  vert = "┊",
  horiz = "┄",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
}

-- Various UI and behavior settings
vim.opt.title = true -- Set window title
vim.opt.smartindent = true -- Do smart indenting
vim.opt.hlsearch = true -- Highlight search results
vim.opt.backup = false -- Don't create backup files
vim.opt.showcmd = true -- Show partial command in last line
vim.opt.cmdheight = 0 -- Hide command line when not in use
vim.opt.laststatus = 3 -- Global status line
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.inccommand = "split" -- Show effects of substitute command in split
vim.opt.smarttab = true -- Smart handling of tab key
vim.opt.breakindent = true -- Preserve indentation in wrapped text
vim.opt.wrap = false -- Don't wrap lines

-- File and path settings
vim.opt.path:append({ "**" }) -- Search down into subfolders

-- Additional window split settings
vim.opt.splitkeep = "cursor" -- Keep cursor position when splitting

-- Miscellaneous settings
vim.opt.mouse = "a" -- Enable mouse in all modes
vim.opt.spell = false -- Disable spell checking
vim.opt.formatoptions:append({ "r" }) -- Auto-insert comment leader on enter
-- Use OSC 52 for clipboard copy (works over SSH/tmux/zellij)
-- Paste via OSC 52 is blocked by most terminals for security, so we omit it
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = "",
    ["*"] = "",
  },
}
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
vim.opt.nrformats:append("alpha") -- Enable increment/decrement for letters as well as numbers

-- Conceal settings
vim.opt.conceallevel = 0 -- Show text normally

-- Disable Luarocks health check
vim.g.loaded_health_nvim_luarocks = 1

-- Create the undo directory if it doesn't exist
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

-- Set undofile and undodir
vim.opt.undofile = true
vim.opt.undodir = undodir


-- Configure completion properly
vim.opt.completeopt = { "menu", "menuone", "noselect" }  -- Required for blink.cmp
vim.opt.complete = ""  -- Disable native completion sources in insert mode

-- Enhanced command-line completion settings
vim.opt.wildmenu = true  -- Enable wildmenu for command-line completion
vim.opt.wildmode = "longest:full,full"  -- Complete longest common, then full matches
vim.opt.wildoptions = "pum,fuzzy"  -- Use popup menu with fuzzy matching
vim.opt.wildignorecase = true  -- Ignore case in command-line completion
vim.opt.pumheight = 15  -- Increased popup menu height for better visibility
