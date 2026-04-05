# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the Neovim configuration within the `indie-dawg-dots` dotfiles repository. It's a modern Lua-based configuration using lazy.nvim for plugin management, with heavy use of the mini.nvim plugin suite for core functionality.

## Common Commands

### Configuration Testing & Validation
- **Lua syntax check**: Files are auto-formatted on save via stylua (configured in `stylua.toml`)
- **Health check**: `:checkhealth` in Neovim to diagnose issues
- **Plugin status**: `:Lazy` to manage plugins, `:Lazy sync` to update, `:Lazy clean` to remove unused
- **LSP status**: `:LspInfo` to check active language servers
- **Format info**: `:ConformInfo` to see active formatters for current buffer

### Development Commands in Neovim
- **Find files**: `<Space>ff` (uses mini.pick)
- **Live grep**: `<Space>/` (search across project)
- **File explorer**: `<Space>fe` (mini.files)
- **Buffer list**: `<Space>bb`
- **Resume picker**: `<Space>cc`
- **Git operations**: `<Space>gg` (Neogit)
- **Code actions**: `gra` (uses tiny-code-action)
- **Go to definition**: `gd` (with picker for multiple results)
- **Find references**: `grr`
- **Navigate diagnostics**: `[d`/`]d` (previous/next)
- **Toggle theme picker**: `<Space>ut`
- **Comment line**: `gcc` (toggle comment)
- **Comment selection**: `gc` in visual mode
- **Add surrounding**: `sa` (e.g., `saiw"` to surround word with quotes)
- **Delete surrounding**: `sd`
- **Replace surrounding**: `sr`
- **Jump to char**: `f`/`F`/`t`/`T` (enhanced with mini.jump)
- **Flash jump**: `s` to jump to any location (flash.nvim)
- **Flash treesitter**: `S` to jump by treesitter node

## Architecture & Structure

### Initialization Flow
1. `init.lua` loads modules sequentially:
   - `config.options` - Vim options and settings
   - `config.keymaps` - Global keybindings
   - `config.autocmds` - Autocommands
   - `config.lazy` - Plugin manager bootstrap
   - `lsp` - LSP configuration and keymaps
2. Theme switcher initializes immediately after lazy.nvim setup (before filetype plugins)
3. Plugins load on-demand based on events/commands

### Directory Structure
```
nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── autocmds.lua    # Yank highlight, terminal settings
│   │   ├── keymaps.lua     # Global mappings (leader = Space)
│   │   ├── lazy.lua        # Plugin manager setup
│   │   ├── options.lua     # Neovim options
│   │   └── theme-switcher.lua # Custom theme management
│   ├── plugins/            # Plugin configurations (20 files)
│   │   ├── mini.lua        # Mini.nvim suite (12 modules)
│   │   ├── blink.lua       # Completion engine
│   │   ├── conform.lua     # Code formatting
│   │   ├── neogit.lua      # Git integration
│   │   ├── gitsigns.lua    # Git signs in gutter
│   │   ├── treesitter.lua  # Syntax highlighting
│   │   ├── diffview.lua    # Git diff viewer
│   │   ├── flash.lua       # Enhanced navigation
│   │   ├── noice.lua       # Enhanced UI messages
│   │   ├── supermaven.lua  # AI completion
│   │   ├── tiny-code-action.lua # LSP code actions
│   │   ├── dadbod.lua      # Database interface
│   │   ├── autotag.lua     # HTML/JSX auto-closing
│   │   ├── obsidian.lua    # Note-taking integration
│   │   ├── markview.lua    # Markdown preview
│   │   ├── tmux-navigator.lua # Tmux/window navigation
│   │   ├── schemastore.lua # JSON/YAML schemas
│   │   ├── beacon.lua      # Cursor beacon
│   │   ├── indent-blankline.lua # Indent guides
│   │   └── markdown-preview.lua # Markdown live preview
│   ├── lsp.lua            # Centralized LSP setup
│   └── icons.lua          # UI icon definitions
├── lsp/                   # Language server configs
│   ├── vtsls.lua         # TypeScript/JavaScript
│   ├── lua.lua           # Lua with Neovim API
│   ├── eslint.lua        # ESLint integration
│   └── ...               # 15 language servers total
├── lazy-lock.json        # Plugin version lock
└── stylua.toml          # Lua formatter config
```

### LSP Configuration Pattern
Each LSP server has its own config file in `lsp/` directory following this pattern:
```lua
---@type vim.lsp.Config
return {
  cmd = { "server-executable", "--stdio" },
  filetypes = { "filetype1", "filetype2" },
  root_markers = { "marker1", "marker2" },
  settings = { ... }
}
```

LSP servers are auto-loaded on BufReadPre/BufNewFile events. The `lua/lsp.lua` file sets up keymaps and handlers globally.

### Plugin Management (lazy.nvim)
- Plugins defined in `lua/plugins/*.lua` (20 plugin files)
- Each file returns a plugin spec or array of specs
- Lazy loading configured per plugin via:
  - `event` - Load on specific events (BufReadPre, VeryLazy, etc.)
  - `cmd` - Load on commands
  - `ft` - Load on filetypes
  - `keys` - Load on keymaps

### Mini.nvim Modules (12 active)
- `mini.ai` - Enhanced text objects
- `mini.icons` - Icon provider
- `mini.pairs` - Auto-close brackets/quotes
- `mini.statusline` - Status line
- `mini.files` - File explorer
- `mini.diff` - Git diff visualization
- `mini.pick` - Fuzzy finder
- `mini.comment` - Comment code (gcc/gc)
- `mini.surround` - Surround operations (sa/sd/sr)
- `mini.bufremove` - Better buffer deletion
- `mini.clue` - Which-key hints for key mappings

### Code Formatting (conform.nvim)
Configured in `lua/plugins/conform.lua`:
- Auto-format on save (toggle with `vim.g.autoformat`)
- Formatters by filetype:
  - JavaScript/TypeScript: prettier, dprint (fallback)
  - Lua: stylua
  - Shell: shfmt
  - CSS/HTML/SCSS/Vue: prettier
  - Elixir: mix_format
  - Markdown: disabled (conflicts with Obsidian/markview)

### Completion (blink.cmp)
- Sources: LSP, path, snippets, buffer
- Navigation: `<C-j>`/`<C-k>` for next/prev
- Accept: `<CR>` to confirm
- Documentation: `<C-d>` to toggle
- Snippet navigation: `<Tab>`/`<S-Tab>`

### Key Design Patterns
1. **Modular configuration**: Each feature in separate file
2. **Lazy loading**: Plugins load on-demand for fast startup
3. **Mini.nvim preference**: Use mini modules over separate plugins when possible
4. **LSP-first**: Language features via LSP rather than plugins
5. **Consistent keymaps**: Space as leader, descriptive mappings with `with_desc()`

### Important Files to Know
- `lua/config/keymaps.lua:4-6` - Helper for adding described keymaps
- `lua/lsp.lua:10-140` - LSP on_attach function with all LSP keymaps
- `lua/plugins/conform.lua:6-22` - Formatter configuration
- `lua/plugins/mini.lua` - Core mini.nvim modules setup
- `lua/plugins/blink.lua` - Completion configuration
- `lsp/*.lua` - Individual language server configs
