local M = {}

local function close_view()
  if vim.fn.tabpagenr("$") > 1 then
    vim.cmd("tabclose")
  else
    vim.api.nvim_buf_delete(0, { force = true })
  end
end

---@param bufnr integer
---@param result vim.SystemCompleted
local function render_result(bufnr, result)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local output = result.stdout or ""
  if result.stderr and result.stderr ~= "" then
    output = output .. (output == "" and "" or "\n") .. result.stderr
  end
  if output == "" then
    output = result.code == 0 and "No definition found." or "Dictionary lookup failed."
  end

  output = output:gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n$", "")
  local lines = vim.split(output, "\n", { plain = true })

  vim.bo[bufnr].readonly = false
  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modifiable = false
  vim.bo[bufnr].readonly = true

  local winid = vim.fn.bufwinid(bufnr)
  if winid ~= -1 then
    vim.api.nvim_win_set_cursor(winid, { 1, 0 })
  end
end

---@param word string
function M.lookup(word)
  word = vim.trim(word)
  if word == "" then
    vim.notify("No word to look up", vim.log.levels.WARN)
    return
  end

  vim.cmd("tabnew")
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(bufnr, string.format("dictionary://%s/%d", word, bufnr))
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Looking up “" .. word .. "”…" })

  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "text"
  vim.bo[bufnr].modifiable = false
  vim.bo[bufnr].readonly = true
  vim.wo.wrap = true
  vim.wo.linebreak = true

  vim.keymap.set("n", "q", close_view, { buffer = bufnr, desc = "Close dictionary" })

  vim.system({ "dict", word }, { text = true }, function(result)
    vim.schedule(function()
      render_result(bufnr, result)
    end)
  end)
end

return M
