return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    legacy_commands = false,

    picker = {
      name = "mini.pick",
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
      template = nil,
    },

    completion = {
      blink = true,
      min_chars = 2,
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

    note_frontmatter_func = function(note)
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

    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {},
    },

    attachments = {
      img_folder = "assets/imgs",
    },
  },
  keys = {
    -- Navigation
    { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app", ft = "markdown" },
    { "<leader>oG", function()
        local client = require("obsidian").get_client()
        local vault_name = vim.fn.fnamemodify(tostring(client.dir), ":t")
        local encoded_vault = vim.fn.substitute(vault_name, " ", "%20", "g")
        vim.fn.system("xdg-open 'obsidian://graph?vault=" .. encoded_vault .. "'")
      end, desc = "Open Obsidian graph view" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show backlinks", ft = "markdown" },
    { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Show links", ft = "markdown" },
    { "<leader>og", "<cmd>Obsidian follow_link<cr>", desc = "Follow link under cursor", ft = "markdown" },

    -- Search and finding
    { "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch notes" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
    { "<leader>oq", "<cmd>Obsidian tags<cr>", desc = "Search tags" },

    -- Note creation
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Create new note" },
    { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Open daily note" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Open yesterday's daily" },
    { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Open today's daily" },
    { "<leader>om", "<cmd>Obsidian tomorrow<cr>", desc = "Open tomorrow's daily" },

    -- Templates and utilities
    { "<leader>oT", "<cmd>Obsidian template<cr>", desc = "Insert template", ft = "markdown" },
    { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Rename note", ft = "markdown" },
    { "<leader>oD", function()
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
      end, desc = "Delete current note", ft = "markdown" },
    { "<leader>oi", "<cmd>Obsidian paste_img<cr>", desc = "Paste image", ft = "markdown" },
    { "<leader>oe", "<cmd>Obsidian extract_note<cr>", desc = "Extract text to new note", ft = "markdown", mode = "v" },
    { "<leader>oL", "<cmd>Obsidian link<cr>", desc = "Link to existing note", ft = "markdown", mode = "v" },
    { "<leader>oN", "<cmd>Obsidian link_new<cr>", desc = "Link to new note", ft = "markdown", mode = "v" },
    { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Switch workspace" },

    -- Checkbox toggle
    { "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox", ft = "markdown" },
  },
}
