vim.loader.enable()

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.colorscheme")
require("lsp")

-- Plugins that can be deferred (not needed at first draw)
local deferred = {
  ["obsidian"] = true,
  ["dadbod"] = true,
  ["diffview"] = true,
  ["neogit"] = true,
  ["markview"] = true,
}

for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/plugins") do
  if type == "file" and name:match("%.lua$") then
    local module = name:gsub("%.lua$", "")
    if not deferred[module] then
      local ok, err = pcall(require, "plugins." .. module)
      if not ok then
        vim.notify("Failed to load " .. module .. ": " .. err, vim.log.levels.WARN)
      end
    end
  end
end

-- Load deferred plugins after first render
vim.schedule(function()
  for name in pairs(deferred) do
    local ok, err = pcall(require, "plugins." .. name)
    if not ok then
      vim.notify("Failed to load " .. name .. ": " .. err, vim.log.levels.WARN)
    end
  end
end)
