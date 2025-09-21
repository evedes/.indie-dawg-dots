# Zellij Configuration Documentation

## Overview
Zellij is a terminal workspace and multiplexer written in Rust, designed as a modern alternative to tmux and screen. This configuration file (`common/zellij/config.kdl`) uses the KDL (cuddly document language) format and provides extensive customization for keybindings, behavior, and appearance.

## Configuration Structure

### File Format
- **Format**: KDL (KDL Document Language)
- **Location**: `common/zellij/config.kdl`
- **Auto-generated**: Yes, with backups created at `~/.config/zellij/config.kdl.bak.*`

## Keybindings System

### Mode-Based Architecture
Zellij operates with different modes, each providing specific functionality:

#### 1. **Locked Mode**
- Minimal key bindings to prevent accidental commands
- **Exit**: `Ctrl-g` → switches to normal mode

#### 2. **Normal Mode**
- Default operational mode
- Access to all mode-switching shortcuts:
  - `Ctrl-p` → Pane mode
  - `Ctrl-t` → Tab mode
  - `Ctrl-n` → Resize mode
  - `Ctrl-h` → Move mode
  - `Ctrl-s` → Scroll mode
  - `Ctrl-o` → Session mode
  - `Ctrl-b` → Tmux mode (for tmux users)
  - `Ctrl-g` → Locked mode
  - `Ctrl-q` → Quit Zellij

#### 3. **Pane Mode** (`Ctrl-p`)
- **Navigation**:
  - `h/j/k/l` or arrow keys → Move focus between panes
  - `p` → Switch focus to previous pane
- **Creation**:
  - `n` → New pane (default split)
  - `r` → New pane to the right
  - `d` → New pane down
  - `s` → New stacked pane
- **Management**:
  - `x` → Close focused pane
  - `f` → Toggle fullscreen for focused pane
  - `w` → Toggle floating panes
  - `e` → Toggle pane embed/floating
  - `z` → Toggle pane frames
  - `i` → Toggle pane pinned status
  - `c` → Rename pane
- **Exit**: `Ctrl-p` or perform action → returns to normal

#### 4. **Tab Mode** (`Ctrl-t`)
- **Navigation**:
  - `h/j/k/l` or arrow keys → Navigate tabs
  - `1-9` → Jump to tab by number
  - `Tab` → Toggle between last two tabs
- **Management**:
  - `n` → New tab
  - `x` → Close tab
  - `r` → Rename tab
  - `s` → Toggle active sync tab
- **Pane Breaking**:
  - `b` → Break pane to new tab
  - `[` → Break pane left
  - `]` → Break pane right
- **Exit**: `Ctrl-t` or numbered selection → returns to normal

#### 5. **Resize Mode** (`Ctrl-n`)
- **Increase Size**:
  - `h/j/k/l` or arrow keys → Increase in direction
  - `+/=` → Increase size generally
- **Decrease Size**:
  - `H/J/K/L` (shift) → Decrease in direction
  - `-` → Decrease size generally
- **Exit**: `Ctrl-n` → returns to normal

#### 6. **Move Mode** (`Ctrl-h`)
- **Pane Movement**:
  - `h/j/k/l` or arrow keys → Move pane in direction
  - `n` or `Tab` → Move pane forward
  - `p` → Move pane backwards
- **Exit**: `Ctrl-h` → returns to normal

#### 7. **Scroll Mode** (`Ctrl-s`)
- **Navigation**:
  - `j/k` or up/down → Scroll line by line
  - `d` → Half page down
  - `u` → Half page up
  - `Ctrl-f` or `PageDown` → Full page down
  - `Ctrl-b` or `PageUp` → Full page up
- **Features**:
  - `e` → Edit scrollback in editor
  - `s` → Enter search mode
  - `Ctrl-c` → Scroll to bottom and exit
- **Exit**: `Ctrl-s` → returns to normal

#### 8. **Search Mode**
- Entered from scroll mode with `s`
- **Options**:
  - `c` → Toggle case sensitivity
  - `w` → Toggle whole word search
  - `o` → Toggle wrap around
- **Navigation**:
  - `n` → Next match
  - `p` → Previous match

#### 9. **Session Mode** (`Ctrl-o`)
- **Plugin Launch**:
  - `w` → Session manager (floating)
  - `p` → Plugin manager (floating)
  - `c` → Configuration editor (floating)
  - `s` → Share session (floating)
  - `a` → About Zellij (floating)
- **Other**:
  - `d` → Detach from session
- **Exit**: `Ctrl-o` → returns to normal

#### 10. **Tmux Mode** (`Ctrl-b`)
- Compatibility mode for tmux users
- **Pane Operations**:
  - `"` → Split pane horizontally (down)
  - `%` → Split pane vertically (right)
  - `h/j/k/l` or arrows → Move focus
  - `o` → Focus next pane
  - `z` → Toggle fullscreen
  - `x` → Close pane
- **Tab Operations**:
  - `c` → New tab
  - `n` → Next tab
  - `p` → Previous tab
  - `,` → Rename tab
- **Other**:
  - `[` → Enter scroll mode
  - `d` → Detach
  - `space` → Next swap layout
  - `Ctrl-b` → Send literal Ctrl-b

### Global Shortcuts (Alt-based)
Available in most modes:
- **Focus Movement**:
  - `Alt-h/j/k/l` → Move focus (including across tabs)
  - `Alt-arrow keys` → Alternative focus movement
- **Pane Management**:
  - `Alt-n` → New pane
  - `Alt-f` → Toggle floating panes
  - `Alt-p` → Toggle pane in group
  - `Alt-Shift-p` → Toggle group marking
- **Tab Management**:
  - `Alt-i` → Move tab left
  - `Alt-o` → Move tab right
- **Layout**:
  - `Alt-[` → Previous swap layout
  - `Alt-]` → Next swap layout
- **Resize**:
  - `Alt-+/=` → Increase size
  - `Alt--` → Decrease size

## Configuration Options

### Appearance & Theme
- **Theme**: `catppuccin_mocha` (currently active)
- **Web Client Font**: `ZedMono Nerd Font Mono`
- **Startup Tips**: Disabled (`show_startup_tips false`)

### Shell & Environment
- **Default Shell**: `zsh`
- **Default Mode**: normal (can be changed to locked)

### Session Management
- **Session Serialization**: Enabled (saves session state)
- **Serialize Pane Viewport**: Enabled (saves pane scroll position)
- **Web Server**: Disabled by default
- **Web Sharing**: Off by default

### Performance & Behavior
- **Mouse Mode**: Enabled by default
- **Pane Frames**: Enabled by default
- **Copy on Select**: Enabled by default
- **Auto Layout**: Enabled (automatic pane arrangement)
- **Stacked Resize**: Enabled (stacks panes when resizing beyond limits)
- **Advanced Mouse Actions**: Enabled (hover effects and pane grouping)

### Plugins System
Built-in plugins configured:
- **about**: Zellij information
- **compact-bar**: Compact status bar
- **configuration**: Configuration editor
- **filepicker**: File browser (Strider)
- **plugin-manager**: Plugin management
- **session-manager**: Session management
- **status-bar**: Status information
- **tab-bar**: Tab display
- **welcome-screen**: Initial screen

## Key Design Principles

### 1. **Modal Interface**
- Clear separation of concerns through different modes
- Each mode has focused functionality
- Quick mode switching with Ctrl-key combinations

### 2. **Vim-Compatible Navigation**
- Consistent use of h/j/k/l for movement
- Modal editing philosophy similar to vim

### 3. **Tmux Compatibility**
- Dedicated tmux mode for familiar keybindings
- Support for common tmux workflows

### 4. **Flexibility**
- Multiple ways to accomplish tasks
- Both keyboard and mouse support
- Customizable through KDL configuration

### 5. **Modern Features**
- Session persistence and serialization
- Plugin architecture
- Web-based access capability
- GPU acceleration support

## Common Workflows

### Basic Navigation
1. Start in normal mode
2. `Ctrl-p` for pane operations
3. Use h/j/k/l to navigate
4. `Ctrl-t` for tab operations

### Window Management
1. Create new pane: `Ctrl-p` then `r` (right) or `d` (down)
2. Navigate panes: `Alt-h/j/k/l` from any mode
3. Close pane: `Ctrl-p` then `x`
4. Fullscreen toggle: `Ctrl-p` then `f`

### Tab Management
1. New tab: `Ctrl-t` then `n`
2. Navigate tabs: `Ctrl-t` then h/l or use numbers 1-9
3. Rename tab: `Ctrl-t` then `r`
4. Close tab: `Ctrl-t` then `x`

### Session Management
1. Detach: `Ctrl-o` then `d`
2. Session manager: `Ctrl-o` then `w`
3. Share session: `Ctrl-o` then `s`

### Text Navigation
1. Enter scroll mode: `Ctrl-s`
2. Scroll with j/k or d/u for half pages
3. Search: `s` from scroll mode
4. Edit scrollback: `e` from scroll mode

## Tips for Effective Use

1. **Learn Core Modes First**: Focus on Normal, Pane, and Tab modes
2. **Use Alt Shortcuts**: Alt-based shortcuts work globally for quick access
3. **Numbered Tabs**: Use number keys in tab mode for quick jumping
4. **Mode Indicators**: Watch the status bar for current mode
5. **Quick Exit**: Most actions auto-return to normal mode
6. **Tmux Transition**: Use tmux mode if coming from tmux
7. **Session Persistence**: Sessions are automatically saved and can be restored

## Customization Points

### Modifying Keybindings
- Edit the `keybinds` section in config.kdl
- Use `clear-defaults=true` to start fresh
- Add bindings for specific modes

### Theme Changes
- Change the `theme` line to any installed theme
- Custom themes can be added to the theme directory

### Plugin Configuration
- Modify plugin aliases in the `plugins` section
- Add custom plugins via `load_plugins`
- Configure plugin-specific settings

### Shell and Environment
- Set `default_shell` to preferred shell
- Configure `default_cwd` for starting directory
- Adjust `scroll_buffer_size` for history

## Platform-Specific Considerations

### Copy/Paste Configuration
- macOS: Uses system clipboard by default
- Linux X11: Can set `copy_command "xclip -selection clipboard"`
- Linux Wayland: Can set `copy_command "wl-copy"`

### Web Server
- Disabled by default for security
- Can be enabled for browser-based access
- Configure IP and port if needed

## Performance Optimization

1. **Serialization Interval**: Adjust if experiencing lag
2. **Scroll Buffer**: Reduce size if memory constrained
3. **Viewport Serialization**: Disable if not needed
4. **Mouse Mode**: Disable if causing issues with text selection
5. **Advanced Mouse Actions**: Disable for simpler behavior

## Comparison with Tmux

### Advantages over Tmux
- Built-in session persistence
- Modern plugin system
- Web-based access capability
- Better default keybindings
- Clearer modal interface
- Native floating panes

### Tmux Compatibility
- Tmux mode provides familiar bindings
- Similar pane/window concepts
- Detach/attach workflow supported

## Troubleshooting

### Common Issues
1. **Keybindings not working**: Check current mode
2. **Can't exit mode**: Use Escape or Enter in most modes
3. **Session not persisting**: Verify serialization is enabled
4. **Performance issues**: Adjust buffer sizes and serialization

### Debug Commands
- Check configuration: `Ctrl-o` then `c`
- Plugin manager: `Ctrl-o` then `p`
- About screen: `Ctrl-o` then `a`

## Summary

This Zellij configuration provides a powerful, modern terminal multiplexer experience with:
- Intuitive modal interface inspired by vim
- Comprehensive keybindings for all operations
- Session persistence and management
- Plugin extensibility
- Cross-platform compatibility
- Optional tmux compatibility mode

The configuration strikes a balance between power and usability, making it suitable for both beginners transitioning from tmux and advanced users seeking modern features.