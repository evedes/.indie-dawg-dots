-- Requires Node.js on PATH for the `app/` install step.

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if
			ev.data.spec.name == "markdown-preview.nvim"
			and (ev.data.kind == "install" or ev.data.kind == "update")
		then
			vim.notify("Building markdown-preview.nvim...", vim.log.levels.INFO)
			local result = vim
				.system({ "npx", "--yes", "yarn", "install" }, { cwd = ev.data.path .. "/app" })
				:wait()
			if result.code ~= 0 then
				vim.notify("markdown-preview.nvim build failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
			end
		end
	end,
})

vim.pack.add {
	"https://github.com/iamcco/markdown-preview.nvim",
}

vim.g.mkdp_filetypes = { "markdown" }
vim.g.mkdp_auto_close = 1
vim.g.mkdp_theme = "dark"

vim.keymap.set("n", "<leader>mp", "<CMD>MarkdownPreviewToggle<CR>", { desc = "Markdown preview (browser)" })
