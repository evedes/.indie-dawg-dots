require("config.options")
require("config.keymaps")

vim.pack.add {
	"https://github.com/rebelot/kanagawa.nvim",
}

vim.cmd.colorscheme('kanagawa')

for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/packages") do
	if type == "file" and name:match("%.lua$") then
		require("packages." .. name:gsub("%.lua$", ""))
	end
end
