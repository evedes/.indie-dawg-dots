# CLAUDE.md - Neovim Configuration

This directory contains the Neovim configuration for the indie-dawg-dots setup.

## Overview

A modern Neovim configuration built with Lua, focusing on minimalism and efficiency using the mini.nvim plugin suite extensively.

## Structure

```
.config/nvim/
├── init.lua              # Entry point - loads lua/edo/init.lua
├── lua/
│   └── edo/
│       ├── init.lua      # Main configuration loader
│       ├── plugins/      # Plugin configurations
│       ├── lsp/          # LSP settings
│       └── keymaps.lua   # Key mappings
└── lazy-lock.json        # Plugin version lock file
```

## Key Features

- **Plugin Manager**: lazy.nvim for fast startup times
- **Leader Key**: Space
- **Plugin Suite**: Heavy use of mini.nvim modules for core functionality
- **LSP**: Mason for easy language server management
- **Git Integration**: Neogit and gitsigns.nvim

## Important Patterns

1. **Modular Configuration**: Each major feature has its own file in `lua/edo/`
2. **Lazy Loading**: Plugins are loaded on-demand where possible
3. **Minimal Dependencies**: Prefer mini.nvim modules over separate plugins

## Common Tasks

### Adding a Plugin
1. Edit the appropriate file in `lua/edo/plugins/`
2. Follow the lazy.nvim specification format
3. Run `:Lazy sync` to install

### Modifying Keymaps
- Main keymaps are in `lua/edo/keymaps.lua`
- Plugin-specific keymaps are in their respective plugin files

### LSP Configuration
- Language servers are managed through Mason
- Server-specific settings in `lua/edo/lsp/`

## Dependencies

- Neovim >= 0.9.0
- Git (for plugin management)
- Node.js (for many LSP servers)
- Ripgrep (for telescope and other search features)