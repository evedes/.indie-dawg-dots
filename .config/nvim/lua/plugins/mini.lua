return {
  {
    "echasnovski/mini.nvim",
    enabled = true,
    version = false,
    config = function()
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
      require("mini.files").setup()
      require("mini.diff").setup()
      require("mini.pick").setup({
        options = {
          ignorecase = true,
        },
        mappings = {
          move_up = "<C-k>",
          move_down = "<C-j>",
        },
      })
    end,
  },
}
