-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "desc:LG Electronics LG HDR 4K 203NTDVF0314",
	mode = "3840x2160@60",
	position = "0x0",
	scale = "1.25", -- native 4K, logical 3072x1728
})

hl.monitor({
	output = "desc:Dell Inc. DELL U2520D BD0P823",
	mode = "2560x1440@59.95",
	position = "-2560x360",
	scale = "1",
})

hl.monitor({
	output = "desc:Hisense Electric Co. Ltd. HISENSE 0x00000001",
	mode = "3840x2160@60",
	position = "-4480x0", -- re-anchored for scale 2 (logical 1920 wide) to stay flush with DP-2
	scale = "2", -- native 4K, logical 1920x1080, integer = pixel-perfect
})

-- Sensible placement for temporary or replacement displays.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "ghostty"
local fileManager = "dolphin"
local menu = "vicinae"
local workspaceStack = "$HOME/.indie-dawg-dots/archlinux/odin/bin/workspace-stack"

-------------------
---- AUTOSTART ----
-------------------

-- This login path does not activate graphical-session.target automatically.
-- Use it as the lifecycle boundary for desktop application user services.
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start graphical-session.target")
	hl.exec_cmd(workspaceStack .. " init")
end)

hl.on("hyprland.shutdown", function()
	hl.exec_cmd("systemctl --user stop graphical-session.target")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 12,
		gaps_out = 24,

		border_size = 2,

		col = {
			active_border = "rgba(b0b0b0cc)",
			inactive_border = "rgba(4a4a4a88)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		-- Global opt-in only: tearing is additionally gated per-window by the
		-- `immediate` rule, which is set solely on the WoW rule below.
		allow_tearing = true,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	misc = {
		-- Disable the inotify config-file watcher. Editors that save atomically
		-- (write temp + rename) swap the file's inode, which makes the watcher
		-- lose its target and report "no such file" even though it's there.
		-- Reload manually with `hyprctl reload` (bound to SUPER+SHIFT+R below).
		disable_autoreload = true,
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
	},

	ecosystem = {
		enforce_permissions = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
-- Pop!_OS-style vertical workspace stack. Workspaces are named
-- <monitor-output>:<position> and normalized by workspace-stack.
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Window movement (dragging and SUPER+SHIFT+h/l cross-monitor moves).
-- Without this, moves inherit `windows` (speed 4.79 on the soft `easy`
-- spring), which settles in ~0.5s -- very draggy across monitors. This
-- spring is critically damped (dampening = 2*sqrt(stiffness*mass)) so it
-- snaps into place in ~0.13s with no bounce.
hl.curve("snappy", { type = "spring", mass = 1, stiffness = 900, dampening = 60 })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.3, spring = "snappy" })

-- For WoW
hl.config({
	render = {
		direct_scanout = 2,
	},
})

-- XWayland apps (Steam, Battle.net, WoW, etc.) don't understand fractional
-- scaling. On the 1.25-scaled DP-1 they would render at the logical resolution
-- and get bitmap-upscaled to native 4K -> blurry/pixelized. force_zero_scaling
-- makes them render at native pixel density instead (crisp). Toolkit UIs may
-- look slightly small on DP-1; set GDK_SCALE/QT_SCALE_FACTOR per-app if needed.
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "ctrl:nocaps",
		kb_rules = "",
		repeat_rate = 50,
		repeat_delay = 150,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(
	mainMod .. "+ SHIFT + Q",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
-- Manual config reload (autoreload is disabled in misc above)
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
-- Panic button: tear down a stuck WoW / Battle.net / Proton session (see ~/.local/bin/wow-kill)
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("wow-kill"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
-- Toggle fullscreen (handy when WoW drops out of fullscreen)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu .. " toggle"))
hl.bind("CTRL + " .. mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Move focus with SUPER+H/J/K/L.
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move/reorder windows within the layout. At a horizontal edge, h/l can hand
-- the window to the next monitor when Hyprland's monitor fallback is enabled.
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Navigate with CTRL+SUPER; adding SHIFT moves the active window through the stack.
hl.bind("CTRL + " .. mainMod .. " + k", hl.dsp.exec_cmd(workspaceStack .. " focus up"))
hl.bind("CTRL + " .. mainMod .. " + j", hl.dsp.exec_cmd(workspaceStack .. " focus down"))
hl.bind("CTRL + " .. mainMod .. " + SHIFT + k", hl.dsp.exec_cmd(workspaceStack .. " move up"))
hl.bind("CTRL + " .. mainMod .. " + SHIFT + j", hl.dsp.exec_cmd(workspaceStack .. " move down"))
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd(workspaceStack .. " focus down"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.exec_cmd(workspaceStack .. " focus up"))

-- Screenshot palette; SUPER+SHIFT+1/2 are intentionally left available.
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.exec_cmd("hyprshot -z -m region --clipboard-only"))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.exec_cmd('hyprshot -z -m region -o "$HOME/Downloads"'))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshots: region to clipboard, full desktop to clipboard, or region to file.
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind(
	"SHIFT + Print",
	hl.dsp.exec_cmd(
		[[sh -c 'mkdir -p "$HOME/Pictures/Screenshots"; geometry=$(slurp -d) || exit; grim -g "$geometry" "$HOME/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"']]
	)
)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
	name = "wow-game",
	match = {
		class = "steam_app_2894584976",
		title = "World of Warcraft",
	},

	-- Do not pin the game to the launcher's workspace; open it on whichever
	-- workspace is active when its window appears.
	workspace = "unset",
	fullscreen = true,
	-- Wine/Proton fake "exclusive fullscreen" and drop it whenever the window
	-- loses focus, which yanked WoW back to windowed. Ignore the client's
	-- fullscreen requests and keep the compositor-side fullscreen from the
	-- rule above (SUPER+F still toggles it manually).
	suppress_event = "fullscreen",
	content = "game",
	idle_inhibit = "fullscreen",
	-- Allow tearing for this window (needs general.allow_tearing above). All
	-- monitors here are 60Hz, so this only helps when WoW pushes past 60fps;
	-- drop it if you ever see tearing artifacts you dislike.
	immediate = true,
	no_anim = true,
	no_blur = true,
	no_shadow = true,
	opaque = true,
	confine_pointer = true,
})

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Frosted glass behind the Quickshell bar. Matches the layer-shell namespace
-- set in ~/.quickshell/shell.qml (WlrLayershell.namespace = "quickshell:bar").
-- ignore_alpha keeps fully-transparent regions clear; the bar's own tint
-- (Theme.barOpacity) controls how much of the blur shows through — lower it via
-- the bar's cog menu for a stronger glass effect.
hl.layer_rule({
	name = "frost-quickshell-bar",
	match = { namespace = "^quickshell:bar$" },
	blur = true,
	ignore_alpha = 0.2,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
