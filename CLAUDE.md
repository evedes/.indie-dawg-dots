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
├── nvim/             # Neovim configuration (primary, Lua-based with lazy.nvim)
├── lazynvim/         # Alternative LazyVim distribution configuration
├── common/           # Cross-platform configurations
│   ├── zsh/          # Shell configuration and aliases
│   ├── tmux/         # Terminal multiplexer
│   ├── starship/     # Cross-shell prompt
│   ├── ghostty/      # Terminal emulator (includes theme switcher scripts)
│   ├── zellij/       # Terminal workspace manager
│   ├── cava/         # Audio visualizer
│   ├── emacs/        # Emacs configuration
│   └── fontconfig/   # Font configuration
├── archlinux/        # Linux-specific configurations
│   ├── hypr/         # Hyprland window manager
│   ├── waybar/       # Wayland bar configuration
│   ├── rofi/         # Application launcher
│   ├── mako/         # Wayland notification daemon
│   ├── chromium/     # Chromium browser configuration
│   └── .linuxrc      # Linux-specific shell configuration
├── macos/            # macOS-specific configurations
│   └── .macosrc      # macOS-specific shell configuration
├── fonts/            # Custom fonts (BerkeleyMono, JetBrainsMono, ZedMono Nerd Fonts)
├── .gitconfig        # Git configuration with custom aliases
├── .zshenv           # Environment variables for development tools
├── .ripgreprc        # Search tool configuration
├── .vimrc            # Basic vim configuration (fallback)
└── .claude/          # Claude-specific configuration
```

## Detailed Configuration Guides

### Neovim Configuration (`nvim/`)

#### Overview
A modern Neovim configuration built with Lua, focusing on minimalism and efficiency. Uses Snacks.nvim for file navigation and fuzzy finding, alongside the mini.nvim plugin suite for core functionality.

#### Structure
```
nvim/
├── init.lua              # Entry point - sequential module loading
├── lua/
│   ├── config/           # Core configuration modules
│   │   ├── autocmds.lua  # Autocommands (yank highlight, terminal settings)
│   │   ├── keymaps.lua   # Global key mappings
│   │   ├── lazy.lua      # Plugin manager bootstrap & setup
│   │   ├── options.lua   # Neovim options (UI, editor behavior)
│   │   └── theme-switcher.lua # Custom theme management system
│   ├── plugins/          # Individual plugin configs (18 files)
│   │   ├── mini.lua      # Mini.nvim suite (11+ modules)
│   │   ├── snacks.lua    # Snacks.nvim (explorer, picker, notifier)
│   │   ├── conform.lua   # Code formatting setup
│   │   ├── blink.lua     # Blink completion engine
│   │   ├── neogit.lua    # Git integration
│   │   ├── gitsigns.lua  # Git signs in gutter
│   │   ├── treesitter.lua # Syntax highlighting
│   │   ├── diffview.lua  # Git diff viewer
│   │   ├── noice.lua     # Enhanced UI messages
│   │   ├── flash.lua     # Enhanced navigation
│   │   ├── obsidian.lua  # Note-taking integration
│   │   ├── supermaven.lua # AI completion
│   │   ├── tiny-code-action.lua # LSP code actions
│   │   ├── markview.lua  # Markdown preview
│   │   ├── dadbod.lua    # Database interface
│   │   ├── autotag.lua   # HTML/JSX auto-closing
│   │   ├── schemastore.lua # JSON schemas
│   │   └── kanagawa-theme.lua # Kanagawa theme
│   ├── lsp.lua           # Centralized LSP configuration & keymaps
│   └── icons.lua         # Icon definitions for UI consistency
├── lsp/                  # Language-specific LSP configs (15 servers)
│   ├── vtsls.lua         # TypeScript/JavaScript
│   ├── lua.lua           # Lua LSP with Neovim API support
│   ├── bash.lua          # Bash LSP setup
│   ├── eslint.lua        # ESLint integration
│   ├── tailwindcss.lua   # Tailwind CSS
│   ├── html.lua          # HTML
│   ├── css.lua           # CSS
│   ├── json.lua          # JSON
│   ├── yaml.lua          # YAML
│   ├── volar.lua         # Vue
│   ├── emmet.lua         # Emmet
│   ├── dprint.lua        # Dprint formatter
│   ├── stylelint.lua     # CSS linting
│   └── clangd.lua        # C/C++
├── after/                # After-plugin configurations
├── lazy-lock.json        # Plugin version lock file
├── theme-preference.txt  # Saved theme preference
└── stylua.toml           # Lua formatter configuration
```

#### Initialization Flow
1. `init.lua` loads modules in sequence:
   - `config.options` - Sets vim options
   - `config.keymaps` - Defines global keybindings
   - `config.autocmds` - Sets up autocommands
   - `config.lazy` - Bootstraps and configures lazy.nvim
   - `lsp` - Initializes LSP configuration
2. After VeryLazy event: `config.theme-switcher` initializes
3. Plugins load on-demand based on events/commands/filetypes

#### Key Features
- **Plugin Manager**: lazy.nvim for fast startup times
- **Leader Key**: Space
- **File Navigation**: Snacks.nvim explorer and picker (shows untracked files by default)
- **Plugin Suite**: Heavy use of mini.nvim modules (11+ modules including mini.clue for which-key)
- **LSP**: Integrated LSP support with 15 language servers configured (TypeScript, Lua, Bash, ESLint, HTML, CSS, JSON, YAML, Vue, Emmet, Tailwind, Dprint, Stylelint, Clangd)
- **Git Integration**: Neogit, gitsigns.nvim, diffview.nvim, and mini.diff
- **Completion**: Blink.cmp completion engine
- **AI Integration**: Supermaven for AI-powered code suggestions
- **Theme**: Kanagawa theme with persistent preference saving
- **Code Actions**: Tiny code action for minimal UI
- **Enhanced UI**: Noice.nvim for better messages, notifications, and command line
- **Navigation**: Flash.nvim for enhanced navigation and search
- **Markdown**: Markview for enhanced markdown preview
- **Database**: Dadbod for database operations

#### Important Patterns
1. **Modular Configuration**: Each major feature has its own file in `lua/config/`
2. **Lazy Loading**: Plugins are loaded on-demand where possible
3. **Minimal Dependencies**: Prefer mini.nvim modules over separate plugins

#### Common Neovim Commands

##### Plugin Management (lazy.nvim)
- `:Lazy` - Open lazy.nvim UI
- `:Lazy sync` - Install, update, and clean plugins
- `:Lazy update` - Update plugins only
- `:Lazy restore` - Restore plugins from lock file
- `:Lazy profile` - Profile plugin load times

##### LSP Commands
- `:Mason` - Open Mason UI to manage language servers
- `:LspInfo` - Show active LSP servers
- `:LspStop` / `:LspStart` - Control LSP servers
- `gd` / `gD` - Go to definition (with picker for multiple)
- `grr` - Find references
- `gra` - Code actions (tiny UI)
- `gy` - Type definition
- `[d` / `]d` - Navigate diagnostics

##### File Navigation
- `<leader>fe` - Open Snacks explorer (shows hidden/untracked files)
- `<leader>ee` - Explorer at current file
- `<leader>ff` - Find files (Snacks picker, includes untracked files)
- `<leader>/` - Live grep (Snacks)
- `<leader>bb` - Buffer picker
- `<leader>fh` - Help search
- `<leader>cc` - Resume last picker

##### Enhanced Navigation (Flash.nvim & Mini.nvim)
- `s` - Flash jump to any location
- `S` - Flash treesitter jump
- `r` (in operator-pending) - Remote Flash
- `R` - Treesitter search
- `<C-s>` (in command mode) - Toggle Flash search
- `<CR>` - Jump anywhere (mini.jump2d in normal mode)
- `f`/`F`/`t`/`T` - Enhanced character find (mini.jump)

##### Code Formatting
- Auto-format on save (via conform.nvim)
- `:ConformInfo` - Show formatter info for current buffer
- Formatters configured: Prettier, dprint, stylua, shfmt, mix_format

##### Git Integration
- `<leader>gg` - Open Neogit
- `<leader>go` - Toggle diff overlay (mini.diff)
- `:DiffviewOpen` - Open diffview
- `:Gitsigns` commands for hunk operations

##### Theme Management
- `<leader>ut` - Open theme picker
- `<leader>uT` - Cycle through themes
- Themes: Kanagawa (dragon/wave/lotus), Catppuccin (mocha/macchiato/frappe/latte)

#### Common Development Tasks

##### Adding a Plugin
1. Create a new file in `lua/plugins/` or edit existing plugin file
2. Follow the lazy.nvim specification format:
   ```lua
   return {
     "author/plugin-name",
     event = "BufReadPre", -- or cmd, keys, ft for lazy loading
     opts = {}, -- or config = function() end
   }
   ```
3. Run `:Lazy sync` to install

##### Modifying Keymaps
- Main keymaps: `lua/config/keymaps.lua`
- Plugin-specific: In respective plugin files under `lua/plugins/`
- Use `with_desc()` helper for consistent descriptions

##### Adding LSP Support for a Language
1. Create a new file in `lsp/` directory (e.g., `lsp/rust.lua`)
2. Follow existing LSP configuration pattern
3. Install server via `:Mason` or configure in the file
4. LSP will auto-load on next restart

##### Customizing Formatters
1. Edit `lua/plugins/conform.lua`
2. Add language to `formatters_by_ft` table
3. Install formatter if needed (via Mason or system package manager)

#### Debugging & Troubleshooting

##### Health Check
- `:checkhealth` - Full system diagnostic
- `:checkhealth lazy` - Check lazy.nvim status
- `:checkhealth lsp` - Check LSP configuration

##### Plugin Issues
- `:Lazy log` - View plugin update log
- `:Lazy profile` - Identify slow plugins
- `:messages` - View Neovim messages/errors

##### LSP Debugging
- `:LspInfo` - Current buffer LSP status
- `:LspLog` - View LSP log file
- `vim.lsp.set_log_level("debug")` - Enable debug logging

##### Performance
- `nvim --startuptime startup.log` - Profile startup time
- `:InspectTree` - Inspect treesitter parse tree
- `:Inspect` - Inspect highlight groups under cursor

#### Dependencies
- Neovim >= 0.10.0 (required for some mini.nvim features)
- Git (for plugin management)
- Node.js (for many LSP servers and formatters)
- Ripgrep (for search features)
- fd (optional, for better file finding)
- Lua formatter: stylua (install via cargo or Mason)
- C compiler (for treesitter parser compilation)

### Zsh Configuration (`common/zsh/`, `archlinux/`, `macos/`)

#### Overview
A cross-platform Zsh configuration designed to work seamlessly on both macOS and Linux (especially Arch Linux).

#### File Structure
```
common/zsh/
├── .zshrc       # Main interactive shell configuration
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

### Tmux Configuration (`common/tmux/`)

#### Overview
Tmux configuration focused on productivity with vim-like keybindings and a clean interface.

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

### Ghostty Configuration (`common/ghostty/`)

#### Overview
Modern GPU-accelerated terminal emulator configuration with platform-specific settings and custom theme management.

#### File Structure
```
common/ghostty/
├── config                 # Main configuration (imports platform-specific configs)
├── config.common          # Common settings across platforms
├── config.linux           # Linux-specific settings
├── config.macos           # macOS-specific settings
├── ghostty-theme-switcher # Theme switcher utility script
├── ghostty-theme-menu     # Interactive theme selection menu
└── ghostty-bg-picker      # Background picker utility
```

#### Key Features
- **Platform-Specific Configs**: Separate files for Linux and macOS with conditional loading
- **Common Configuration**: Shared settings in config.common
- **Modular Design**: Main config imports platform-specific settings
- **Theme Management**: Custom theme switcher scripts for quick theme changes
- **Custom Keybinds**: `Shift+Enter` mapped to newline insertion

### Zellij Configuration (`common/zellij/`)

#### Overview
Terminal workspace manager similar to tmux but with a modern design philosophy and built-in features.

#### Main Configuration File
- `config.kdl`: KDL format configuration file with custom keybindings and settings

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
   - Entry point: `init.lua` loads `lua/config/`
   - Modular Lua configuration using lazy.nvim plugin manager
   - Leader key: Space
   - Snacks.nvim for file explorer and fuzzy picker
   - Heavy use of mini.nvim plugin suite (11+ modules including mini.clue)
   - LSP support with 15 language servers
   - Git integration with Neogit, gitsigns, and mini.diff
   - Noice.nvim for enhanced UI messages and notifications

2. **Shell Environment**
   - Primary shell: zsh with Zinit plugin manager
   - Aliases defined in `common/zsh/.alias`
   - Environment variables and PATH exports in `.zshenv` (cross-platform, non-interactive)
   - Interactive shell configuration in `common/zsh/.zshrc` (plugins, completions, keybindings)
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
- Added custom theme management scripts (ghostty-theme-switcher, ghostty-theme-menu, ghostty-bg-picker)
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
- Run `:checkhealth` to diagnose configuration problems
- Use `:Lazy` to manage plugins and check for errors
- Verify LSP servers are installed with `:Mason`
