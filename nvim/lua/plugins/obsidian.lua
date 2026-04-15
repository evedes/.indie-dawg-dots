vim.pack.add {
	"https://github.com/obsidian-nvim/obsidian.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
}

require("obsidian").setup({
	legacy_commands = false,

	picker = {
		name = "snacks.pick",
	},

	workspaces = {
		{
			name = "Multiverse",
			path = "~/Nextcloud/Multiverse",
		},
	},

	daily_notes = {
		folder = "dailies",
		date_format = "%Y-%m-%d",
		alias_format = "%B %-d, %Y",
		default_tags = { "daily-notes" },
		template = "daily.md",
	},

	new_notes_location = "current_dir",
	note_id_func = function(title)
		local suffix = ""
		if title ~= nil then
			suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
			for _ = 1, 4 do
				suffix = suffix .. string.char(math.random(65, 90))
			end
		end
		return tostring(os.time()) .. "-" .. suffix
	end,

	frontmatter = {
		func = function(note)
			if note.title then
				note:add_alias(note.title)
			end

			local out = { id = note.id, aliases = note.aliases, tags = note.tags }

			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,
	},

	templates = {
		folder = "templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
		substitutions = {},
	},

	attachments = {
		folder = "assets/imgs",
	},
})

-- Keymaps
local function obsidian_map(lhs, cmd, desc)
	vim.keymap.set("n", lhs, "<CMD>Obsidian " .. cmd .. "<CR>", { desc = desc })
end

-- Navigation
obsidian_map("<leader>oo", "open", "Open in Obsidian app")
obsidian_map("<leader>ob", "backlinks", "Show backlinks")
obsidian_map("<leader>ol", "links", "Show links")
obsidian_map("<leader>og", "follow_link", "Follow link under cursor")

-- Search and finding
obsidian_map("<leader>of", "quick_switch", "Quick switch notes")
obsidian_map("<leader>os", "search", "Search notes")
obsidian_map("<leader>oq", "tags", "Search tags")

-- Note creation
obsidian_map("<leader>on", "new", "Create new note")
obsidian_map("<leader>od", "dailies", "Open daily note")
obsidian_map("<leader>oy", "yesterday", "Open yesterday's daily")
obsidian_map("<leader>ot", "today", "Open today's daily")
obsidian_map("<leader>om", "tomorrow", "Open tomorrow's daily")

-- Templates and utilities
obsidian_map("<leader>oT", "template", "Insert template")
obsidian_map("<leader>or", "rename", "Rename note")
obsidian_map("<leader>oi", "paste_img", "Paste image")
obsidian_map("<leader>ow", "workspace", "Switch workspace")
obsidian_map("<leader>oc", "toggle_checkbox", "Toggle checkbox")

-- Visual mode keymaps
vim.keymap.set("v", "<leader>oe", "<CMD>Obsidian extract_note<CR>", { desc = "Extract text to new note" })
vim.keymap.set("v", "<leader>oL", "<CMD>Obsidian link<CR>", { desc = "Link to existing note" })
vim.keymap.set("v", "<leader>oN", "<CMD>Obsidian link_new<CR>", { desc = "Link to new note" })

-- Delete current note
vim.keymap.set("n", "<leader>oD", function()
	local buf_path = vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		vim.notify("No file in current buffer", vim.log.levels.WARN)
		return
	end
	local filename = vim.fn.fnamemodify(buf_path, ":t:r")
	local confirm = vim.fn.input("Delete note '" .. filename .. "'? (y/n): ")
	if confirm:lower() == "y" then
		vim.cmd("bdelete!")
		vim.fn.delete(buf_path)
		vim.notify("Deleted note: " .. filename, vim.log.levels.INFO)
	end
end, { desc = "Delete current note" })

-- Open Obsidian graph view
vim.keymap.set("n", "<leader>oG", function()
	local client = require("obsidian").get_client()
	local vault_name = vim.fn.fnamemodify(tostring(client.dir), ":t")
	local encoded_vault = vim.fn.substitute(vault_name, " ", "%20", "g")
	vim.ui.open("obsidian://graph?vault=" .. encoded_vault)
end, { desc = "Open Obsidian graph view" })
