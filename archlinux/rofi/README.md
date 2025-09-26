# Rofi Configuration

A clean, modular, and extensible Rofi launcher configuration optimized for Hyprland.

## Directory Structure

```
rofi/
├── config.rasi           # Main Rofi configuration
├── hexarchy-theme.rasi   # Visual theme with glassmorphism effect
├── keybindings.example   # Example keybindings for Hyprland
├── scripts/
│   └── launcher.sh       # Unified launcher script
└── README.md            # This documentation
```

## Features

The launcher provides a **unified search interface** where you can find everything in one place:

### Combined Search (SUPER + SPACE)
With a single keybinding, search across:
- **Applications**: All installed desktop apps
- **Windows**: Currently open windows (switch to any window)
- **🎯 Actions**: Custom actions clearly marked with a target emoji

All actions are prefixed with "🎯 Action:" to distinguish them from regular apps:
- Screenshot tools (region, window, fullscreen, to clipboard)
- Power management (lock, logout, suspend, reboot, shutdown)
- System utilities (WiFi, Bluetooth, System Monitor, Color Picker)
- Quick links to websites (GitHub, YouTube, ChatGPT, Gmail)
- Tools (Clipboard History, File Browser, Window Switcher)

Just start typing and Rofi will search through:
- Application names and descriptions
- Window titles and class names
- Action keywords (e.g., "screenshot", "shutdown", "github")

### Integrated Actions

#### Screenshot Tools
- Region capture (save or clipboard)
- Window capture (save or clipboard)
- Fullscreen capture

#### Power Management
- Lock screen
- Logout (with confirmation)
- Suspend
- Reboot (with confirmation)
- Shutdown (with confirmation)

#### System Tools
- WiFi settings
- Bluetooth management
- System monitor

#### Utilities
- Color picker
- Clipboard history
- File browser
- Window switcher

## Usage

**One keybinding to rule them all**: Press `SUPER + SPACE` and start typing.

Examples:
- Type "firefox" → Launch Firefox or switch to it if already open
- Type "term" → Find terminal apps or switch to terminal windows
- Type "screenshot" → Access all screenshot options
- Type "shutdown" → Find power options
- Type "ls" → Run the ls command directly
- Type part of any window title → Switch to that window

The combined mode intelligently searches everything at once, eliminating the need to remember different keybindings for different modes.

## Installation

1. Install dependencies:
```bash
sudo pacman -S rofi hyprshot cliphist hyprpicker
yay -S hyprlock-git
```

2. The launcher is already configured in Hyprland:
   - `applications.conf` defines: `$menu = ~/.config/rofi/scripts/launcher.sh`
   - `keybindings.conf` binds: `bind = $mainMod, SPACE, exec, $menu`
   - This means `SUPER + SPACE` opens the launcher

3. For additional keybindings (optional):
   - Review `keybindings.example` for useful bindings
   - Add desired bindings to `~/.config/hypr/keybindings.conf`
   - Reload Hyprland config with `SUPER + SHIFT + Q` (or logout/login)

## Configuration

### Theme
Edit `hexarchy-theme.rasi` to customize colors and appearance.

### Actions
The launcher script (`scripts/launcher.sh`) is self-contained and modular. To add new actions:

1. Add a case in the `handle_action()` function
2. Create a desktop entry in `init_desktop_entries()`
3. Actions are automatically merged with the application list

### Dependencies

- `rofi` - The launcher itself
- `hyprshot` - Screenshot utility
- `hyprlock` - Screen locker
- `hyprctl` - Hyprland control
- `cliphist` - Clipboard history manager
- `hyprpicker` - Color picker
- `wl-copy` - Wayland clipboard utility
- `notify-send` - Desktop notifications
- `nm-connection-editor` - WiFi settings
- `blueman-manager` - Bluetooth management
- `gnome-system-monitor` - System monitor

## Architecture

The launcher follows a clean, modular architecture:

### Design Principles

1. **Single Entry Point**: One script (`launcher.sh`) handles all functionality
2. **Desktop Entry Integration**: Custom actions are dynamically generated as .desktop entries
3. **Modular Action System**: Each action is a self-contained case in the handler
4. **Separation of Concerns**: Configuration, theme, and logic are completely separated
5. **Robust Error Handling**: Uses `set -euo pipefail` and proper exit traps
6. **Resource Management**: Automatic cleanup of temporary files on exit

### Code Organization

- **Configuration Section**: All paths and settings at the top
- **Action Handlers**: Central dispatcher with categorized actions
- **Utility Functions**: Reusable helper functions
- **Desktop Entry Generation**: Modular entry creation
- **Main Execution**: Clean entry point with argument handling

### Extension Points

To add new actions:
1. Add a case in `handle_action()` function
2. Create a corresponding desktop entry in `init_desktop_entries()`
3. Optionally add to confirmation list for destructive actions

## Testing & Debugging

### Test the launcher
```bash
~/.config/rofi/scripts/launcher.sh
```

### Test individual Rofi modes
```bash
# Applications
rofi -show drun -theme ~/.config/rofi/hexarchy-theme.rasi

# Window switcher
rofi -show window -theme ~/.config/rofi/hexarchy-theme.rasi

# Command runner
rofi -show run -theme ~/.config/rofi/hexarchy-theme.rasi

# File browser
rofi -show filebrowser -theme ~/.config/rofi/hexarchy-theme.rasi
```

### Debug mode
```bash
# Run with bash debug output
bash -x ~/.config/rofi/scripts/launcher.sh
```

## Customization Guide

### Changing the Theme
Edit `hexarchy-theme.rasi` to modify:
- Colors and transparency
- Font and sizing
- Border and padding
- Animation effects

### Adding Custom Actions
1. Edit `scripts/launcher.sh`
2. Add your action handler in the `handle_action()` function:
   ```bash
   "🎯 Action: My Custom Action")
       # Your command here
       ;;
   ```
3. Create a desktop entry in `init_desktop_entries()`:
   ```bash
   create_desktop_entry \
       "🎯 Action: My Custom Action" \
       "Description" \
       "icon-name" \
       "Category;" \
       "keywords;for;search;" \
       "launcher-my-action"
   ```
4. For dangerous actions, add to `confirm_action()` checks

### Adding Quick Links
To add your own website shortcuts, edit the Quick Links section:
1. Add handler in `handle_action()`:
   ```bash
   "🎯 Action: Open MyWebsite")
       xdg-open "https://mywebsite.com" &
       ;;
   ```
2. Add desktop entry in `init_desktop_entries()`

### Modifying Keybindings
1. Copy `keybindings.example` to your Hyprland config directory
2. Adapt the bindings to your preferences
3. Source or include them in your Hyprland configuration
