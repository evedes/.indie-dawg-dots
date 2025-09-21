return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
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
      nvim_cmp = false,
      min_chars = 2,
    },

    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      }
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

    ui = {
      enable = true,
      update_debounce = 200,
      max_file_length = 5000,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    attachments = {
      img_folder = "assets/imgs",
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },
  },
  keys = {
    -- Navigation
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app", ft = "markdown" },
    { "<leader>oG", function()
        local obsidian = require("obsidian")
        local client = obsidian.get_client()
        if not client then
          vim.notify("Obsidian client not initialized. Make sure you're in a workspace.", vim.log.levels.WARN)
          return
        end
        local vault_name = vim.fn.fnamemodify(tostring(client.dir), ":t")
        local encoded_vault = vim.fn.substitute(vault_name, " ", "%20", "g")
        vim.fn.system("xdg-open 'obsidian://graph?vault=" .. encoded_vault .. "'")
      end, desc = "Open Obsidian graph view" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks", ft = "markdown" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show links", ft = "markdown" },
    { "<leader>og", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link under cursor", ft = "markdown" },

    -- Search and finding
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch notes" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    { "<leader>oq", "<cmd>ObsidianTags<cr>", desc = "Search tags" },

    -- Note creation
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Create new note" },
    { "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Open daily note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Open yesterday's daily" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open today's daily" },
    { "<leader>om", "<cmd>ObsidianTomorrow<cr>", desc = "Open tomorrow's daily" },

    -- Templates and utilities
    { "<leader>oT", "<cmd>ObsidianTemplate<cr>", desc = "Insert template", ft = "markdown" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note", ft = "markdown" },
    { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image", ft = "markdown" },
    { "<leader>oe", "<cmd>ObsidianExtractNote<cr>", desc = "Extract text to new note", ft = "markdown", mode = "v" },
    { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },

    -- Checkbox toggle
    { "<leader>oc", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle checkbox", ft = "markdown" },
  },
}
