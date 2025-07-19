# indie-dawg-dots

A comprehensive, cross-platform dotfiles collection designed for keyboard-driven development workflows. Optimized for both macOS and Linux with a focus on modern CLI tools, Neovim, and efficient shell environments.

## 🎯 Overview

This repository contains carefully crafted configuration files for:

- **Shell Environment**: Zsh with Zinit plugin management and cross-platform compatibility
- **Editor**: Neovim with Lua configuration and mini.nvim plugin suite
- **Terminal**: Ghostty, tmux configurations
- **Development Tools**: Git, Starship prompt, ripgrep, fzf, and more
- **Platform Support**: Seamless operation on both macOS and Linux (especially Arch)

## ✨ Key Features

- 🚀 **Performance Optimized**: Command caching, lazy loading, minimal startup times
- 🌍 **Cross-Platform**: Works on macOS and Linux with intelligent platform detection
- ⌨️ **Keyboard-Driven**: Vim-like keybindings and efficient workflows
- 🎨 **Modern Tooling**: Latest CLI tools with sensible defaults
- 📱 **Wayland Support**: Native Wayland clipboard integration with X11 fallback
- 🔧 **Modular Design**: Easy to customize and extend

## 📦 Installation

### Prerequisites

Install these tools before setting up the dotfiles:

#### Required Dependencies

```bash
# Core tools (must have)
git zsh neovim

# macOS (via Homebrew)
brew install git zsh neovim

# Arch Linux
sudo pacman -S git zsh neovim

# Ubuntu/Debian
sudo apt install git zsh neovim
```

#### Recommended Dependencies

```bash
# Enhanced CLI experience
tmux fzf starship ripgrep bat lazygit

# macOS
brew install tmux fzf starship ripgrep bat lazygit

# Arch Linux
sudo pacman -S tmux fzf starship ripgrep bat
yay -S lazygit-bin

# Ubuntu/Debian
sudo apt install tmux fzf ripgrep bat
# Note: starship and lazygit may need manual installation
```

#### Optional Dependencies

```bash
# Clipboard tools (Linux)
xsel xclip wl-clipboard  # For X11/Wayland clipboard support

# Development tools
fnm rbenv cargo          # Node.js, Ruby, Rust toolchains

# Fonts
# Install a Nerd Font for proper icon display
# Recommended: ZedMono Nerd Font Mono
```

### Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/indie-dawg-dots.git ~/.indie-dawg-dots
   cd ~/.indie-dawg-dots
   ```

2. **Create symlinks** (manual process - no automated installer)

   ```bash
   # Shell configuration
   ln -sf ~/.indie-dawg-dots/.zshenv ~/.zshenv
   ln -sf ~/.indie-dawg-dots/.config/zsh ~/.config/zsh

   # Neovim
   ln -sf ~/.indie-dawg-dots/.config/nvim ~/.config/nvim

   # Git
   ln -sf ~/.indie-dawg-dots/.gitconfig ~/.gitconfig

   # Terminal configurations
   ln -sf ~/.indie-dawg-dots/.config/ghostty ~/.config/ghostty
   ln -sf ~/.indie-dawg-dots/.config/tmux ~/.config/tmux

   # Other tools
   ln -sf ~/.indie-dawg-dots/.config/starship ~/.config/starship
   ln -sf ~/.indie-dawg-dots/.ripgreprc ~/.ripgreprc
   ```

3. **Set Zsh as default shell**

   ```bash
   chsh -s $(which zsh)
   ```

4. **Install Zinit** (Zsh plugin manager)

   ```bash
   # Linux
   git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit

   # macOS
   brew install zinit
   ```

5. **Reload shell configuration**
   ```bash
   source ~/.zshenv
   exec zsh
   ```

## 🛠 Configuration Structure

```
.indie-dawg-dots/
├── .config/
│   ├── nvim/              # Neovim configuration (Lua)
│   │   ├── lua/config/    # Core settings
│   │   └── lua/plugins/   # Plugin configurations
│   ├── zsh/               # Shell configuration
│   │   ├── .zshrc         # Main shell config
│   │   ├── .alias         # Command aliases
│   │   ├── .linuxrc       # Linux-specific settings
│   │   └── .macosrc       # macOS-specific settings
│   ├── ghostty/           # Terminal emulator
│   │   ├── config.common  # Shared settings
│   │   ├── config.macos   # macOS-specific
│   │   └── config.linux   # Linux-specific
│   ├── tmux/              # Terminal multiplexer
│   └── starship/          # Cross-shell prompt
├── .gitconfig             # Git configuration
├── .zshenv               # Environment variables
├── .ripgreprc            # Search tool config
└── CLAUDE.md             # Comprehensive documentation
```

## 🚀 Quick Start Commands

Once installed, these aliases and commands are available:

### Dotfiles Management

- `dots` - navigate to dotfiles directory and open in Neovim
- `r` - reload shell configuration
- `aa` - edit aliases
- `zz` - edit zshrc

### Development Workflow

- `v` / `nvim` - open Neovim
- `nconf` - edit Neovim configuration
- `lg` - open LazyGit
- `t` - start tmux

### Docker Shortcuts

- `dps` - docker ps
- `dcu` - docker compose up
- `dcd` - docker compose down

## 📋 Dependencies by Platform

### macOS

```bash
# Via Homebrew
brew install git zsh neovim tmux fzf starship ripgrep bat lazygit zinit fnm
```

### Arch Linux

```bash
# Core packages
sudo pacman -S git zsh neovim tmux fzf starship ripgrep bat xsel wl-clipboard

# AUR packages
yay -S lazygit-bin

# Manual installs
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit
curl -fsSL https://fnm.vercel.app/install | bash
```

### Ubuntu/Debian

```bash
# Core packages
sudo apt install git zsh neovim tmux fzf ripgrep bat xsel xclip

# Manual installs (latest versions)
# Starship: curl -sS https://starship.rs/install.sh | sh
# LazyGit: See https://github.com/jesseduffield/lazygit#installation
# Zinit: git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit
# fnm: curl -fsSL https://fnm.vercel.app/install | bash
```

## 🎨 Screenshots

> **Note**: Screenshots will be added here showing:
>
> - Neovim with configured theme and plugins
> - Terminal with Starship prompt
> - tmux session with custom status bar
> - Overall workflow demonstration

## 🔧 Customization

### Adding New Aliases

Edit `.config/zsh/.alias` and reload with `r` command.

### Modifying Neovim Plugins

Add/modify files in `.config/nvim/lua/plugins/` and run `:Lazy sync` in Neovim.

### Platform-Specific Configurations

- **Linux**: Edit `.config/zsh/.linuxrc`
- **macOS**: Edit `.config/zsh/.macosrc`

## 🐛 Troubleshooting

### Shell Issues

**Zinit not loading:**

```bash
# Ensure Zinit is installed in the correct location
ls -la ~/.local/share/zinit  # Linux
ls -la /opt/homebrew/opt/zinit  # macOS

# Reinstall if needed
rm -rf ~/.local/share/zinit
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit
```

**Slow shell startup:**

```bash
# Debug startup time
zsh -xv

# Check command cache
typeset -p _cmd_cache
```

**Missing commands:**

- Install required dependencies for your platform
- Check if commands are in PATH: `echo $PATH`
- Verify platform detection: `echo $ZSH_PLATFORM`

### Neovim Issues

**Plugins not loading:**

```bash
# In Neovim
:checkhealth
:Lazy sync
:Mason
```

**LSP servers not working:**

```bash
# Install language servers via Mason
:Mason
# Or manually install required tools (Node.js, etc.)
```

### Linux-Specific Issues

**Clipboard not working:**

```bash
# Install clipboard tools
sudo pacman -S xsel xclip wl-clipboard  # Arch
sudo apt install xsel xclip wl-clipboard  # Ubuntu

# Check Wayland/X11 detection
echo $WAYLAND_DISPLAY
echo $DISPLAY
```

**Font rendering issues:**

- Install a Nerd Font (recommended: ZedMono Nerd Font Mono)
- Update font cache: `fc-cache -fv`

### macOS-Specific Issues

**Homebrew PATH issues:**

```bash
# Ensure Homebrew is in PATH
echo $PATH | grep brew

# Reload shell configuration
source ~/.zshenv && exec zsh
```

**Missing developer tools:**

```bash
xcode-select --install
```

## 📚 Additional Resources

- **Detailed Documentation**: See [CLAUDE.md](./CLAUDE.md) for comprehensive configuration guides
- **Neovim Help**: `:help` within Neovim, or check plugin documentation
- **Zsh Manual**: `man zsh` or [Zsh Documentation](https://zsh.sourceforge.io/Doc/)
- **Improvement Tracking**: See [IMPROVEMENT_TICKETS.md](./IMPROVEMENT_TICKETS.md) for planned enhancements

## 🤝 Contributing

This is a personal dotfiles repository, but suggestions and improvements are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request with a clear description

## 📄 License

This repository is provided as-is for personal use. Feel free to fork and adapt for your own needs.

---

**Note**: This configuration is actively maintained and optimized for the author's workflow. Your mileage may vary - adapt configurations to suit your specific needs and preferences.

