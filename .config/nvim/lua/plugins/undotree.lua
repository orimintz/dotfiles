return {
  "jiaoshijie/undotree",
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
  keys = { -- load the plugin only when using it's keybinding:
    { "<C-z>", "<cmd>lua require('undotree').toggle()<cr>", mode = { "n" }, desc = "Open undotree" },
  },
}
