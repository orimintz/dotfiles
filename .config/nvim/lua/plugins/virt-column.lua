return {
  "lukas-reineke/virt-column.nvim",
  event = "BufReadPre", -- load early but lazily
  opts = {
    virtcolumn = "80", -- column(s) to draw, comma‑separated or "80"
    char = "│", -- character to use (default is also │)
  },
}
