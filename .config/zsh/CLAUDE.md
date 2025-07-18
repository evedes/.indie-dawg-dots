# CLAUDE.md - Zsh Configuration

This directory contains the Zsh shell configuration for the indie-dawg-dots setup.

## Overview

A cross-platform Zsh configuration designed to work seamlessly on both macOS and Linux (especially Arch Linux).

## File Structure

```
.config/zsh/
├── .zshrc       # Main interactive shell configuration
├── .alias       # Shell aliases and functions
├── .linuxrc     # Linux-specific configurations
└── .macosrc     # macOS-specific configurations
```

## Key Files

### .zshrc
- **Platform Detection**: Automatically detects macOS vs Linux
- **Zinit Integration**: Plugin manager with multiple fallback paths
- **Plugin Loading**: Essential plugins for autosuggestions, syntax highlighting
- **Environment Setup**: Sources platform-specific configs

### .alias
- Common command shortcuts (e.g., `dots`, `nconf`, `lg`)
- Git aliases
- Docker shortcuts
- Platform-agnostic commands

### Platform-Specific Files
- `.linuxrc`: Linux-specific paths and configurations
- `.macosrc`: macOS-specific paths and Homebrew setup

## Important Features

### Zinit Plugin Manager
The configuration checks multiple paths for Zinit:
- macOS: `/opt/homebrew/opt/zinit/zinit.zsh`
- Linux (in order):
  1. `/usr/share/zinit/zinit.zsh`
  2. `~/.local/share/zinit/zinit.zsh`
  3. `/usr/share/zsh/plugins/zinit/zinit.zsh`

### Cross-Platform Compatibility
- Uses associative arrays for platform-specific paths
- Conditional loading based on platform detection
- Graceful fallbacks when tools aren't installed

## Common Issues & Solutions

### Zinit Not Loading
```bash
# Install Zinit manually on Linux
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit

# On macOS
brew install zinit
```

### Missing Commands
- Check if commands are installed before using them
- The config gracefully handles missing tools
- See main CLAUDE.md for dependency installation

### Performance Issues
- Remove duplicate initializations (e.g., fnm)
- Check for conflicting plugins
- Use `zsh -xv` to debug slow startup

## Customization

### Adding Aliases
1. Edit `.alias` file
2. Follow existing patterns
3. Reload with `source ~/.zshrc` or use the `r` alias

### Adding Platform-Specific Config
1. Edit `.linuxrc` or `.macosrc`
2. Use platform detection for conditional logic
3. Test on both platforms if possible