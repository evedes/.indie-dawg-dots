# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository (`indie-dawg-dots`) containing configuration files for various development tools on Linux/macOS systems. The configurations are designed for a keyboard-driven, efficient development workflow centered around Neovim, tmux, and modern CLI tools.

## Common Commands

### Dotfiles Management
- `dots` - Navigate to dotfiles and open in Neovim (`cd ~/.indie-dawg-dots && nvim .`)
- Git operations use standard commands (configured with aliases in shell)

### Editor Commands
- `v` or `nvim` - Open Neovim (primary editor)
- `nconf` - Edit Neovim configuration
- `aa` - Edit shell aliases
- `zz` - Edit zshrc configuration

### Development Workflow
- `lg` - Open LazyGit for git operations
- `r` - Reload shell configuration
- `t` - tmux (terminal multiplexer)
- Docker shortcuts: `dps` (ps), `dcu` (compose up), `dcd` (compose down)

### Testing & Linting

No project-specific test or lint commands are defined as this is a dotfiles repository. When modifying configurations:
- Shell scripts: Verify syntax with `zsh -n <file>`
- Lua files: Neovim will validate on load

## Architecture & Structure

### Directory Organization
```
.indie-dawg-dots/
├── nvim/             # Shared Neovim config (Lua, native vim.pack.add — no plugin manager)
├── zellij/           # Shared Zellij config (terminal workspace manager)
├── archlinux/        # Arch Linux platform configs
│   ├── zsh/          # Shell config (.zshrc, .zshenv, .alias)
│   ├── tmux/         # Terminal multiplexer
│   ├── starship/     # Cross-shell prompt
│   ├── mako/         # Notification daemon
│   ├── fontconfig/   # Font configuration
│   ├── gtk-3.0/, gtk-4.0/   # GTK theming
│   ├── cava/         # Audio visualizer
│   ├── …             # Other machine-specific dirs (chromium, udev, fonts, etc.)
│   └── .gitconfig, .gitignore, .ripgreprc, .vimrc
├── macos/            # macOS platform configs
│   ├── zsh/          # Shell config (.zshrc, .zshenv, .alias)
│   ├── tmux/         # Terminal multiplexer
│   ├── ghostty/      # Terminal emulator (includes theme switcher scripts)
│   ├── starship/     # Cross-shell prompt
│   ├── cava/         # Audio visualizer
│   ├── bin/          # Custom scripts
│   ├── fonts/        # Nerd Fonts
│   └── .gitconfig, .gitignore, .ripgreprc, .vimrc
├── CLAUDE.md         # This documentation
├── README.md         # Overview and install instructions
├── LICENSE
└── .claude/          # Claude Code configuration
```

> **Layout note:** `nvim/` and `zellij/` are shared across platforms
> at the repository root. Everything else is duplicated under `archlinux/` and
> `macos/` — duplication is intentional for per-platform independence. There is
> no `common/` directory.

## Detailed Configuration Guides

### Neovim Configuration (`nvim/`)

#### Overview
A modern, minimal Neovim configuration (Neovim 0.12+) written in Lua with **no plugin manager** — plugins are managed by the built-in `vim.pack` API. Each plugin lives in its own file under `lua/plugins/` that calls `vim.pack.add({ "<url>" })` and then configures itself. LSP uses the **native** `vim.lsp` API (`vim.lsp.enable`), not Mason or nvim-lspconfig.

#### Structure
```
nvim/
├── init.lua              # Entry point: loads config.*, lsp, then every lua/plugins/*.lua
├── nvim-pack-lock.json   # vim.pack lockfile (pinned plugin commits)
├── lua/
│   ├── config/
│   │   ├── options.lua       # Vim options; leader = Space
│   │   ├── keymaps.lua       # Global keymaps
│   │   ├── autocmds.lua      # Autocommands
│   │   ├── commands.lua      # User commands (e.g. ToggleInlayHints)
│   │   └── colorscheme.lua   # Theme list, picker, transparency, persistence
│   ├── plugins/          # One file per plugin; each calls vim.pack.add + setup
│   ├── lsp.lua           # Native LSP: on_attach keymaps, diagnostics, vim.lsp.enable
│   ├── icons.lua         # Shared icon definitions
│   ├── util/lazy.lua     # FileType-deferred load helper (NOT a plugin manager)
│   └── dotfiles/health.lua   # :checkhealth dotfiles
├── lsp/                  # One file per language server (native vim.lsp config)
├── after/ftplugin/       # Per-filetype overrides (lua, markdown, typescript)
├── colors/sourcerer.lua  # Custom colorscheme
├── snippets/             # Snippet definitions (markdown.json, package.json)
└── scripts/nvim-doctor   # Standalone health/diagnostic script
```

#### Plugin Management (`vim.pack`, no manager)
- Neovim's **built-in** `vim.pack` handles install/update; there is no lazy.nvim,
  packer, or similar. Plugin commits are pinned in `nvim-pack-lock.json`.
- `init.lua` iterates `lua/plugins/*.lua` and `require`s each. A small set is
  deferred until after first render via `vim.schedule` (`dadbod`, `diffview`,
  `neogit`, `markview`).
- `lua/util/lazy.lua` provides `on_filetype()` — a self-deleting `FileType`
  autocmd that defers a plugin's load until a matching buffer opens. Despite the
  filename, it is **not** a plugin manager.
- Plugins install under `vim.fn.stdpath("data")/site/pack/core/opt`.

#### Initialization Flow (`init.lua`)
1. `vim.loader.enable()` — byte-compiled module cache for fast startup
2. `require` in order: `config.options`, `config.keymaps`, `config.autocmds`,
   `config.commands`, `config.colorscheme`, then `lsp`
3. Load every non-deferred `lua/plugins/*.lua` (failures reported via `vim.notify`)
4. After first render, `vim.schedule` loads the deferred plugins

#### Key Features
- **Leader key**: Space (`vim.g.mapleader`)
- **File navigation / fuzzy find**: Snacks.nvim (explorer + picker, "ivy" layout,
  shows hidden files; dynamic explorer width)
- **Completion**: blink.cmp
- **mini.nvim suite**: ai, surround, pairs, move, diff, icons, indentscope,
  cursorword, statusline (the statusline is mini.statusline — no Noice/lualine)
- **Which-key**: which-key.nvim ("modern" preset, 500ms delay)
- **Git**: Neogit, gitsigns.nvim, mini.diff, diffview.nvim
- **Navigation**: flash.nvim; `<C-h/j/k/l>` window/pane motion via
  vim-tmux-navigator (seamless with tmux panes)
- **AI**: supermaven-nvim
- **Markdown / notes**: markview.nvim, markdown-preview.nvim, mkdnflow.nvim, plus
  a local `multiverse` integration for the personal knowledge vault
- **Eye candy**: tiny-glimmer, smear-cursor, ui2
- **Treesitter**: nvim-treesitter (+ treesitter-context), nvim-ts-autotag
- **Database**: vim-dadbod (+ dadbod-ui, dadbod-completion)

#### Themes (`lua/config/colorscheme.lua`)
- Available: kanagawa (dragon/wave/lotus), kanagawa-paper, catppuccin
  (mocha/macchiato/frappe/latte), oxocarbon, and the local `sourcerer`
- Default: `kanagawa-dragon`; theme choice + transparency persist to
  `stdpath("data")/theme-preference.json`
- `<leader>ut` — pick theme · `<leader>ub` — toggle transparent background

#### LSP (native `vim.lsp` — `lua/lsp.lua` + `lsp/`)
- **No Mason, no nvim-lspconfig.** Each file in `lsp/` is a native server config;
  `lua/lsp.lua` discovers them via `vim.api.nvim_get_runtime_file("lsp/*.lua")`
  and enables them with `vim.lsp.enable(...)`.
- Servers configured (16): bash, clangd, css, dprint, elixir, emmet, eslint,
  html, json, lua, rust, stylelint, tailwindcss, volar, vtsls, yaml
- Install the server binaries yourself (system package manager / language
  toolchain) — there is no in-editor installer.
- `LspAttach` sets buffer-local keymaps. Beyond Neovim 0.12's built-in LSP
  defaults (`grr`, `gra`, `grn`, `gd`, `K`, …), custom maps include:
  - `<leader>fs` — document symbols
  - `gl` — diagnostic float · `gD` — go to declaration
  - `[e` / `]e` — previous / next **error**
  - `<C-k>` (insert mode) — signature help
  - `<leader>ce` — ESLint "fix all" (only when the eslint client is attached)
- Diagnostics: severity-sorted virtual text, custom float prefix, signs disabled.
  Inlay hints are off by default (toggle via a user command).

#### Formatting
- `conform.nvim` handles formatting (incl. format-on-save). Formatter binaries
  (stylua, prettier/dprint, shfmt, …) are installed via the system package
  manager — not Mason.

#### Common Tasks
- **Add a plugin**: create `lua/plugins/<name>.lua` with
  `vim.pack.add({ "https://github.com/owner/repo" })` followed by its setup; it
  loads on next launch (add the module name to the `deferred` table in
  `init.lua` to defer it past first render).
- **Update plugins**: `:lua vim.pack.update()` (rewrites `nvim-pack-lock.json`).
- **Add an LSP server**: drop a native `lsp/<name>.lua` config — it's discovered
  and enabled automatically. Install the server binary separately.
- **Add a theme**: add the repo to `vim.pack.add` and the name to the `themes`
  list in `lua/config/colorscheme.lua`.

#### Debugging & Troubleshooting
- `:checkhealth` — full diagnostics; `:checkhealth dotfiles` — this config's own
  checks (`lua/dotfiles/health.lua`); `scripts/nvim-doctor` — standalone check
- `:messages` — notifications/errors (plugin load failures surface here)
- `nvim --startuptime startup.log` — profile startup
- `:Inspect` / `:InspectTree` — highlight and treesitter inspection
- `:LspInfo`, `:LspLog` — LSP status and logs

#### Dependencies
- **Neovim 0.12+** (required for `vim.pack` and native LSP defaults)
- Git (used by `vim.pack` to clone/update plugins)
- Node.js (many LSP servers and formatters)
- Ripgrep (Snacks grep / pickers); fd (optional, faster file finding)
- A C compiler (treesitter parser compilation)
- LSP server binaries and formatters installed via the system package manager
- stylua (Lua formatting)

### Zsh Configuration (`archlinux/zsh/`, `macos/zsh/`)

#### Overview
A cross-platform Zsh configuration designed to work seamlessly on both macOS and Linux (especially Arch Linux). The shell config is duplicated per platform under `{platform}/zsh/`.

#### File Structure
```
{platform}/zsh/          # archlinux/zsh/ and macos/zsh/
├── .zshrc       # Main interactive shell configuration
├── .zshenv      # Environment variables / PATH (non-interactive)
└── .alias       # Shell aliases and functions

archlinux/
├── .linuxrc     # Linux-specific configurations
└── yay/         # AUR helper configuration

macos/
└── .macosrc     # macOS-specific configurations
```

#### Key Files

##### .zshrc
- **Platform Detection**: Automatically detects macOS vs Linux using `ZSH_PLATFORM`
- **Zinit Integration**: Plugin manager with multiple fallback paths
- **Plugin Loading**: Essential plugins for autosuggestions, fast syntax highlighting
- **Environment Setup**: Sources platform-specific configs
- **Command Caching**: Uses `has_cmd()` function for performance optimization

##### .alias
- Common command shortcuts (e.g., `dots`, `nconf`, `lg`)
- Git aliases
- Docker shortcuts
- Platform-agnostic commands

##### Platform-Specific Files
- `archlinux/.linuxrc`: Linux-specific paths, configurations, and Wayland/X11 clipboard support
- `macos/.macosrc`: macOS-specific paths and Homebrew setup

#### Important Features

##### Zinit Plugin Manager
The configuration checks multiple paths for Zinit:
- macOS: `/opt/homebrew/opt/zinit/zinit.zsh`
- Linux (in order):
  1. `/usr/share/zinit/zinit.zsh`
  2. `~/.local/share/zinit/zinit.zsh`
  3. `/usr/share/zsh/plugins/zinit/zinit.zsh`

##### Cross-Platform Compatibility
- Uses associative arrays for platform-specific paths
- Conditional loading based on platform detection
- Graceful fallbacks when tools aren't installed
- Wayland and X11 clipboard support on Linux

##### Performance Optimizations
- Command existence caching with `has_cmd()` function
- Git completions cached locally (refreshed weekly)
- Single platform detection in `.zshenv`
- Optimized plugin loading (only essential plugins)

#### Common Issues & Solutions

##### Zinit Not Loading
```bash
# Install Zinit manually on Linux
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit

# On macOS
brew install zinit
```

##### Missing Commands
- Check if commands are installed before using them
- The config gracefully handles missing tools
- See troubleshooting section for dependency installation

##### Performance Issues
- Remove duplicate initializations (e.g., fnm)
- Check for conflicting plugins
- Use `zsh -xv` to debug slow startup

#### Customization

##### Adding Aliases
1. Edit `.alias` file
2. Follow existing patterns
3. Reload with `source ~/.zshrc` or use the `r` alias

##### Adding Platform-Specific Config
1. Edit `archlinux/.linuxrc` or `macos/.macosrc`
2. Use platform detection for conditional logic
3. Test on both platforms if possible

### Tmux Configuration (`archlinux/tmux/`, `macos/tmux/`)

#### Overview
Tmux configuration focused on productivity with vim-like keybindings and a clean interface. Duplicated per platform under `{platform}/tmux/`.

#### Main Configuration File
- `.tmux.conf`: Contains all tmux settings, keybindings, and plugin configurations

#### Key Features
- **Prefix Key**: C-a (Ctrl-a) instead of default Ctrl-b
- **Vim-like Navigation**: Movement between panes using vim keys (h,j,k,l)
- **Smart Pane Switching**: Vim-aware pane navigation with C-h/j/k/l
- **Window Splitting**: | for horizontal, - for vertical splits (preserves current path)
- **Pane Resizing**: Prefix + h/j/k/l for incremental resizing
- **Base Index**: Windows and panes start at 1 (not 0)
- **True Color Support**: Full RGB color support enabled
- **Image Support**: Passthrough enabled for image display in terminal
- **Fast Escape**: No delay for escape key (escape-time 0)

#### Common Commands
- `t` or `tmux`: Start tmux (alias defined in shell config)
- Session management via tmux commands
- Window and pane management

#### Integration Points
- Works seamlessly with the Neovim configuration
- Shell aliases provide quick access
- Color scheme likely matches overall terminal theme

### Ghostty Configuration (`{platform}/ghostty/`)

#### Overview
Modern GPU-accelerated terminal emulator configuration with platform-specific settings and custom theme management. Lives under each platform directory (e.g. `macos/ghostty/`).

#### File Structure
```
{platform}/ghostty/
├── config                 # Main configuration (imports platform-specific configs)
├── config.common          # Common settings across platforms
├── config.linux           # Linux-specific settings
├── config.macos           # macOS-specific settings
├── ghostty-theme-switcher.sh # Theme switcher utility script
├── ghostty-theme-menu.sh     # Interactive theme selection menu
└── ghostty-bg-picker.sh      # Background picker utility
```

#### Key Features
- **Platform-Specific Configs**: Separate files for Linux and macOS with conditional loading
- **Common Configuration**: Shared settings in config.common
- **Modular Design**: Main config imports platform-specific settings
- **Theme Management**: Custom theme switcher scripts for quick theme changes
- **Custom Keybinds**: `Shift+Enter` mapped to newline insertion

### Zellij Configuration (`zellij/`)

#### Overview
Terminal workspace manager similar to tmux but with a modern design philosophy and built-in features. Shared across platforms at the repository root (like `nvim/`) — clipboard copying uses OSC 52 (`copy_clipboard "system"`), which works on both Linux and macOS.

#### Main Configuration Files
- `config.kdl`: KDL format configuration file with custom keybindings and settings
- `themes/`: Kanagawa theme variants (dragon, wave, lotus)
- `switch-theme.sh`: FZF-based theme picker (aliased as `zt` on macOS; Arch machines use their own `bin/switch-theme`)

#### Key Features
- **Mode-Based Operation**: Different modes for different actions (normal, pane, tab, etc.)
- **Vim-like Navigation**: Movement between panes using vim keys (h,j,k,l)
- **Quick Mode Switching**: Ctrl-p for pane mode, Ctrl-t for tab mode
- **Numbered Tab Navigation**: Direct tab access with number keys (1-9)
- **Pane Management**: Split panes right (r), down (d), or stacked (s)
- **Floating Panes**: Toggle floating panes with 'w' in pane mode
- **Session Management**: Built-in session persistence and management

#### Common Keybindings
- `Ctrl-p`: Enter pane mode
- `Ctrl-t`: Enter tab mode
- `Ctrl-g`: Return to normal mode from locked mode
- In pane mode: h/j/k/l for navigation, r/d/s for splits
- In tab mode: h/l or arrow keys for tab navigation

## Key Design Patterns

1. **Neovim Configuration** (`nvim/`)
   - Entry point: `init.lua` loads `lua/config/*`, `lsp`, then every `lua/plugins/*.lua`
   - No plugin manager — native `vim.pack` (lockfile `nvim-pack-lock.json`)
   - Leader key: Space
   - Snacks.nvim for file explorer and fuzzy picker
   - Heavy use of the mini.nvim suite (ai, surround, pairs, move, diff, icons,
     indentscope, cursorword, statusline)
   - which-key.nvim for keybinding hints
   - Native LSP (`vim.lsp.enable`) with 16 language servers — no Mason
   - Git integration with Neogit, gitsigns, mini.diff, and diffview
   - mini.statusline for the statusline; `<C-hjkl>` via vim-tmux-navigator

2. **Shell Environment**
   - Primary shell: zsh with Zinit plugin manager
   - Aliases defined in `{platform}/zsh/.alias`
   - Environment variables and PATH exports in `{platform}/zsh/.zshenv` (non-interactive)
   - Interactive shell configuration in `{platform}/zsh/.zshrc` (plugins, completions, keybindings)
   - Platform-specific configurations in `macos/.macosrc` and `archlinux/.linuxrc`
   - FZF integration for fuzzy finding
   - **Zinit paths**: Checks multiple locations on Linux (`/usr/share/zinit/`, `~/.local/share/zinit/zinit.git/`, `/usr/share/zsh/plugins/zinit/`)
   - **Cross-platform compatibility**: Platform detection ensures macOS and Linux-specific paths are handled correctly

3. **Cross-Platform Support**
   - Configurations work on both macOS and Linux
   - Conditional paths for Homebrew on different architectures
   - Platform-specific tool configurations
   - Wayland and X11 clipboard support

4. **Git Configuration** (`.gitconfig`)
   - User: Eduardo Vedes (eduardo.vedes@gmail.com)
   - GitHub user: evedes
   - Default editor: nvim
   - Default branch: main
   - Pull strategy: rebase
   - Push: auto-setup remote
   - Custom aliases:
     - `fixup`: Interactive fixup commit selection with fzf
     - `gll`: Pretty graph log with colors and author info
   - SSH protocol preference for GitHub URLs

### Important Considerations

1. **No Automated Installation**: This repository requires manual symlinking or copying of dotfiles
2. **External Dependencies**:
   - Required: zsh, git, Neovim
   - Recommended: tmux, fnm, fzf, starship, ripgrep (rg), bat, lazygit, xsel/xclip, wl-clipboard
   - Optional: Zinit (will still work without it), rbenv, cargo, PostgreSQL
3. **SSH Configuration**: References external secrets file (`~/.ssh/load_secrets.sh`)
4. **Machine-Specific Aliases**: Contains SSH shortcuts to personal machines (rubik, prometheus, etc.)

### Development Tool Paths
- Node.js: Managed with fnm, binaries in `~/.local/share/fnm` (PATH in .zshenv, interactive features in .zshrc)
- Ruby: Managed with rbenv (PATH in .zshenv, init in .zshrc)
- Rust: Cargo binaries in `~/.cargo/bin`
- PostgreSQL: Multiple versions in `/usr/lib/postgresql/*/bin` (Linux) or `/opt/homebrew/opt/postgresql@*/bin` (macOS)
- PNPM: Platform-specific homes - `~/Library/pnpm` (macOS) or `~/.local/share/pnpm` (Linux)

## Recent Updates

### Neovim Plugin Updates (2025-10-03)
> **Partially superseded:** the config later moved to native `vim.pack` (no
> lazy.nvim) and replaced `mini.clue` with `which-key.nvim` and `Noice.nvim`
> with `mini.statusline`. Snacks remains the explorer/picker. See the current
> **Neovim Configuration** section above.
- **Snacks.nvim Integration**: Replaced mini.files and mini.pick with Snacks explorer and picker
  - Explorer and picker now show hidden and untracked files by default
  - Configured with comprehensive file exclusion list (node_modules, .git, build artifacts, etc.)
  - Uses "ivy" layout preset for picker
- **Mini.nvim Enhancements**: Added mini.clue for which-key functionality
  - Configured comprehensive key mapping hints
  - 500ms delay before showing hints
  - Bottom-right window placement
- **Noice.nvim**: Enhanced UI for messages, notifications, and command line
- **Flash.nvim**: Added for enhanced navigation and search capabilities
- **Prettier as Default**: Updated to use Prettier by default for formatting
- **Tailwind CSS**: Fixed unknown at-rules warnings

### Ghostty Configuration (2025-09-27)
- Added custom theme management scripts (ghostty-theme-switcher.sh, ghostty-theme-menu.sh, ghostty-bg-picker.sh)
- Enhanced platform-specific configuration files
- Added custom keybind for Shift+Enter

### Neovim Documentation Enhancement (2025-09-15)
- Added comprehensive Neovim commands reference
- Documented initialization flow and architecture patterns
- Added debugging and troubleshooting section
- Enhanced plugin management documentation
- Added LSP configuration workflow details

### Configuration Documentation Updates (2025-09-15)
- Added comprehensive Zellij terminal workspace manager documentation
- Documented key features and keybindings for Zellij configuration
- Updated configuration guides for better clarity

### Directory Structure Reorganization (2025-09-02)
> **Superseded:** the `common/` directory described below was later removed.
> Cross-platform tools (`nvim`, `zellij`) now live at the repository
> root; everything else is duplicated per platform under `archlinux/` and
> `macos/`. See the current **Directory Organization** tree above.
- Reorganized dotfiles into three main directories: `common/`, `archlinux/`, and `macos/`
- Moved cross-platform configurations to `common/` directory
- Separated platform-specific configurations into dedicated folders
- Updated shell configuration paths to reflect new structure
- Fixed Zinit loading path on Arch Linux to use `~/.local/share/zinit/zinit.git/zinit.zsh`

### Ghostty Configuration Updates (2025-08-01)
- Modified Ghostty terminal configurations
- Updated platform-specific settings for Linux and macOS
- Refined common configuration settings

### Performance Optimizations (2025-07-19)
- Consolidated platform detection into single `ZSH_PLATFORM` variable
- Added command existence caching with `has_cmd()` function
- Cached git completions to avoid network requests on startup
- Removed duplicate plugins and configurations
- Optimized Neovim plugin loading (removed duplicate mini.nvim plugins)

### Cross-Platform Improvements (2025-07-19)
- Added Wayland clipboard support with X11 fallback
- Created platform-specific Ghostty terminal configurations
- Fixed hardcoded paths for better portability
- Enhanced Linux clipboard compatibility

### Zsh Configuration Improvements (2025-07-18)
- Fixed Git completion URL to use raw GitHub content
- Added multiple Zinit path checks for better Linux compatibility
- Removed duplicate fnm initialization
- Improved cross-platform support with robust platform detection

## Troubleshooting

### Arch Linux Issues
- If Zinit fails to load, install it manually: `git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git`
- Missing commands can be installed via: `sudo pacman -S bat xsel fzf starship ripgrep wl-clipboard`
- For AUR packages: `yay -S lazygit-bin`

### macOS Issues
- Ensure Homebrew is installed and paths are correctly set
- Zinit via Homebrew: `brew install zinit`

### Performance Issues
- Use `zsh -xv` to debug slow shell startup
- Check for conflicting or duplicate plugin initializations
- Verify command caching is working with `typeset -p _cmd_cache`

### Neovim Issues
- Run `:checkhealth` (and `:checkhealth dotfiles`) to diagnose problems
- Manage plugins with native `vim.pack` — `:lua vim.pack.update()`; check
  `:messages` for plugin load failures
- LSP servers are native (`lsp/*.lua` + `vim.lsp.enable`); there is no Mason —
  install server binaries via the system package manager and confirm with
  `:LspInfo` / `:LspLog`
