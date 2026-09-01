return {
	name = "darker",
	displays = {
		laptop = { output = "eDP-1", w = 1920, h = 1200, hz = 60, scale = 1.0 },
		left = {
			output = "desc:LG Electronics LG HDR 4K 108NTGYED519",
			w = 3840,
			h = 2160,
			hz = 60,
			scale = 1.0,
			transform = 3,
		},
		center = {
			output = "desc:LG Electronics LG HDR 4K 108NTNHED527",
			w = 3840,
			h = 2160,
			hz = 60,
			scale = 1.0,
		},
	},
	arrangement = { "left", "center", "laptop" },
	laptop = "laptop",
	audio = "pactl",
	appearance = "darker",
	screenshot_dir = "$HOME/Downloads",
	features = {
		laptop = true,
		gaming = false,
		idle = false,
		xembed = false,
	},
}
