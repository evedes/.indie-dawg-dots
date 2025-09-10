return {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  opts = {
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      win_height = 12,
      win_vheight = 12,
      delay_syntax = 50,
      border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
      show_title = true,
      should_preview_cb = function(bufnr, qwinid)
        local ret = true
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(bufname)
        if fsize > 100 * 1024 then
          ret = false
        elseif bufname:match("^fugitive://") then
          ret = false
        end
        return ret
      end,
    },
    func_map = {
      open = "<CR>",
      openc = "o",
      drop = "O",
      split = "<C-s>",
      vsplit = "<C-v>",
      tab = "t",
      tabb = "T",
      tabc = "<C-t>",
      tabdrop = "",
      ptogglemode = "zp",
      ptoggleitem = "p",
      ptoggleauto = "P",
      pscrollup = "<C-u>",
      pscrolldown = "<C-d>",
      pscrollorig = "zo",
      prevfile = "<C-p>",
      nextfile = "<C-n>",
      prevhist = "<",
      nexthist = ">",
      lastleave = "'\"",
      stoggleup = "<S-Tab>",
      stoggledown = "<Tab>",
      stogglevm = "<Tab>",
      stogglebuf = "'<Tab>",
      sclear = "z<Tab>",
      filter = "zf",
      filterr = "zF",
      fzffilter = "zf",
    },
  },
}