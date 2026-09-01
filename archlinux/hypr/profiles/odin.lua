return {
	name = "odin",
	displays = {
		left = {
			output = "desc:Hisense Electric Co. Ltd. HISENSE 0x00000001",
			w = 3840,
			h = 2160,
			hz = 60,
			scale = 2.0,
			position = "-4480x0",
		},
		center = {
			output = "desc:Dell Inc. DELL U2520D BD0P823",
			w = 2560,
			h = 1440,
			hz = 59.95,
			scale = 1.0,
			position = "-2560x360",
		},
		right = {
			output = "desc:LG Electronics LG HDR 4K 203NTDVF0314",
			w = 3840,
			h = 2160,
			hz = 60,
			scale = 1.25,
			position = "0x0",
		},
	},
	arrangement = { "left", "center", "right" },
	audio = "wpctl",
	appearance = "odin",
	screenshot_dir = "$HOME/Downloads",
	features = {
		laptop = false,
		gaming = true,
		idle = true,
		xembed = true,
	},
}
