return {
  name = "rdb regression",
  builder = function(params)
    return {
      cmd = { vim.fs.root(".", ".git") .. "/regression.sh" },
      args = {},
      cwd = vim.fs.root(".", ".git"),
      components = { { "on_output_quickfix", open = false }, "default" },
    }
  end,
}
