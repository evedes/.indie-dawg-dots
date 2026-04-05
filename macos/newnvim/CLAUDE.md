# newnvim

Minimal Neovim configuration for macOS using Neovim 0.12+ native package management (`vim.pack.add`). No lazy.nvim or other plugin managers.

## Structure

```
newnvim/
├── init.lua                    # Entry point: loads config, colorscheme, then auto-requires all plugins
├── lua/
│   ├── config/
│   │   ├── options.lua         # Vim options (leader, numbers, clipboard, netrw disabled)
│   │   ├── keymaps.lua         # Global keymaps (not plugin-specific)
│   │   ├── autocmds.lua        # Autocommands (yank highlight)
│   │   └── colorscheme.lua     # Theme setup (kanagawa)
│   ├── plugins/                # One file per plugin (auto-loaded by init.lua)
│   │   ├── mini-files.lua      # File explorer
│   │   ├── mini-pick.lua       # Fuzzy finder
│   │   ├── mini-clue.lua       # Which-key style hints
│   │   ├── mini-diff.lua       # Inline diff overlay
│   │   ├── neogit.lua          # Git interface
│   │   ├── diffview.lua        # Side-by-side diff viewer
│   │   └── tmux-navigator.lua  # Tmux pane navigation
│   └── lsp.lua                 # LSP configuration
└── after/ftplugin/             # Filetype-specific settings
```

## Key Patterns

- **Plugin loading**: `init.lua` iterates `lua/plugins/` and auto-requires every `.lua` file. No manual registration needed — just add a file.
- **Plugin keymaps live with their plugin**: Each plugin file in `lua/plugins/` contains its own keymaps. Only general-purpose keymaps go in `config/keymaps.lua`.
- **Colorscheme loads before plugins**: `config/colorscheme.lua` is required explicitly in `init.lua` before the plugins loop to ensure highlight groups are available.
- **No lazy.nvim**: Uses Neovim 0.12's built-in `vim.pack.add` for plugin management.
- **`with_desc()` helper** in `keymaps.lua`: Returns merged options table with description for mini.clue integration.

## Adding a Plugin

1. Create a new file in `lua/plugins/` (e.g., `lua/plugins/my-plugin.lua`)
2. Use `vim.pack.add` to declare the plugin, then call its setup and define keymaps:
   ```lua
   vim.pack.add {
       "https://github.com/author/plugin-name",
   }
   require("plugin-name").setup()

   vim.keymap.set("n", "<leader>xx", function() ... end, { desc = "My action" })
   ```
3. It will be auto-loaded on next restart. No changes to `init.lua` needed.

## Adding a Clue Group

To add a description for a `<leader>` key group in mini.clue, add an entry to the `clues` table in `lua/plugins/mini-clue.lua`:
```lua
{ mode = "n", keys = "<Leader>x", desc = "+GroupName" },
```

## Leader Key

Space. Local leader is comma.

## Pre-Commit Rule

Before creating a commit, review and update this CLAUDE.md to reflect any structural changes (new/removed/renamed files, plugins, keymaps, patterns, or dependencies).

## Dependencies

- Neovim >= 0.12 (for `vim.pack.add`)
- Git (for plugin fetching)
- ripgrep (for mini.pick grep)
