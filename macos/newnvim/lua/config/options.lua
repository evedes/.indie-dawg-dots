-- Disable netrw (prevents file explorer on directory open)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader key configurations
vim.g.mapleader = " " -- Set space as the leader key
vim.g.maplocalleader = "," -- Set comma as the local leader key

-- Line numbering settings
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.number = true -- Show current line number

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for yank/paste

-- Global status line (single statusbar across all panes)
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
