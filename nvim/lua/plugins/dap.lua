vim.pack.add({
  "https://codeberg.org/mfussenegger/nvim-dap",
})

local dap = require("dap")

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue / start debug" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open debug REPL" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate debug session" })
vim.keymap.set("n", "<leader>du", dap.run_last, { desc = "Run last debug session" })
