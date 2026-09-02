-- #######################################################################################
-- Desktop design tokens -- the one place appearance decisions live           Vedder 2026
-- #######################################################################################
--
-- Source of truth for everything outside the terminal: compositor, bar, launcher,
-- notifications, lock/login, GTK, Qt, fonts, icons, cursor. The design note with the
-- reasoning and the audit is ~/Multiverse/hyprland-desktop-design-system.md.
--
-- Consumers (maintained by hand; copy values verbatim and name the token in a comment):
--   hypr/hyprland.lua              require()s this file: radius, border, shadow, blur,
--                                  dim, gaps, bg.base, motion, cursor
--   hypr/hyprlock.conf             bg.base, fg.*, border.active, accent, font.ui
--   ~/.quickshell/Theme.qml        font.ui, font.icons, bg.surface, fg.*, accent,
--                                  radius.popup, space.unit
--   vicinae/                       bg.surface, fg.*, accent, radius.popup, font.ui
--   gtk-3.0/, gtk-4.0/             font.ui, icon.theme, cursor.theme, accent, bg.elevated
--   kdeglobals                     font.ui, icon.theme, bg.elevated, fg.*, accent
--   fontconfig/conf.d/             font.ui alias + rendering
--   icons/default/index.theme      cursor.theme (XWayland fallback)
--
-- The terminal palette (Kanagawa, see Ghostty/Zellij/Neovim) is a separate concern.
-- The desktop palette is deliberately plainer; only `accent` is borrowed from it.
-- #######################################################################################

local T = {}

---------------------
---- TYPOGRAPHY -----
---------------------

T.font = {
	ui = "Adwaita Sans", -- every piece of UI chrome; never a Nerd Font
	mono = "Berkeley Mono", -- terminal and editor only
	icons = "Symbols Nerd Font", -- glyphs come from a dedicated symbol font
	size = { sm = 10, md = 11, lg = 13 }, -- pt; bar and notifications use md
	-- fontconfig rendering, shared by GTK, Qt and Quickshell
	hinting = "hintslight",
	subpixel = "rgba",
	lcdfilter = "lcddefault",
}

-----------------
---- COLOUR -----
-----------------

-- Hex + alpha (0-1). Use T.hypr()/T.rgba() below to format for a given consumer.
T.color = {
	bg = {
		base = { hex = "#1a1a1a", a = 1 }, -- Hyprland background_color, hyprlock backdrop
		surface = { hex = "#141414", a = 0.85 }, -- bar, launcher, notifications, OSD (with blur)
		elevated = { hex = "#242424", a = 1 }, -- popups, menus, GTK/Qt window background
	},
	fg = {
		primary = { hex = "#e6e6e6", a = 1 }, -- body text
		secondary = { hex = "#a5a5a5", a = 1 }, -- labels, timestamps, inactive text
	},
	border = {
		subtle = { hex = "#ffffff", a = 0.08 }, -- inactive window border, panel edges
		active = { hex = "#ffffff", a = 0.28 }, -- active window border
	},
	accent = { hex = "#7e9cd8", a = 1 }, -- Kanagawa crystalBlue; focus, progress, links, selection
	danger = { hex = "#e46876", a = 1 }, -- critical notifications only
}

------------------------------
---- SHAPE, DEPTH, SPACING ---
------------------------------

T.radius = {
	window = 10, -- Hyprland rounding
	popup = 12, -- bar popups, launcher, notifications, OSD
	control = 6, -- buttons and inputs inside popups
}

T.border = { width = 1 }

T.shadow = { range = 24, power = 2, color = { hex = "#000000", a = 0.45 } }

-- Layers only (bar, launcher, notifications). App windows are never blurred.
T.blur = { size = 6, passes = 2 }

T.dim = { inactive = 0.05 } -- replaces inactive_opacity

T.gap = { inner = 8, outer = 16 }

T.space = { unit = 8 } -- px; bar/popup padding and margins are multiples of this

-----------------
---- MOTION -----
-----------------

T.motion = {
	-- one curve for almost everything; the compositor also has a critically damped
	-- spring ("snappy") for window movement
	ease = { 0.23, 1, 0.32, 1 }, -- easeOutQuint
	window_style = "popin 92%",
	layer_style = "fade",
	max_ms = 250,
}

------------------------
---- ICONS & CURSOR ----
------------------------

T.icon = { theme = "breeze-dark" }
T.cursor = { theme = "Bibata-Modern-Classic", size = 24 }

-----------------
---- HELPERS ----
-----------------

local function channels(c)
	local r, g, b = c.hex:match("^#(%x%x)(%x%x)(%x%x)$")
	assert(r, "bad hex colour: " .. tostring(c.hex))
	return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end

--- Hyprland colour string: rgba(rrggbbaa)
function T.hypr(c)
	local a = math.floor(c.a * 255 + 0.5)
	return string.format("rgba(%s%02x)", c.hex:sub(2), a)
end

--- CSS colour string: rgba(r, g, b, a)
function T.rgba(c)
	local r, g, b = channels(c)
	return string.format("rgba(%d, %d, %d, %s)", r, g, b, c.a)
end

--- kdeglobals colour string: r,g,b
function T.kde(c)
	local r, g, b = channels(c)
	return string.format("%d,%d,%d", r, g, b)
end

return T
