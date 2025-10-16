return {
  "echasnovski/mini.nvim",
  enabled = true,
  version = false,
  config = function()
    require("mini.ai").setup()
    require("mini.icons").setup()
    require("mini.pairs").setup()
    require("mini.jump").setup()
    require("mini.jump2d").setup()

    -- Configure mini.files
    require("mini.files").setup({
      content = {
        filter = function(fs_entry)
          return true
        end,
        sort = nil,
      },
      mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "L",
        go_out = "h",
        go_out_plus = "H",
        reset = "=",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
      options = {
        permanent_delete = true,
        use_as_default_explorer = false,
      },
      windows = {
        max_number = math.huge,
        width_focus = 30,
        width_nofocus = 30,
        width_preview = 70,
        preview = false,
      },
    })

    local MiniPick = require("mini.pick")
    MiniPick.setup({
      delay = { async = 10, busy = 50 },
      mappings = {
        caret_left = "<Left>",
        caret_right = "<Right>",
        choose = "<CR>",
        choose_in_vsplit = "<C-v>",
        choose_in_split = "<C-s>",
        choose_marked = "<M-CR>",
        delete_char = "<BS>",
        delete_left = "<C-u>",
        delete_word = "<C-w>",
        mark = "<C-Space>",
        mark_all = "<C-a>",
        move_down = "<C-j>",
        move_start = "<Home>",
        move_up = "<C-k>",
        paste = "<C-r>",
        refine = "#",
        refine_marked = "",
        scroll_down = "<PageDown>",
        scroll_left = "<Left>",
        scroll_right = "<Right>",
        scroll_up = "<PageUp>",
        toggle_info = "<S-Left>",
        toggle_preview = "<S-Right>",
      },
      options = {
        content_from_bottom = false,
        use_cache = false,
      },
      source = {
        show = MiniPick.default_show,
      },
      window = {
        config = function()
          local height = math.floor(0.618 * vim.o.lines)
          return {
            anchor = "NW",
            height = height,
            width = vim.o.columns,
            row = vim.o.lines - height,
            col = 0,
          }
        end,
        prompt_prefix = "> ",
      },
    })

    require("mini.statusline").setup({
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 120 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location = MiniStatusline.section_location({ trunc_width = 75 })

          local recording = vim.fn.reg_recording() ~= "" and "Recording @" .. vim.fn.reg_recording() or ""

          if recording ~= "" then
            recording = "%#StatusLineRecording#" .. recording .. "%*"
          end

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
            "%<", -- Mark general truncate point
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineRecording", strings = { recording } },
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = mode_hl, strings = { location } },
          })
        end,
      },
    })
    vim.api.nvim_command("highlight StatusLineRecording guifg=#ff0000 guibg=NONE gui=bold")
    require("mini.diff").setup()
    require("mini.comment").setup()
    require("mini.surround").setup()
    require("mini.bufremove").setup()

    -- Configure mini.clue for which-key functionality
    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- g key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- z key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },

        -- Brackets
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
      },

      clues = {
        -- Enhance this list with your custom keybindings
        { mode = "n", keys = "<Leader>f", desc = "+find" },
        { mode = "n", keys = "<Leader>b", desc = "+buffer" },
        { mode = "n", keys = "<Leader>g", desc = "+git" },
        { mode = "n", keys = "<Leader>x", desc = "+quickfix" },
        { mode = "n", keys = "<Leader>e", desc = "+explorer" },

        -- Individual leader mappings
        { mode = "n", keys = "<Leader>w", desc = "Write" },
        { mode = "n", keys = "<Leader>q", desc = "Quit window" },
        { mode = "n", keys = "<Leader>Q", desc = "Quit vim" },
        { mode = "n", keys = "<Leader>kk", desc = "Close buffer" },
        { mode = "n", keys = "<Leader>D", desc = "Open Dadbod" },
        { mode = "n", keys = "<Leader>/", desc = "Live grep" },
        { mode = "n", keys = "<Leader>cc", desc = "Resume picker" },

        -- File/Find mappings
        { mode = "n", keys = "<Leader>ff", desc = "Find files" },
        { mode = "n", keys = "<Leader>fe", desc = "File explorer" },
        { mode = "n", keys = "<Leader>fh", desc = "Find help" },
        { mode = "n", keys = "<Leader>ee", desc = "Explorer at current file" },

        -- Buffer mappings
        { mode = "n", keys = "<Leader>bb", desc = "Buffer list" },

        -- Git mappings
        { mode = "n", keys = "<Leader>gg", desc = "Neogit" },
        { mode = "n", keys = "<Leader>go", desc = "Toggle diff overlay" },

        -- Quickfix mappings
        { mode = "n", keys = "<Leader>xq", desc = "Open quickfix" },
        { mode = "n", keys = "<Leader>xc", desc = "Close quickfix" },

        -- Bracket mappings
        { mode = "n", keys = "[d", desc = "Previous diagnostic" },
        { mode = "n", keys = "]d", desc = "Next diagnostic" },
        { mode = "n", keys = "[e", desc = "Previous error" },
        { mode = "n", keys = "]e", desc = "Next error" },
        { mode = "n", keys = "[q", desc = "Previous quickfix" },
        { mode = "n", keys = "]q", desc = "Next quickfix" },
        { mode = "n", keys = "[Q", desc = "First quickfix" },
        { mode = "n", keys = "]Q", desc = "Last quickfix" },

        -- g mappings
        { mode = "n", keys = "gd", desc = "Go to definition" },
        { mode = "n", keys = "gD", desc = "Go to definition (picker)" },
        { mode = "n", keys = "grr", desc = "Find references" },
        { mode = "n", keys = "gra", desc = "Code action" },
        { mode = "n", keys = "gy", desc = "Go to type definition" },

        -- Include mini.clue default clues
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },

      window = {
        -- Show window after 500ms delay
        delay = 500,

        -- Configure window position (bottom right)
        config = {
          width = "auto",
          anchor = "SE", -- Southeast (bottom-right)
          row = "auto",
          col = "auto",
        },
      },
    })
  end,
}
