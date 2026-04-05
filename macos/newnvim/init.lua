require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.colorscheme")

for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/plugins") do
	if type == "file" and name:match("%.lua$") then
		require("plugins." .. name:gsub("%.lua$", ""))
	end
end
