# neovim

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
│   │   ├── commands.lua        # Non-plugin user commands (:DotfilesHealth)
│   │   └── colorscheme.lua     # Theme setup (kanagawa)
│   ├── dotfiles/
│   │   └── health.lua          # `:checkhealth dotfiles` — verifies external tools
│   ├── plugins/                # One file per plugin (auto-loaded by init.lua)
│   │   ├── snacks.lua          # Explorer, picker, notifier, bigfile, quickfile
│   │   ├── blink-cmp.lua       # Completion engine (Rust matcher) + LSP capabilities
│   │   ├── which-key.lua       # Keymap hints / leader group descriptions
│   │   ├── ui2.lua             # Built-in UI2 (messages, cmdline, pager)
│   │   ├── mkdnflow.lua        # Markdown notebook navigation, links, backlinks, todos
│   │   ├── mini-diff.lua       # Inline diff overlay
│   │   ├── neogit.lua          # Git interface
│   │   ├── diffview.lua        # Side-by-side diff viewer
│   │   └── tmux-navigator.lua  # Tmux pane navigation
│   └── lsp.lua                 # LSP configuration
├── lsp/                        # Per-server vim.lsp.Config files (auto-enabled)
├── scripts/
│   └── nvim-doctor             # Check/install external tools (cross-platform)
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

## Adding a which-key Group

To add a description for a `<leader>` key group, add an entry to the `add()` call in `lua/plugins/which-key.lua`:
```lua
{ "<leader>x", group = "GroupName" },
```
which-key automatically picks up `desc` fields from `vim.keymap.set(...)` calls, so individual mappings don't need to be registered manually.

## Health Check & Tool Install

The config expects a set of external tools (language servers, formatters, ripgrep/fd). Two ways to verify and install them:

- **In-editor**: `:checkhealth dotfiles` (or `:DotfilesHealth`) reports which expected tools are present/missing. Defined in `lua/dotfiles/health.lua`.
- **Terminal**: `scripts/nvim-doctor` checks and installs.
  - `nvim-doctor` / `nvim-doctor check` — report installed vs missing.
  - `nvim-doctor install` — install everything missing (auto-detects macOS/brew vs Arch/pacman/yay; uses npm/cargo/rustup where appropriate).
  - `nvim-doctor list` — list every managed tool and its install recipe.

The tool list is duplicated in `lua/dotfiles/health.lua` and `scripts/nvim-doctor`; keep the two in sync when adding/removing a server or formatter.

## Formatting

- `conform.nvim` formats on save (toggle `vim.g.autoformat`). Formatters per filetype live in `lua/plugins/conform.lua`.
- **JS/TS/JSON use Prettier only** — `dprint` was removed as a JS/TS/JSON formatter to keep formatting deterministic (no two formatters competing in one chain). The `dprint` LSP (`lsp/dprint.lua`) is still enabled for json/graphql.
- `<leader>up` toggles Prettier's built-in default args (used only when no project Prettier config is found).

## Leader Key

Space. Local leader is comma.

## Markdown Workflow

- `mkdnflow.nvim` handles Markdown notebook navigation and editing.
- `<CR>` follows or creates Markdown links; `<BS>` / `<Del>` move back and forward through mkdnflow history.
- `<Tab>` / `<S-Tab>` jump between links; `]]` / `[[` jump between headings.
- `<leader>ml` creates a Markdown link from text/selection; `<leader>mL` creates one from the clipboard.
- `<leader>mb` opens backlinks; `<leader>mB` refreshes backlinks.
- `<leader>mx` toggles Markdown task status.
- `<leader>mr` renames/moves the current source and updates links.
- Markdown link creation is configured for flat kebab-case `.md` files to match the Multiverse vault.

## Pre-Commit Rule

Before creating a commit, review and update this CLAUDE.md to reflect any structural changes (new/removed/renamed files, plugins, keymaps, patterns, or dependencies).

## Dependencies

- Neovim >= 0.12 (for `vim.pack.add`)
- Git (for plugin fetching)
- ripgrep (for mini.pick grep)
- Language servers + formatters listed by `scripts/nvim-doctor` (install with `nvim-doctor install`)
