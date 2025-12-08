# indie-dawg-dots

A cross-platform dotfiles collection designed for keyboard-driven development workflows. Fully separated configurations for macOS and Arch Linux.

## Overview

This repository contains configuration files for:

- **Shell Environment**: Zsh with Zinit plugin management
- **Editor**: Neovim with Lua configuration and mini.nvim plugin suite
- **Terminal**: Ghostty, tmux, zellij
- **Development Tools**: Git, Starship prompt, ripgrep, fzf, and more

## Architecture

Each platform has its own complete, self-contained configuration. No shared files - duplication is intentional for independence and simplicity.

```
.indie-dawg-dots/
├── archlinux/             # Complete Arch Linux configuration
│   ├── nvim/              # Neovim (Lua-based with lazy.nvim)
│   ├── zsh/               # Shell configuration (.zshrc, .alias)
│   ├── tmux/              # Terminal multiplexer
│   ├── ghostty/           # Terminal emulator
│   ├── starship/          # Cross-shell prompt
│   ├── zellij/            # Terminal workspace manager
│   ├── fonts/             # Nerd Fonts
│   ├── hypr/              # Hyprland window manager
│   ├── waybar/            # Wayland bar
│   ├── rofi/              # Application launcher
│   ├── mako/              # Notification daemon
│   ├── chromium/          # Browser config
│   ├── cava/              # Audio visualizer
│   ├── emacs/             # Emacs configuration
│   ├── fontconfig/        # Font configuration
│   ├── .gitconfig         # Git configuration
│   ├── .gitignore         # Global gitignore
│   ├── .zshenv            # Environment variables
│   ├── .ripgreprc         # Search tool config
│   ├── .vimrc             # Vim fallback config
│   └── .linuxrc           # Linux-specific shell settings
│
├── macos/                 # Complete macOS configuration
│   ├── nvim/              # Neovim (Lua-based with lazy.nvim)
│   ├── zsh/               # Shell configuration (.zshrc, .alias)
│   ├── tmux/              # Terminal multiplexer
│   ├── ghostty/           # Terminal emulator
│   ├── starship/          # Cross-shell prompt
│   ├── zellij/            # Terminal workspace manager
│   ├── fonts/             # Nerd Fonts
│   ├── cava/              # Audio visualizer
│   ├── emacs/             # Emacs configuration
│   ├── fontconfig/        # Font configuration
│   ├── .gitconfig         # Git configuration
│   ├── .gitignore         # Global gitignore
│   ├── .zshenv            # Environment variables
│   ├── .ripgreprc         # Search tool config
│   ├── .vimrc             # Vim fallback config
│   └── .macosrc           # macOS-specific shell settings
│
├── CLAUDE.md              # Comprehensive documentation
├── LICENSE
└── README.md
```

## Installation

### Prerequisites

```bash
# macOS (via Homebrew)
brew install git zsh neovim tmux fzf starship ripgrep bat lazygit zinit fnm

# Arch Linux
sudo pacman -S git zsh neovim tmux fzf starship ripgrep bat xsel wl-clipboard
yay -S lazygit-bin
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit
```

### Setup (macOS)

```bash
git clone https://github.com/evedes/indie-dawg-dots.git ~/.indie-dawg-dots
cd ~/.indie-dawg-dots

# Shell
ln -sf ~/.indie-dawg-dots/macos/.zshenv ~/.zshenv
ln -sf ~/.indie-dawg-dots/macos/zsh ~/.config/zsh

# Neovim
ln -sf ~/.indie-dawg-dots/macos/nvim ~/.config/nvim

# Git
ln -sf ~/.indie-dawg-dots/macos/.gitconfig ~/.gitconfig
ln -sf ~/.indie-dawg-dots/macos/.gitignore ~/.gitignore

# Terminal tools
ln -sf ~/.indie-dawg-dots/macos/ghostty ~/.config/ghostty
ln -sf ~/.indie-dawg-dots/macos/tmux ~/.config/tmux
ln -sf ~/.indie-dawg-dots/macos/zellij ~/.config/zellij
ln -sf ~/.indie-dawg-dots/macos/starship ~/.config/starship

# Other
ln -sf ~/.indie-dawg-dots/macos/.ripgreprc ~/.ripgreprc

# Set Zsh as default shell
chsh -s $(which zsh)
```

### Setup (Arch Linux)

```bash
git clone https://github.com/evedes/indie-dawg-dots.git ~/.indie-dawg-dots
cd ~/.indie-dawg-dots

# Shell
ln -sf ~/.indie-dawg-dots/archlinux/.zshenv ~/.zshenv
ln -sf ~/.indie-dawg-dots/archlinux/zsh ~/.config/zsh

# Neovim
ln -sf ~/.indie-dawg-dots/archlinux/nvim ~/.config/nvim

# Git
ln -sf ~/.indie-dawg-dots/archlinux/.gitconfig ~/.gitconfig
ln -sf ~/.indie-dawg-dots/archlinux/.gitignore ~/.gitignore

# Terminal tools
ln -sf ~/.indie-dawg-dots/archlinux/ghostty ~/.config/ghostty
ln -sf ~/.indie-dawg-dots/archlinux/tmux ~/.config/tmux
ln -sf ~/.indie-dawg-dots/archlinux/zellij ~/.config/zellij
ln -sf ~/.indie-dawg-dots/archlinux/starship ~/.config/starship

# Hyprland (optional)
ln -sf ~/.indie-dawg-dots/archlinux/hypr ~/.config/hypr
ln -sf ~/.indie-dawg-dots/archlinux/waybar ~/.config/waybar
ln -sf ~/.indie-dawg-dots/archlinux/rofi ~/.config/rofi
ln -sf ~/.indie-dawg-dots/archlinux/mako ~/.config/mako

# Other
ln -sf ~/.indie-dawg-dots/archlinux/.ripgreprc ~/.ripgreprc

# Set Zsh as default shell
chsh -s $(which zsh)
```

## Quick Commands

Once installed:

- `dots` - navigate to dotfiles and open in Neovim
- `r` - reload shell configuration
- `v` / `nvim` - open Neovim
- `lg` - open LazyGit
- `t` - start tmux

## Customization

Each platform is independent. Edit files directly in the platform directory:

- **Aliases**: `{platform}/zsh/.alias`
- **Shell config**: `{platform}/zsh/.zshrc`
- **Neovim plugins**: `{platform}/nvim/lua/plugins/`
- **Platform-specific shell**: `archlinux/.linuxrc` or `macos/.macosrc`

## Troubleshooting

See [CLAUDE.md](./CLAUDE.md) for detailed documentation and troubleshooting guides.

## License

This repository is provided as-is for personal use.
