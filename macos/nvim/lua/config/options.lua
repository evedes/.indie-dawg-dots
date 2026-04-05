-- Disable netrw (prevents file explorer on directory open)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader key configurations
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Line numbering
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Editing
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.updatetime = 250

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3

-- Native auto-completion (Neovim 0.12)
vim.o.autocomplete = true
vim.o.pumborder = "rounded"
vim.o.completeopt = "menuone,noselect,fuzzy"

-- Built-in plugins
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

-- Window separator configuration
vim.opt.fillchars = {
  vert = "┊",
  horiz = "┄",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
}
