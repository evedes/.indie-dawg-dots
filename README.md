# indie-dawg-dots

A cross-platform dotfiles collection designed for keyboard-driven development workflows. Shared Neovim configuration with separate platform directories for macOS and Arch Linux.

## Overview

This repository contains configuration files for:

- **Shell Environment**: Zsh
- **Editor**: Neovim 0.12+ with Lua configuration (uses native `vim.pack.add`, no plugin manager)
- **Terminal**: Ghostty, tmux, zellij
- **Development Tools**: Git, Starship prompt, ripgrep, fzf, and more

## Architecture

Neovim is shared across platforms at the repository root. Everything else lives in a platform-specific directory (`archlinux/` or `macos/`). Duplication across platforms is intentional for independence and simplicity.

```
.indie-dawg-dots/
├── nvim/                  # Shared Neovim configuration (Neovim 0.12+ native packages)
│
├── archlinux/             # Arch Linux configuration
│   ├── bin/               # Custom scripts (ghostty theme switcher, monitor switch, etc.)
│   ├── cava/              # Audio visualizer
│   ├── fontconfig/        # Font configuration
│   ├── fonts/             # Nerd Fonts
│   ├── ghostty/           # Terminal emulator
│   ├── hypr/              # Hyprland window manager
│   ├── mako/              # Notification daemon
│   ├── quickshell/        # Wayland shell (QML)
│   ├── starship/          # Cross-shell prompt
│   ├── tmux/              # Terminal multiplexer
│   ├── udev/              # Custom udev rules
│   ├── zellij/            # Terminal workspace manager
│   ├── zsh/               # Shell configuration (.zshrc, .zshenv, .alias)
│   ├── .gitconfig         # Git configuration
│   ├── .gitignore         # Global gitignore
│   ├── .ripgreprc         # Search tool config
│   └── .vimrc             # Vim fallback config
│
├── macos/                 # macOS configuration
│   ├── bin/               # Custom scripts
│   ├── cava/              # Audio visualizer
│   ├── fonts/             # Nerd Fonts
│   ├── ghostty/           # Terminal emulator
│   ├── starship/          # Cross-shell prompt
│   ├── tmux/              # Terminal multiplexer
│   ├── zellij/            # Terminal workspace manager
│   ├── zsh/               # Shell configuration (.zshrc, .zshenv, .alias)
│   ├── .gitconfig         # Git configuration
│   ├── .gitignore         # Global gitignore
│   ├── .ripgreprc         # Search tool config
│   └── .vimrc             # Vim fallback config
│
├── CLAUDE.md              # Comprehensive documentation
├── LICENSE
└── README.md
```

## Installation

### Prerequisites

```bash
# macOS (via Homebrew)
brew install git zsh neovim tmux fzf starship ripgrep bat lazygit mise

# Arch Linux
sudo pacman -S git zsh neovim tmux fzf starship ripgrep bat xsel wl-clipboard mise
yay -S lazygit-bin
```

Neovim **0.12 or newer** is required (the config uses the native `vim.pack.add` API).

### Setup (macOS)

```bash
git clone https://github.com/evedes/indie-dawg-dots.git ~/.indie-dawg-dots
cd ~/.indie-dawg-dots

# Shell
ln -sf ~/.indie-dawg-dots/macos/zsh/.zshenv ~/.zshenv

# Neovim (shared)
ln -sf ~/.indie-dawg-dots/nvim ~/.config/nvim

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
ln -sf ~/.indie-dawg-dots/archlinux/zsh/.zshenv ~/.zshenv

# Neovim (shared)
ln -sf ~/.indie-dawg-dots/nvim ~/.config/nvim

# Git
ln -sf ~/.indie-dawg-dots/archlinux/.gitconfig ~/.gitconfig
ln -sf ~/.indie-dawg-dots/archlinux/.gitignore ~/.gitignore

# Terminal tools
ln -sf ~/.indie-dawg-dots/archlinux/ghostty ~/.config/ghostty
ln -sf ~/.indie-dawg-dots/archlinux/tmux ~/.config/tmux
ln -sf ~/.indie-dawg-dots/archlinux/zellij ~/.config/zellij
ln -sf ~/.indie-dawg-dots/archlinux/starship ~/.config/starship

# Hyprland stack (optional)
ln -sf ~/.indie-dawg-dots/archlinux/hypr ~/.config/hypr
ln -sf ~/.indie-dawg-dots/archlinux/mako ~/.config/mako
ln -sf ~/.indie-dawg-dots/archlinux/quickshell ~/.config/quickshell

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

Edit files directly in the relevant directory:

- **Neovim (shared)**: `nvim/lua/plugins/`, `nvim/lua/config/`
- **Aliases**: `{platform}/zsh/.alias`
- **Shell config**: `{platform}/zsh/.zshrc`
- **Environment vars**: `{platform}/zsh/.zshenv`

## Troubleshooting

See [CLAUDE.md](./CLAUDE.md) for detailed documentation and troubleshooting guides.

## License

This repository is provided as-is for personal use.
