-- Disable netrw (prevents file explorer on directory open)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader key configurations
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Python provider host (molten + other remote plugins). Homebrew's python3 is
-- PEP 668 externally-managed and can't host pynvim, so point Neovim at a
-- dedicated venv: python3 -m venv ~/.venvs/neovim &&
--   ~/.venvs/neovim/bin/pip install pynvim jupyter_client ipykernel
local nvim_py = vim.fn.expand("~/.venvs/neovim/bin/python")
if vim.fn.executable(nvim_py) == 1 then
  vim.g.python3_host_prog = nvim_py
end

-- True color (24-bit) — required for colorschemes to render exact hex values
vim.opt.termguicolors = true

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

-- Use OSC 52 for clipboard over SSH (terminal handles the paste to local clipboard)
if os.getenv("SSH_TTY") then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.updatetime = 250

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3

-- Completion handled by blink.cmp; disable Neovim 0.12 native autocomplete
vim.o.autocomplete = false
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
