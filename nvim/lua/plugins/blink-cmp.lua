vim.pack.add {
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
}

require("blink.cmp").setup({
	enabled = function()
		return vim.bo.filetype ~= "snacks_picker_input" and vim.bo.buftype ~= "prompt"
	end,
	keymap = { preset = "default" },
	appearance = { nerd_font_variant = "mono" },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		ghost_text = { enabled = false },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	signature = { enabled = true },
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Extend LSP capabilities for all servers so completion works everywhere.
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Disable blink.cmp inside snacks picker input + any prompt-style buffer.
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local bt = vim.bo[args.buf].buftype
		if ft:match("^snacks_") or bt == "prompt" then
			vim.b[args.buf].completion = false
		end
	end,
})
