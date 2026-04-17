vim.pack.add {
	"https://github.com/stevearc/conform.nvim",
}

require("conform").setup({
	notify_on_error = false,
	formatters = {
		prettier = {
			prepend_args = function(self, ctx)
				if not vim.g.prettier_fallback then
					return {}
				end

				local has_config = vim.fs.find({
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yml",
					".prettierrc.yaml",
					".prettierrc.json5",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.mjs",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
				}, { upward = true, path = ctx.dirname })[1]

				if not has_config then
					return {
						"--print-width=100",
						"--tab-width=2",
						"--use-tabs=false",
						"--semi=true",
						"--single-quote=false",
						"--trailing-comma=es5",
						"--bracket-spacing=true",
						"--arrow-parens=always",
					}
				end
				return {}
			end,
		},
	},
	formatters_by_ft = {
		javascript = { "prettier", "dprint", lsp_format = "fallback" },
		javascriptreact = { "prettier", "dprint", lsp_format = "fallback" },
		json = { "prettier", "dprint" },
		jsonc = { "prettier", "dprint" },
		less = { "prettier" },
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		scss = { "prettier" },
		sh = { "shfmt" },
		typescript = { "prettier", "dprint", lsp_format = "fallback" },
		typescriptreact = { "prettier", "dprint", lsp_format = "fallback" },
		elixir = { "mix" },
		heex = { "mix" },
		rust = { "rustfmt", lsp_format = "fallback" },
		vue = { "prettier" },
		["_"] = { "trim_whitespace", "trim_newlines" },
	},
	format_on_save = function(bufnr)
		if vim.g.minifiles_active then
			return nil
		end

		local autoformat = vim.b[bufnr].autoformat
		if autoformat == nil then
			autoformat = vim.g.autoformat
		end

		if not autoformat then
			return nil
		end

		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

-- Use conform for gq
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Start auto-formatting by default
vim.g.autoformat = true
vim.g.prettier_fallback = true

-- Keymaps
vim.keymap.set("n", "<leader>up", function()
	vim.g.prettier_fallback = not vim.g.prettier_fallback
	local status = vim.g.prettier_fallback and "enabled" or "disabled"
	vim.notify("Prettier fallback defaults " .. status, vim.log.levels.INFO)
end, { desc = "Toggle Prettier Fallback" })
