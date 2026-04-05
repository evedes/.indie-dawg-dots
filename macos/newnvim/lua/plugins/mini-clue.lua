vim.pack.add {
	"https://github.com/nvim-mini/mini.clue",
}

local miniclue = require("mini.clue")

miniclue.setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "'" },
		{ mode = "x", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
	},
	clues = {
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
		-- Leader groups
		{ mode = "n", keys = "<Leader>b", desc = "+Buffers" },
		{ mode = "n", keys = "<Leader>c", desc = "+Code" },
		{ mode = "n", keys = "<Leader>e", desc = "+Explorer" },
		{ mode = "n", keys = "<Leader>f", desc = "+Find" },
		{ mode = "n", keys = "<Leader>g", desc = "+Git" },
		{ mode = "n", keys = "<Leader>k", desc = "+Close" },
		{ mode = "n", keys = "<Leader>s", desc = "+Splits" },
		{ mode = "n", keys = "<Leader>u", desc = "+Toggle" },

		-- LSP (Neovim 0.12 built-in defaults)
		{ mode = "n", keys = "gd", desc = "Go to definition" },
		{ mode = "n", keys = "gD", desc = "Go to declaration" },
		{ mode = "n", keys = "gl", desc = "Show diagnostic" },
		{ mode = "n", keys = "grn", desc = "Rename" },
		{ mode = "n", keys = "gra", desc = "Code action" },
		{ mode = "n", keys = "grr", desc = "References" },
		{ mode = "n", keys = "gri", desc = "Implementations" },
		{ mode = "n", keys = "grt", desc = "Type definition" },
		{ mode = "n", keys = "grx", desc = "Run codelens" },
		{ mode = "n", keys = "gr", desc = "+LSP" },

		-- Navigation
		{ mode = "n", keys = "[c", desc = "Previous context/diff" },
		{ mode = "n", keys = "[d", desc = "Previous diagnostic" },
		{ mode = "n", keys = "[e", desc = "Previous error" },
		{ mode = "n", keys = "]c", desc = "Next context/diff" },
		{ mode = "n", keys = "]d", desc = "Next diagnostic" },
		{ mode = "n", keys = "]e", desc = "Next error" },
		{ mode = "n", keys = "[q", desc = "Previous quickfix" },
		{ mode = "n", keys = "]q", desc = "Next quickfix" },
	},
	window = {
		delay = 500,
		config = {
			anchor = "SE",
			row = "auto",
			col = "auto",
			width = 55,
		},
	},
})
