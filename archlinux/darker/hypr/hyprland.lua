-- #######################################################################################
-- Hyprland (Lua config) -- "darker"                                          Vedder 2026
-- #######################################################################################
--
-- Lives in ~/.indie-dawg-dots/archlinux/darker/hypr, symlinked to ~/.config/hypr.
-- Hyprland picks this file up as ~/.config/hypr/hyprland.lua. Wiki: https://wiki.hypr.land
--
-- The machine this is written for:
--   * ThinkPad, i5-1135G7 / Intel Iris Xe (i915), 1920x1200 internal panel
--   * 2x LG 31.5" 4K on the dock, matched by serial so DP port numbers can shuffle
--   * SDDM -> uwsm -> Hyprland, so daemons are started through `uwsm app`
--   * ZSA Voyager + ROG Pugio II when docked, Synaptics touchpad + TrackPoint when not
--
-- Two binds below need packages that aren't installed yet -- they no-op until then:
--   sudo pacman -S brightnessctl playerctl     # XF86MonBrightness*, XF86Audio{Next,Prev,Play}
--
-- Autoreload is off (see misc), so after editing: SUPER+SHIFT+R.
-- #######################################################################################

------------------
---- MONITORS ----
------------------

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

local displays = {
	laptop = { output = "eDP-1", w = 1920, h = 1200, hz = 60, scale = 1.0 },
	-- Matched on description+serial rather than DP-3/DP-4: the dock hands out port
	-- numbers in whatever order it feels like. `hyprctl monitors` prints these.
	left = {
		output = "desc:LG Electronics LG HDR 4K 108NTGYED519",
		w = 3840,
		h = 2160,
		hz = 60,
		scale = 1.0,
		transform = 3,
	},
	center = { output = "desc:LG Electronics LG HDR 4K 108NTNHED527", w = 3840, h = 2160, hz = 60, scale = 1.0 },
}

-- Physical left-to-right order. Reorder this list, not the coordinates.
local arrangement = { displays.left, displays.center, displays.laptop }

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
	d.mode = string.format("%dx%d@%d", d.w, d.h, d.hz)
	d.position = string.format("%dx%d", d.x, d.y)
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
local menu = "vicinae toggle"
local screenshotDir = "$HOME/Downloads" -- the only one of the XDG dirs that exists here

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	-- The session is uwsm-managed, so launch daemons as user services in the
	-- background slice: `systemctl --user` can then see and restart them, and they
	-- get torn down properly on logout instead of lingering under the compositor.
	local function daemon(cmd)
		hl.exec_cmd("uwsm app -s b -t service -- " .. cmd)
	end

	daemon("/usr/lib/polkit-kde-authentication-agent-1") -- auth prompts (polkit-kde-agent)
	daemon("mako") -- notifications (dunst is installed too -- only run one)
	daemon("vicinae server") -- launcher backend for SUPER+SPACE
	daemon("nextcloud --background") -- file sync client
	-- Desktop shell / bar. There is no ~/.config/quickshell on darker yet, so this
	-- exits immediately until you add one; `reload-desktop` restarts it with mako.
	daemon("quickshell")

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

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- uwsm already exports XDG_CURRENT_DESKTOP / XDG_SESSION_TYPE / XDG_SESSION_DESKTOP,
-- so they're deliberately not repeated here.

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("GTK_THEME", "Adwaita:dark")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- Deliberately NOT setting GDK_SCALE / QT_SCALE_FACTOR / QT_AUTO_SCREEN_SCALE_FACTOR:
-- pinning them to 1 was right when this machine ran a single 1.0-scaled panel, but with
-- 1.0 (laptop) and 1.25 (4K) in play they'd override per-monitor Wayland scaling and
-- make toolkit apps the wrong size on one screen or the other. Let the toolkits ask.
--
-- QT_QPA_PLATFORMTHEME/qt6ct and QT_STYLE_OVERRIDE/kvantum are gone as well: neither
-- package is installed here, and pointing Qt at a missing platform theme just makes it
-- complain on every launch. Reinstate them if you install qt6ct.

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 9,
		gaps_out = 18,

		border_size = 1,

		col = {
			active_border = "rgba(6A6A6AFF)",
			inactive_border = "rgba(6A6A6A66)",
		},

		resize_on_border = false,
		allow_tearing = false, -- no games on darker; keep the compositor honest

		layout = "dwindle",
	},

	decoration = {
		rounding = 4,
		rounding_power = 2,

		active_opacity = 0.95,
		inactive_opacity = 0.85,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(2b2b2bee)",
		},

		blur = {
			enabled = true,
			size = 8,
			passes = 2,
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
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		background_color = "rgba(2b2b2bff)",

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

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default spring, plus a critically damped one (dampening = 2*sqrt(stiffness*mass)) for
-- window movement: it snaps into place in ~0.13s with no bounce, which matters a lot
-- when a window is being flung across three monitors.
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("snappy", { type = "spring", mass = 1, stiffness = 900, dampening = 60 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.3, spring = "snappy" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

--------------------
---- WORKSPACES ----
--------------------

-- Workspaces are pinned to a monitor, laid out the way the screens are:
--   laptop : 1, 2          (SUPER+1, SUPER+2)
--   centre : 3, 4, 5, 6, 7
--   right  : 8, 9, 10      (SUPER+0 is workspace 10)
-- SUPER+[0-9] switches to a workspace and follows it to its monitor. Undocked, the
-- rules for absent monitors fall back to the panel on their own.
local workspaceGroups = {
	{ monitor = displays.laptop, list = { "1", "2" } },
	{ monitor = displays.left, list = { "3", "4", "5", "6", "7" } },
	{ monitor = displays.center, list = { "8", "9", "10" } },
}

for _, group in ipairs(workspaceGroups) do
	for i, ws in ipairs(group.list) do
		hl.workspace_rule({
			workspace = ws,
			monitor = group.monitor.output,
			default = i == 1, -- first workspace listed is that monitor's default
		})
	end
end

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
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- Clean logout: the session is a uwsm unit, so stop it rather than killing the
-- compositor out from under systemd.
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload")) -- autoreload is off
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + I", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move the window itself. At the edge of a monitor this hands the window to the
-- next screen (binds.window_direction_monitor_fallback, set above).
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with SUPER+[0-9]; SHIFT sends the active window there.
-- Key 0 maps to workspace 10.
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces, and drag/resize with the mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
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

-- Screenshots (hyprshot; -z freezes the screen while you drag a region)
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -z -m region -o " .. screenshotDir))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -z -m window -o " .. screenshotDir))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("hyprshot -m output -o " .. screenshotDir))
-- macOS muscle memory, kept from the old .conf
hl.bind("CTRL + SHIFT + 3", hl.dsp.exec_cmd("hyprshot -z -m region -o " .. screenshotDir))
hl.bind("CTRL + SHIFT + 4", hl.dsp.exec_cmd("hyprshot -z -m window -o " .. screenshotDir))

-- Volume. This box has pipewire-pulse but no wireplumber CLI, so it's pactl rather
-- than the wpctl lines the other machines use.
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

-- Backlight. Needs `brightnessctl` (not installed yet -- these are no-ops until it is).
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media keys. Needs `playerctl` (likewise not installed yet).
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Lid: turn the internal panel off when it closes and put it back exactly where the
-- MONITORS block says it goes. `locked` so it still fires over a lock screen.
local lid = displays.laptop
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

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

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
	-- Small system dialogs are worse tiled than floated.
	name = "float-system-dialogs",
	match = { class = "^(nm-connection-editor|blueman-manager|org.kde.polkit-kde-authentication-agent-1)$" },

	float = true,
})

-- Frosted glass behind the quickshell bar, matched on its layer-shell namespace.
-- ignore_alpha keeps fully transparent regions clear.
hl.layer_rule({
	name = "frost-quickshell-bar",
	match = { namespace = "^quickshell" },
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
	match = { namespace = "^notifications$" },
	blur = true,
	ignore_alpha = 0.3,
})
