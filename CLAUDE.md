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
│   └── ...           # Other tool configs
├── .gitconfig        # Git configuration with custom aliases
├── .zshenv          # Environment variables for development tools
└── .ripgreprc       # Search tool configuration
```

### Key Design Patterns

1. **Neovim Configuration** (`~/.config/nvim/`)
   - Entry point: `lua/edo/init.lua`
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

### Important Considerations

1. **No Automated Installation**: This repository requires manual symlinking or copying of dotfiles
2. **External Dependencies**: 
   - Required: zsh, git, Neovim
   - Recommended: tmux, fnm, fzf, starship, ripgrep (rg), bat, lazygit, xsel/xclip
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

### Zsh Configuration Improvements (2025-07-18)
- Fixed Git completion URL to use raw GitHub content
- Added multiple Zinit path checks for better Linux compatibility
- Removed duplicate fnm initialization
- Improved cross-platform support with robust platform detection

## Troubleshooting

### Arch Linux Issues
- If Zinit fails to load, install it manually: `git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit`
- Missing commands can be installed via: `sudo pacman -S bat xsel fzf starship ripgrep`
- For AUR packages: `yay -S lazygit-bin`

### macOS Issues
- Ensure Homebrew is installed and paths are correctly set
- Zinit via Homebrew: `brew install zinit`