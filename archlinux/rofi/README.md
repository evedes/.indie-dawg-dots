# Rofi Configuration & Scripts

## Features

### Theme
- Transparent blueish theme with glassmorphism effect
- Support for icons and modern UI elements
- Responsive design with percentage-based sizing

### Scripts

1. **Screenshot Menu** (`screenshot.sh`)
   - Region, window, or fullscreen capture
   - Save to file or clipboard
   - Uses hyprshot for Wayland

2. **Power Menu** (`powermenu.sh`)
   - Lock, logout, suspend, reboot, shutdown
   - Confirmation for destructive actions

3. **Quick Launch** (`quicklaunch.sh`)
   - Fast access to favorite applications
   - Customizable app list

4. **Clipboard Manager** (`clipboard.sh`)
   - History of copied items
   - Quick paste functionality

5. **Web Search** (`web-search.sh`)
   - Multiple search engines
   - Direct search from rofi

6. **WiFi Manager** (`wifi.sh`)
   - Connect/disconnect networks
   - Password entry for secured networks
   - Signal strength indicators

7. **Master Menu** (`master-menu.sh`)
   - Access all rofi functions from one menu

## Installation

1. Install dependencies:
```bash
sudo pacman -S rofi
yay -S hyprshot cliphist
```

2. Add keybindings to your Hyprland config:
```bash
# Add this line to your hyprland.conf
source = ~/.config/rofi/hyprland-keybinds.conf
```

## Keybindings

- `Super + Space` - Application launcher
- `Super + M` - Master menu
- `Super + S` - Screenshot menu
- `Super + X` - Power menu
- `Super + Q` - Quick launch
- `Super + V` - Clipboard
- `Super + F` - Web search
- `Super + W` - WiFi manager
- `Alt + Tab` - Window switcher
- `Super + R` - Run command
- `Super + E` - File browser

## Customization

Edit scripts in `~/.config/rofi/scripts/` to add your own functionality.
Modify `arch-theme.rasi` to change colors and styling.

## Testing

Test any script directly:
```bash
~/.config/rofi/scripts/screenshot.sh
```

Or test the theme:
```bash
rofi -show drun -theme ~/.config/rofi/arch-theme.rasi
```