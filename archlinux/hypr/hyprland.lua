-- #######################################################################################
-- Hyprland (Lua config) -- shared host profiles                              Vedder 2026
-- #######################################################################################
--
-- Shared by the "darker" and "odin" hosts. ~/.config/hypr points here on both.
-- Hyprland picks this file up as ~/.config/hypr/hyprland.lua. Wiki: https://wiki.hypr.land
--
-- Host-specific hardware and policy live in profiles/<hostname>.lua. Set
-- HYPRLAND_PROFILE to validate a profile on another host.
--
-- A few binds/services depend on packages that aren't installed yet and no-op
-- until they are:
--   sudo pacman -S hypridle hyprlock brightnessctl   # idle/lock + backlight
--   yay -S xembedsniproxy                           # XEmbed tray icons (AUR)
--
-- Autoreload is off (see misc), so after editing: SUPER+SHIFT+R.
-- #######################################################################################

------------------
---- MONITORS ----
------------------

local function read_hostname()
	local override = os.getenv("HYPRLAND_PROFILE")
	if override and override ~= "" then
		return override
	end

	local file = assert(io.open("/etc/hostname", "r"), "cannot read /etc/hostname")
	local hostname = assert(file:read("*l"), "/etc/hostname is empty")
	file:close()
	return hostname:match("^%s*(.-)%s*$")
end

local hostname = read_hostname()
local supportedHosts = { darker = true, odin = true }
assert(supportedHosts[hostname], "unsupported Hyprland host profile: " .. hostname)
local profile = require("profiles." .. hostname)

-- Desktop design tokens live one directory up, in theme/tokens.lua (the design note is
-- ~/Multiverse/hyprland-desktop-design-system.md). ~/.config/hypr is a symlink into the
-- dotfiles, so "../theme" resolves to archlinux/theme on both hosts.
local configDir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr"
package.path = configDir .. "/../theme/?.lua;" .. package.path
local T = require("tokens")

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
--
-- 4K SCALE REFERENCE
-- ┌───────┬──────────────────────┬─────────────────────────────────────────────────┐
-- │ Scale │ Effective resolution │                      Feel                       │
-- ├───────┼──────────────────────┼─────────────────────────────────────────────────┤
-- │ 1.0   │ 3840x2160            │ Very small                                      │
-- │ 1.25  │ 3072x1728            │ Slightly bigger                                 │
-- │ 1.5   │ 2560x1440            │ Good balance - like a 1440p monitor but sharper │
-- │ 2.75  │ ~2194x1234           │ Larger                                          │
-- │ 2.0   │ 1920x1080            │ Big, like a 1080p monitor but crisp             │
-- └───────┴──────────────────────┴─────────────────────────────────────────────────┘
--
-- Change a `scale` here and everything downstream (positions, the vertical centring,
-- the lid-switch re-enable line) recomputes itself. Keep width/scale and height/scale
-- whole numbers -- Hyprland rejects fractional logical sizes.

local displays = profile.displays

-- Physical left-to-right order. Reorder this list, not the coordinates.
local arrangement = {}
for _, name in ipairs(profile.arrangement) do
	arrangement[#arrangement + 1] = assert(displays[name], "unknown display in profile: " .. name)
end

-- Catch-all first, so a monitor that isn't in the list above (projector, TV, a
-- borrowed screen) still comes up instead of staying black.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Lay them out in one row, vertically centred on the tallest one, so the pointer
-- crosses between screens at the same height instead of falling off a top edge.
local tallest = 0
for _, d in ipairs(arrangement) do
	local rotated = d.transform == 1 or d.transform == 3 or d.transform == 5 or d.transform == 7
	local logicalW, logicalH = rotated and d.h or d.w, rotated and d.w or d.h
	d.lw = math.floor(logicalW / d.scale + 0.5) -- logical width  (pixels / scale)
	d.lh = math.floor(logicalH / d.scale + 0.5) -- logical height
	tallest = math.max(tallest, d.lh)
end

local nextX = 0
for _, d in ipairs(arrangement) do
	d.x, d.y = nextX, math.floor((tallest - d.lh) / 2 + 0.5)
	d.mode = d.mode or string.format("%dx%d@%g", d.w, d.h, d.hz)
	d.position = d.position or string.format("%dx%d", d.x, d.y)
	hl.monitor({
		output = d.output,
		mode = d.mode,
		position = d.position,
		scale = tostring(d.scale),
		transform = d.transform or 0,
	})
	nextX = nextX + d.lw
end

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "ghostty"
local fileManager = "dolphin"
-- Yazi in its own Ghostty window; the custom app-id lets the float rule below
-- match it without catching every other terminal.
local fileManagerTui = "ghostty --class=com.mitchellh.ghostty.yazi -e yazi"
local menu = "vicinae toggle"
local screenshot = "$HOME/.indie-dawg-dots/archlinux/bin/screenshot"
local workspaceStack = "$HOME/.indie-dawg-dots/archlinux/bin/workspace-stack"
-- UWSM marks its session with DESKTOP_SESSION="<wm>-uwsm" (e.g. hyprland-uwsm);
-- there is no UWSM_ID variable, so that check never matched.
local uwsmManaged = (os.getenv("DESKTOP_SESSION") or ""):match("%-uwsm$") ~= nil
local directServices = {
	"plasma-polkit-agent.service",
	"vicinae.service",
	"com.nextcloud.desktopclient.nextcloud.service",
	"quickshell.service",
	"awww-daemon.service",
}
if profile.features.idle then
	directServices[#directServices + 1] = "hypridle.service"
end
if profile.features.xembed then
	directServices[#directServices + 1] = "xembedsniproxy.service"
end
local directServiceList = table.concat(directServices, " ")
local keyboardLayout = "$HOME/.indie-dawg-dots/archlinux/bin/keyboard-layout"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.exec_cmd(workspaceStack .. " init")

	-- Odin currently enters Hyprland directly from SDDM, while Darker uses UWSM.
	-- Start Odin's user services explicitly: graphical-session.target is marked
	-- RefuseManualStart by systemd and `uwsm app` in a non-UWSM session starts nothing.
	if not uwsmManaged then
		-- A directly launched compositor does not automatically update the D-Bus
		-- and systemd user environments. Import Hyprland's environment first so
		-- tray processes and other services receive the shared GTK/Qt dark theme.
		hl.exec_cmd(
			"dbus-update-activation-environment --systemd --all && systemctl --user start " .. directServiceList
		)
		-- Restore the wallpaper independently of the daemon starts above: a
		-- missing unit must not silently cancel it.
		hl.exec_cmd("waypaper --restore")
		return
	end

	-- The session is uwsm-managed, so launch daemons as user services in the
	-- background slice: `systemctl --user` can then see and restart them, and they
	-- get torn down properly on logout instead of lingering under the compositor.
	local function daemon(cmd)
		hl.exec_cmd("uwsm app -s b -t service -- " .. cmd)
	end

	daemon("/usr/lib/polkit-kde-authentication-agent-1") -- auth prompts (polkit-kde-agent)
	daemon("vicinae server") -- launcher backend for SUPER+SPACE
	daemon("nextcloud --background") -- file sync client
	-- Quickshell owns both the desktop bar and org.freedesktop.Notifications.
	daemon("quickshell -p $HOME/.quickshell")
	if profile.features.idle then
		daemon("hypridle")
	end
	if profile.features.xembed then
		daemon("xembedsniproxy")
	end

	-- Wallpaper: waypaper (GUI picker) driving awww as its backend. waypaper is
	-- only a frontend -- it shells out to a backend, so `awww` has to be installed
	-- or the picker comes up with nothing to set. Upstream renamed swww -> awww;
	-- waypaper 2.8 knows both names and Arch ships `awww` (extra, Provides: swww).
	--
	-- The daemon gets its own unit instead of letting waypaper spawn it: it then
	-- shows up as app-Hyprland-awww-daemon@*.service for systemctl, there's no
	-- race between daemon startup and the first image command, and `reload-desktop`
	-- can killall/restart it by name.
	daemon("awww-daemon")
	-- Reapply whatever waypaper set last. Daemon is already up by this point.
	hl.exec_cmd("uwsm app -s b -- waypaper --restore")
end)

hl.on("hyprland.shutdown", function()
	if not uwsmManaged then
		hl.exec_cmd("systemctl --user stop " .. directServiceList)
	end
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- uwsm already exports XDG_CURRENT_DESKTOP / XDG_SESSION_TYPE / XDG_SESSION_DESKTOP,
-- so they're deliberately not repeated here.

-- Cursor: token cursor.theme / cursor.size (theme/tokens.lua). Bibata ships both a
-- hyprcursor and an xcursor build; ~/.icons/default/index.theme covers XWayland.
hl.env("XCURSOR_THEME", T.cursor.theme)
hl.env("HYPRCURSOR_THEME", T.cursor.theme)
hl.env("XCURSOR_SIZE", tostring(T.cursor.size))
hl.env("HYPRCURSOR_SIZE", tostring(T.cursor.size))

hl.env("GDK_BACKEND", "wayland,x11")

-- GTK 4.20+ no longer falls back to its built-in dead-key composer on Wayland
-- when no input-method daemon is installed. Ghostty uses GTK, so request the
-- simple composer explicitly (Kitty does not need this because it is not GTK).
hl.env("GTK_IM_MODULE", "simple")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

if profile.features.gaming then
	-- Permission enforcement and direct scanout are only needed for Odin's game setup.
	hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
	hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
	-- hyprlock's `background { path = screenshot }` needs the same access.
	hl.permission("/usr/(bin|local/bin)/hyprlock", "screencopy", "allow")
end

-- Deliberately NOT setting GDK_SCALE / QT_SCALE_FACTOR / QT_AUTO_SCREEN_SCALE_FACTOR:
-- pinning them to 1 was right when this machine ran a single 1.0-scaled panel, but with
-- 1.0 (laptop) and 1.25 (4K) in play they'd override per-monitor Wayland scaling and
-- make toolkit apps the wrong size on one screen or the other. Let the toolkits ask.
--
-- QT_STYLE_OVERRIDE/kvantum remains unset because Kvantum is not installed.

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
-- One appearance on every host: all values here come from theme/tokens.lua. Per-host
-- differences are limited to monitors, scale and profile.features.*.
hl.config({
	general = {
		gaps_in = T.gap.inner,
		gaps_out = T.gap.outer,

		border_size = T.border.width,

		col = {
			active_border = T.hypr(T.color.border.active),
			inactive_border = T.hypr(T.color.border.subtle),
		},

		resize_on_border = false,
		allow_tearing = profile.features.gaming,

		layout = "dwindle",
	},

	decoration = {
		rounding = T.radius.window,
		rounding_power = 2,

		-- Windows stay opaque; unfocused ones are dimmed a touch instead of made
		-- translucent, which keeps text crisp and stops app windows being blurred.
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		dim_inactive = true,
		dim_strength = T.dim.inactive,

		-- Large and soft, like a real drop shadow rather than an outline.
		shadow = {
			enabled = true,
			range = T.shadow.range,
			render_power = T.shadow.power,
			color = T.hypr(T.shadow.color),
		},

		-- Blur only reaches layer surfaces (bar, launcher, notifications) through the
		-- layer rules at the bottom of this file; opaque windows are never blurred.
		blur = {
			enabled = true,
			size = T.blur.size,
			passes = T.blur.passes,
			new_optimizations = true,
			ignore_opacity = true,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	binds = {
		-- Makes SUPER+SHIFT+hjkl throw a window onto the next monitor once it runs
		-- out of windows to swap with -- which is why there are no explicit
		-- "move to monitor" binds on a three-screen setup.
		window_direction_monitor_fallback = true,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},

	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
		background_color = T.hypr(T.color.bg.base), -- token bg.base

		-- Disable the inotify config-file watcher. Editors that save atomically
		-- (write temp + rename) swap the file's inode, which makes the watcher lose
		-- its target and report "no such file" even though it's there. Reload
		-- manually with SUPER+SHIFT+R.
		disable_autoreload = true,
	},

	xwayland = {
		-- XWayland apps don't understand fractional scaling. Without this they'd
		-- render at the logical size and get bitmap-upscaled on the 1.25/1.5 screens
		-- -> blurry. This makes them render at native density instead.
		force_zero_scaling = true,
	},
})

if profile.features.gaming then
	hl.config({
		ecosystem = { enforce_permissions = true },
		render = { direct_scanout = 2 },
	})
end

-- Curves, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- Motion token: one easing curve (easeOutQuint) plus a critically damped spring
-- (dampening = 2*sqrt(stiffness*mass)) for window movement. It snaps into place in
-- ~0.13s with no bounce, which matters a lot when a window is being flung across three
-- monitors.
hl.curve(
	"easeOutQuint",
	{ type = "bezier", points = { { T.motion.ease[1], T.motion.ease[2] }, { T.motion.ease[3], T.motion.ease[4] } } }
)
hl.curve("snappy", { type = "spring", mass = 1, stiffness = 900, dampening = 60 })

-- Motion tokens: easeOutQuint for almost everything, the "snappy" spring for window
-- movement, popin for windows, fade for layers. Speeds are in 100 ms units, so 2.5 is
-- the ~250 ms ceiling.
hl.animation({ leaf = "global", enabled = true, speed = 2.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "border", enabled = true, speed = 2.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 2.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.5, bezier = "easeOutQuint", style = T.motion.window_style })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "easeOutQuint", style = T.motion.window_style })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.3, spring = "snappy" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier = "easeOutQuint", style = T.motion.layer_style })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "easeOutQuint", style = T.motion.layer_style })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "easeOutQuint", style = T.motion.layer_style })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.5, bezier = "easeOutQuint" })
-- Pop!_OS-style vertical workspace stack. Workspaces are named
-- <monitor-output>:<position> and normalized by workspace-stack.
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.5, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.5, bezier = "easeOutQuint", style = "slidevert" })
if profile.features.gaming then
	hl.animation({ leaf = "zoomFactor", enabled = true, speed = 2.5, bezier = "easeOutQuint" })
end

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		-- keyboard-layout rebuilds this single keymap with the `intl` variant
		-- when requested. A single group works reliably across multi-interface
		-- USB keyboards such as the ZSA Voyager.
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "ctrl:nocaps",
		kb_rules = "",
		repeat_rate = 50,
		repeat_delay = 150,

		follow_mouse = 1,

		-- -1.0 .. 1.0, where 0 means "don't touch libinput's acceleration". The old
		-- .conf had 1.0 here, which is not "normal speed" -- it's maximum extra
		-- acceleration, and it's why the Pugio felt skittish.
		sensitivity = 0,
		accel_profile = "adaptive",

		touchpad = {
			natural_scroll = false,
			scroll_factor = 1.5,
			disable_while_typing = true,
		},
	},
})

-- Three fingers sideways on the touchpad = change workspace.
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- TrackPoint speed/sensitivity is handled outside Hyprland by
-- archlinux/udev/99-trackpoint.rules (sysfs knobs, applied at device add).

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Programs and window management
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(fileManagerTui))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd(keyboardLayout .. " toggle"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(
	mainMod .. " + SHIFT + Q",
	hl.dsp.exec_cmd("qs -p $HOME/.quickshell ipc call powerMenu toggle")
)
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload")) -- autoreload is off
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + I", hl.dsp.layout("togglesplit")) -- dwindle only
if profile.features.idle then
	hl.bind("CTRL + " .. mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
end
if profile.features.gaming then
	hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("wow-kill"))
end

-- Move focus
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move/reorder windows within the layout. At a horizontal edge, h/l can hand
-- the window to the next monitor (window_direction_monitor_fallback above).
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Navigate with CTRL+SUPER; adding SHIFT moves the active window through the stack.
hl.bind("CTRL + " .. mainMod .. " + k", hl.dsp.exec_cmd(workspaceStack .. " focus up"))
hl.bind("CTRL + " .. mainMod .. " + j", hl.dsp.exec_cmd(workspaceStack .. " focus down"))
hl.bind("CTRL + " .. mainMod .. " + SHIFT + k", hl.dsp.exec_cmd(workspaceStack .. " move up"))
hl.bind("CTRL + " .. mainMod .. " + SHIFT + j", hl.dsp.exec_cmd(workspaceStack .. " move down"))
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd(workspaceStack .. " focus down"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.exec_cmd(workspaceStack .. " focus up"))

-- Drag/resize with the mouse.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize mode: SUPER+R, then hjkl to resize, escape/enter to leave.
local resizeStep = 40
hl.define_submap("resize", function()
	hl.bind("h", hl.dsp.window.resize({ x = -resizeStep, y = 0, relative = true }), { repeating = true })
	hl.bind("l", hl.dsp.window.resize({ x = resizeStep, y = 0, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -resizeStep, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = resizeStep, relative = true }), { repeating = true })
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("RETURN", hl.dsp.submap("reset"))
end)
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

-- Screenshots: save to ~/Pictures/Screenshots, copy, and notify.
hl.bind("PRINT", hl.dsp.exec_cmd(screenshot .. " region file"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd(screenshot .. " window file"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd(screenshot .. " full file"))
-- macOS muscle memory, kept from the old .conf
hl.bind("CTRL + SHIFT + 3", hl.dsp.exec_cmd(screenshot .. " region clipboard"))
hl.bind("CTRL + SHIFT + 4", hl.dsp.exec_cmd(screenshot .. " region file"))

-- The machines expose different PipeWire control CLIs.
local volume = profile.audio == "wpctl"
		and {
			up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+",
			down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
			mute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
			mic_mute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
		}
	or {
		up = "pactl set-sink-volume @DEFAULT_SINK@ +5%",
		down = "pactl set-sink-volume @DEFAULT_SINK@ -5%",
		mute = "pactl set-sink-mute @DEFAULT_SINK@ toggle",
		mic_mute = "pactl set-source-mute @DEFAULT_SOURCE@ toggle",
	}
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume.up), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume.down), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(volume.mute), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(volume.mic_mute), { locked = true })

-- Backlight. BrightnessService watches sysfs and shows the OSD for these changes.
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media keys. Needs `playerctl` (likewise not installed yet).
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

if profile.features.laptop then
	-- Turn the internal panel off with the lid and restore its profile position.
	local lid = assert(displays[profile.laptop], "laptop display missing from profile")
	hl.bind(
		"switch:on:Lid Switch",
		hl.dsp.exec_cmd(string.format('hyprctl keyword monitor "%s, disable"', lid.output)),
		{ locked = true }
	)
	hl.bind(
		"switch:off:Lid Switch",
		hl.dsp.exec_cmd(
			string.format('hyprctl keyword monitor "%s, %s, %s, %s"', lid.output, lid.mode, lid.position, lid.scale)
		),
		{ locked = true }
	)
end

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

if profile.features.gaming then
	hl.window_rule({
		name = "wow-game",
		match = { class = "steam_app_2894584976", title = "World of Warcraft" },
		workspace = "unset",
		fullscreen = true,
		suppress_event = "fullscreen",
		content = "game",
		idle_inhibit = "fullscreen",
		immediate = true,
		no_anim = true,
		no_blur = true,
		no_shadow = true,
		opaque = true,
		confine_pointer = true,
	})

	hl.window_rule({
		name = "move-hyprland-run",
		match = { class = "hyprland-run" },
		move = "20 monitor_h-120",
		float = true,
	})
end

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

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

hl.window_rule({
	-- Yazi (SUPER+SHIFT+E) is a transient "peek at the filesystem" window, not
	-- something to give a tile to.
	name = "float-yazi",
	match = { class = "^com\\.mitchellh\\.ghostty\\.yazi$" },

	float = true,
	size = "60% 70%",
	center = true,
})

hl.window_rule({
	-- Small system dialogs are worse tiled than floated.
	name = "float-system-dialogs",
	match = { class = "^(nm-connection-editor|blueman-manager|org.kde.polkit-kde-authentication-agent-1)$" },

	float = true,
})

-- Frosted glass behind the quickshell bar, matched on its layer-shell namespace.
-- ignore_alpha keeps fully transparent regions clear.
hl.layer_rule({
	name = "frost-quickshell-bar",
	match = { namespace = "^quickshell:bar$" },
	blur = true,
	ignore_alpha = 0.3,
})

hl.layer_rule({
	name = "frost-quickshell-osd",
	match = { namespace = "^quickshell:osd$" },
	blur = true,
	ignore_alpha = 0.3,
})

hl.layer_rule({
	name = "frost-quickshell-power-menu",
	match = { namespace = "^quickshell:power-menu$" },
	blur = true,
	ignore_alpha = 0.3,
})

-- Same treatment for the launcher and notifications.
hl.layer_rule({
	name = "frost-vicinae",
	match = { namespace = "^vicinae" },
	blur = true,
	ignore_alpha = 0.3,
})

hl.layer_rule({
	name = "frost-notifications",
	match = { namespace = "^quickshell:notifications$" },
	blur = true,
	ignore_alpha = 0.3,
})
