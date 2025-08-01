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
├── .config/           # Application configurations
│   ├── nvim/         # Neovim (Lua-based config with lazy.nvim)
│   ├── zsh/          # Shell configuration and aliases
│   ├── tmux/         # Terminal multiplexer
│   ├── starship/     # Cross-shell prompt
│   ├── ghostty/      # Terminal emulator
│   ├── hypr/         # Hyprland window manager (Linux)
│   ├── waybar/       # Wayland bar configuration (Linux)
│   ├── rofi/         # Application launcher
│   ├── cava/         # Audio visualizer
│   ├── emacs/        # Emacs configuration
│   └── fontconfig/   # Font configuration
├── .gitconfig        # Git configuration with custom aliases
├── .zshenv          # Environment variables for development tools
├── .ripgreprc       # Search tool configuration
├── .vimrc           # Basic vim configuration (fallback)
├── fonts/           # Custom fonts directory
└── .claude/         # Claude-specific configuration
```

## Detailed Configuration Guides

### Neovim Configuration (`.config/nvim/`)

#### Overview
A modern Neovim configuration built with Lua, focusing on minimalism and efficiency using the mini.nvim plugin suite extensively.

#### Structure
```
.config/nvim/
├── init.lua              # Entry point - loads lua/config/
├── lua/
│   ├── config/           # Main configuration files
│   │   ├── autocmds.lua  # Autocommands
│   │   ├── keymaps.lua   # Key mappings
│   │   ├── lazy.lua      # Plugin manager setup
│   │   └── options.lua   # Neovim options
│   ├── plugins/          # Plugin configurations
│   ├── lsp.lua          # LSP configuration
│   └── icons.lua        # Icon definitions
├── lsp/                 # LSP-specific configuration
├── after/               # After plugin configurations
├── lazy-lock.json       # Plugin version lock file
└── stylua.toml          # Lua formatter configuration
```

#### Key Features
- **Plugin Manager**: lazy.nvim for fast startup times
- **Leader Key**: Space
- **Plugin Suite**: Heavy use of mini.nvim modules for core functionality
- **LSP**: Integrated LSP support with custom configuration
- **Git Integration**: Neogit, gitsigns.nvim, and diffview.nvim
- **Completion**: Blink completion engine
- **AI Integration**: Supermaven for AI-powered code suggestions
- **Theme**: Kanagawa theme with custom configurations
- **Code Actions**: Tiny code action for minimal UI
- **Markdown**: Markview for enhanced markdown preview

#### Important Patterns
1. **Modular Configuration**: Each major feature has its own file in `lua/config/`
2. **Lazy Loading**: Plugins are loaded on-demand where possible
3. **Minimal Dependencies**: Prefer mini.nvim modules over separate plugins

#### Common Tasks

##### Adding a Plugin
1. Create a new file in `lua/plugins/` or edit existing plugin file
2. Follow the lazy.nvim specification format
3. Run `:Lazy sync` to install

##### Modifying Keymaps
- Main keymaps are in `lua/config/keymaps.lua`
- Plugin-specific keymaps are in their respective plugin files

##### LSP Configuration
- Language servers are managed through Mason
- LSP configuration is in `lua/plugins/lsp.lua`

#### Dependencies
- Neovim >= 0.9.0
- Git (for plugin management)
- Node.js (for many LSP servers)
- Ripgrep (for telescope and other search features)

### Zsh Configuration (`.config/zsh/`)

#### Overview
A cross-platform Zsh configuration designed to work seamlessly on both macOS and Linux (especially Arch Linux).

#### File Structure
```
.config/zsh/
├── .zshrc       # Main interactive shell configuration
├── .alias       # Shell aliases and functions
├── .linuxrc     # Linux-specific configurations
├── .macosrc     # macOS-specific configurations
└── yay/         # AUR helper configuration (Arch Linux)
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
- `.linuxrc`: Linux-specific paths, configurations, and Wayland/X11 clipboard support
- `.macosrc`: macOS-specific paths and Homebrew setup

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
1. Edit `.linuxrc` or `.macosrc`
2. Use platform detection for conditional logic
3. Test on both platforms if possible

### Tmux Configuration (`.config/tmux/`)

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

### Ghostty Configuration (`.config/ghostty/`)

#### Overview
Modern GPU-accelerated terminal emulator configuration with platform-specific settings.

#### File Structure
```
.config/ghostty/
├── config         # Main configuration (imports platform-specific configs)
├── config.common  # Common settings across platforms
├── config.linux   # Linux-specific settings
└── config.macos   # macOS-specific settings
```

#### Key Features
- **Platform-Specific Configs**: Separate files for Linux and macOS
- **Common Configuration**: Shared settings in config.common
- **Modular Design**: Main config imports platform-specific settings

## Key Design Patterns

1. **Neovim Configuration** (`~/.config/nvim/`)
   - Entry point: `init.lua` loads `lua/config/`
   - Modular Lua configuration using lazy.nvim plugin manager
   - Leader key: Space
   - Heavy use of mini.nvim plugin suite
   - LSP support via Mason
   - Git integration with Neogit and gitsigns

2. **Shell Environment**
   - Primary shell: zsh with Zinit plugin manager
   - Aliases defined in `.config/zsh/.alias`
   - Environment variables and PATH exports in `.zshenv` (cross-platform, non-interactive)
   - Interactive shell configuration in `.config/zsh/.zshrc` (plugins, completions, keybindings)
   - Platform-specific configurations in `.config/zsh/.{macos,linux}rc`
   - FZF integration for fuzzy finding
   - **Zinit paths**: Checks multiple locations on Linux (`/usr/share/zinit/`, `~/.local/share/zinit/`, `/usr/share/zsh/plugins/zinit/`)
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
- If Zinit fails to load, install it manually: `git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit`
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