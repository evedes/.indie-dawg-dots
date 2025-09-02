return {
  "theme-switcher",
  name = "theme-switcher",
  dir = vim.fn.stdpath("config"),
  lazy = false,
  priority = 1000,
  dependencies = {
    { "rebelot/kanagawa.nvim", lazy = false },
    { "rose-pine/neovim", name = "rose-pine", lazy = false },
    { "catppuccin/nvim", name = "catppuccin", lazy = false },
    { "folke/tokyonight.nvim", lazy = false },
  },
  config = function()
    local themes = {
      kanagawa = {
        colorscheme = "kanagawa",
        variants = { "wave", "dragon", "lotus" },
        setup = function()
          local ok, kanagawa = pcall(require, "kanagawa")
          if ok then
            kanagawa.setup({
              compile = true,
              undercurl = true,
              commentStyle = { italic = true },
              functionStyle = {},
              keywordStyle = { italic = true },
              statementStyle = { bold = true },
              typeStyle = {},
              transparent = true,
              dimInactive = false,
              terminalColors = true,
              colors = {
                palette = {},
                theme = {
                  wave = {},
                  lotus = {},
                  dragon = {},
                  all = {
                    ui = { bg_gutter = "none" },
                  },
                },
              },
              theme = vim.g.kanagawa_variant or "dragon",
              background = {
                dark = vim.g.kanagawa_variant or "dragon",
                light = "lotus",
              },
            })
          end
        end,
      },
      ["rose-pine"] = {
        colorscheme = "rose-pine",
        variants = { "main", "moon", "dawn" },
        setup = function()
          local ok, rose_pine = pcall(require, "rose-pine")
          if ok then
            rose_pine.setup({
              variant = vim.g.rose_pine_variant or "moon",
              dark_variant = vim.g.rose_pine_variant or "moon",
              transparent_background = true,
              disable_background = true,
            })
          end
        end,
      },
      catppuccin = {
        colorscheme = "catppuccin",
        variants = { "latte", "frappe", "macchiato", "mocha" },
        setup = function()
          local ok, catppuccin = pcall(require, "catppuccin")
          if ok then
            catppuccin.setup({
              flavour = vim.g.catppuccin_flavour or "mocha",
              transparent_background = true,
            })
          end
        end,
      },
      tokyonight = {
        colorscheme = "tokyonight",
        variants = { "storm", "moon", "night", "day" },
        setup = function()
          local ok, tokyonight = pcall(require, "tokyonight")
          if ok then
            tokyonight.setup({
              style = vim.g.tokyonight_style or "storm",
              transparent = true,
            })
          end
        end,
      },
    }

    -- Store current theme
    vim.g.current_theme = vim.g.current_theme or "kanagawa"
    vim.g.current_variant = vim.g.current_variant or "dragon"

    -- Function to apply a theme
    local function apply_theme(theme_name, variant)
      local theme = themes[theme_name]
      if not theme then
        vim.notify("Theme not found: " .. theme_name, vim.log.levels.ERROR)
        return
      end

      -- Set variant if provided
      if variant and vim.tbl_contains(theme.variants, variant) then
        if theme_name == "rose-pine" then
          vim.g.rose_pine_variant = variant
        elseif theme_name == "catppuccin" then
          vim.g.catppuccin_flavour = variant
        elseif theme_name == "tokyonight" then
          vim.g.tokyonight_style = variant
        elseif theme_name == "kanagawa" then
          vim.g.kanagawa_variant = variant
        end
      end

      -- Run theme setup
      theme.setup()

      -- Apply colorscheme
      vim.cmd("colorscheme " .. theme.colorscheme)

      -- Apply variant-specific adjustments for Tokyonight
      if theme_name == "tokyonight" and variant then
        vim.cmd("colorscheme tokyonight-" .. variant)
      end

      -- Custom search highlighting (consistent across all themes)
      vim.api.nvim_set_hl(0, "Search", { bg = "#FFFF00", fg = "#000000" })
      vim.api.nvim_set_hl(0, "IncSearch", { bg = "#FFFF00", fg = "#000000" })

      -- Store current theme
      vim.g.current_theme = theme_name
      vim.g.current_variant = variant or theme.variants[1]

      vim.notify("Applied theme: " .. theme_name .. " (" .. (variant or theme.variants[1]) .. ")")
    end

    -- Function to list themes
    local function list_themes()
      local theme_list = {}
      for name, theme in pairs(themes) do
        for _, variant in ipairs(theme.variants) do
          table.insert(theme_list, name .. " " .. variant)
        end
      end
      return theme_list
    end

    -- Theme picker using vim.ui.select
    local function pick_theme()
      local theme_list = list_themes()
      vim.ui.select(theme_list, {
        prompt = "Select theme:",
        format_item = function(item)
          return item
        end,
      }, function(choice)
        if choice then
          local parts = vim.split(choice, " ")
          apply_theme(parts[1], parts[2])
        end
      end)
    end

    -- Quick theme cycle function
    local function cycle_theme()
      local theme_names = vim.tbl_keys(themes)
      table.sort(theme_names)
      
      local current_idx = 1
      for i, name in ipairs(theme_names) do
        if name == vim.g.current_theme then
          current_idx = i
          break
        end
      end
      
      local next_idx = (current_idx % #theme_names) + 1
      local next_theme = theme_names[next_idx]
      apply_theme(next_theme, themes[next_theme].variants[1])
    end

    -- Create commands
    vim.api.nvim_create_user_command("ThemeSelect", pick_theme, {})
    vim.api.nvim_create_user_command("ThemeCycle", cycle_theme, {})
    vim.api.nvim_create_user_command("Theme", function(opts)
      local args = vim.split(opts.args, " ")
      apply_theme(args[1], args[2])
    end, {
      nargs = "+",
      complete = function(ArgLead, CmdLine, CursorPos)
        local parts = vim.split(CmdLine, " ")
        if #parts == 2 then
          -- Complete theme names
          return vim.tbl_filter(function(name)
            return name:find("^" .. ArgLead)
          end, vim.tbl_keys(themes))
        elseif #parts == 3 then
          -- Complete variants for the selected theme
          local theme_name = parts[2]
          if themes[theme_name] then
            return vim.tbl_filter(function(variant)
              return variant:find("^" .. ArgLead)
            end, themes[theme_name].variants)
          end
        end
        return {}
      end,
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>ut", pick_theme, { desc = "Select theme" })
    vim.keymap.set("n", "<leader>uT", cycle_theme, { desc = "Cycle theme" })

    -- Apply default theme on startup
    apply_theme(vim.g.current_theme, vim.g.current_variant)
  end,
}
