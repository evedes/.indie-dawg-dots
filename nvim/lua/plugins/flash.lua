vim.pack.add {
  "https://github.com/folke/flash.nvim",
}

require("flash").setup({
  modes = {
    search = {
      enabled = true,
    },
  },
})

-- Keymaps (no s/S — using / with flash search instead)
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<C-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

-- Neovim 0.13 compat: flash's lua/flash/hacks.lua reads the incsearch C globals
-- `search_match_lines` / `search_match_endcol` over ffi. neovim/neovim#39485
-- moved them into a `Search` struct, so `/` dies with
-- "undefined symbol: search_match_endcol". Upstream fix is still open
-- (folke/flash.nvim#493), so rebind the two accessors to the struct here.
local function patch_incsearch_ffi()
  local hacks = require("flash.hacks")

  -- Old globals still resolve (Neovim <= 0.12, or upstream fixed it): leave as is.
  if pcall(hacks.save_incsearch_state) then
    return
  end

  local ffi = require("ffi")
  local ok = pcall(
    ffi.cdef,
    [[
      typedef struct {
        bool hl_match;
        int match_lines;
        int match_endcol;
        int first_line;
        int last_line;
        bool no_smartcase;
        int cmdlen;
        bool no_hlsearch;
      } flash_SearchState;
      flash_SearchState Search;
    ]]
  )
  -- Bail out rather than read a struct whose layout drifted out from under us.
  if not ok or ffi.sizeof("flash_SearchState") ~= 32 then
    return
  end
  if not pcall(function()
    return ffi.C.Search.match_endcol
  end) then
    return
  end

  local Pos = require("flash.search.pos")
  local saved = nil

  function hacks.get_end_pos(from)
    local ret = Pos({
      from[1] + ffi.C.Search.match_lines,
      math.max(0, ffi.C.Search.match_endcol - 1),
    })
    local line = vim.api.nvim_buf_get_lines(0, ret[1] - 1, ret[1], false)[1]
    if line then
      ret[2] = vim.fn.byteidx(line, vim.fn.charidx(line, ret[2]))
    end
    return ret
  end

  function hacks.save_incsearch_state()
    saved = {
      match_endcol = ffi.C.Search.match_endcol,
      match_lines = ffi.C.Search.match_lines,
    }
  end

  function hacks.restore_incsearch_state()
    if saved then
      ffi.C.Search.match_endcol = saved.match_endcol
      ffi.C.Search.match_lines = saved.match_lines
    end
  end
end

pcall(patch_incsearch_ffi)
