vim.pack.add {
	"https://github.com/nvim-mini/mini.indentscope",
}

require("mini.indentscope").setup({
	draw = {
		animation = require("mini.indentscope").gen_animation.none(),
	},
})
