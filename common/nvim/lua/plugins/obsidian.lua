return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  cmd = {
    "ObsidianNew",
    "ObsidianOpen",
    "ObsidianSearch",
    "ObsidianQuickSwitch",
    "ObsidianFollowLink",
    "ObsidianBacklinks",
    "ObsidianDailies",
    "ObsidianToday",
    "ObsidianYesterday",
    "ObsidianTomorrow",
    "ObsidianTemplate",
    "ObsidianLinks",
    "ObsidianExtractNote",
    "ObsidianWorkspace",
    "ObsidianPasteImg",
    "ObsidianRename",
    "ObsidianToggleCheckbox",
    "ObsidianLink",
    "ObsidianLinkNew",
  },
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Nextcloud/Multiverse/*.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Nextcloud/Multiverse/*.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Nextcloud/Multiverse",
      },
    },
    -- Daily notes configuration
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = nil
    },
    -- Templates configuration
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {},
    },
    -- Note ID and path configuration
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
    note_path_func = function(spec)
      local path = spec.dir / spec.id
      return path:with_suffix(".md")
    end,
    -- Wiki link configuration
    wiki_link_func = "use_alias_only",
    markdown_link_func = function(opts)
      return require("obsidian.util").markdown_link(opts)
    end,
    -- Frontmatter handling
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
    -- Completion configuration
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    -- Picker configuration (using telescope)
    picker = {
      name = "telescope.nvim",
      note_mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
      tag_mappings = {
        tag_note = "<C-x>",
        insert_tag = "<C-l>",
      },
    },
    -- UI configuration
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
    -- Attachments configuration
    attachments = {
      img_folder = "assets/imgs",
      img_name_func = function()
        return string.format("%s-", os.time())
      end,
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },
    -- App configuration
    open_app_foreground = true,
    obsidian_app_path = vim.fn.has("mac") == 1 and "/Applications/Obsidian.app" or "obsidian",
    -- Custom mappings
    mappings = {
      ["<leader>og"] = {
        action = function()
          vim.fn.system('open -a Obsidian "' .. vim.fn.expand("~/Nextcloud/Multiverse") .. '"')
          vim.cmd("sleep 1000m")
          vim.fn.system(
            'osascript -e \'tell application "Obsidian" to activate\' -e \'tell application "System Events" to keystroke "g" using {command down, shift down}\''
          )
        end,
        desc = "Open Obsidian Graph",
      },
    },
    -- Follow links configuration
    follow_url_func = vim.ui.open or function(url)
      vim.fn.jobstart({ "open", url })
    end,
    -- Use advanced URI plugin
    use_advanced_uri = false,
    -- Open notes in splits
    open_notes_in = "current",
    -- Callback configuration
    callbacks = {
      post_setup = function(client) end,
      enter_note = function(client, note) end,
      leave_note = function(client, note) end,
      pre_write_note = function(client, note) end,
      post_set_workspace = function(client, workspace) end,
    },
    -- Yaml parser configuration
    yaml_parser = "native",
  },
}
