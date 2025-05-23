-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<Esc>", "<C-><C-n>", { noremap = true, desc = "Terminal return to normal mode" })
vim.keymap.set(
  "n",
  "<Leader>cx",
  ":lua require('neogen').generate()<CR>",
  { noremap = true, silent = true, desc = "Add doxygen documentation" }
)
vim.keymap.set("v", "<Leader>yp", '"_dp', { noremap = true, desc = "Put without yenking" })

-- Run test
vim.keymap.set(
  "n",
  "<leader>td",
  ':lua require("custom.test_debug").run_cur_test_with_gdb("Debug", "gcc")<CR>',
  { noremap = true, silent = true, desc = "Debug current Gtest in gcc" }
)

-- Last test
vim.keymap.set(
  "n",
  "<leader>tl",
  ':lua require("custom.test_debug").run_last_test_with_gdb()<CR>',
  { noremap = true, silent = true, desc = "Debug last test" }
)

-- Prompt for executable path and test filter
vim.keymap.set(
  "n",
  "<leader>tp",
  ':lua require("custom.test_debug").prompt_and_run()<CR>',
  { noremap = true, silent = true, desc = "Debug Gtest" }
)

require("which-key").add({ "<leader>t", group = "test" })
require("which-key").add({ "<leader>b", group = "buffer/build" })

vim.keymap.set("n", "<leader><delete>", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer" })

vim.keymap.set("n", "<leader>gO", function()
  local sha = vim.fn.expand("<cword>") -- SHA under cursor or whatever you yanked
  vim.cmd("DiffviewOpen " .. sha .. "^!")
end, { desc = "Open commit in Diffview" })

vim.keymap.set("n", "<leader>uB", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle Git Blame" })

local opts = { noremap = true, silent = true, buffer = true }
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("GitMergeTool", {}),
  pattern = "*",
  callback = function()
    if vim.opt.diff:get() then
      vim.keymap.set("n", "<leader>dl", ":diffget LOCAL<CR>", vim.tbl_extend("force", opts, { desc = "diffget LOCAL" }))
      vim.keymap.set("n", "<leader>db", ":diffget BASE<CR>", vim.tbl_extend("force", opts, { desc = "diffget BASE" }))
      vim.keymap.set(
        "n",
        "<leader>dr",
        ":diffget REMOTE<CR>",
        vim.tbl_extend("force", opts, { desc = "diffget REMOTE" })
      )
    end
  end,
})
