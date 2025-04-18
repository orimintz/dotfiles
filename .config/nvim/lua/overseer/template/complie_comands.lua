return {
  name = "generate compile commands",
  params = {
    build_type = {
      type = "string",
      name = "Build type",
      optional = false,
      order = 1,
      validate = function(value)
        local str = string.lower(value)
        return str == "debug" or str == "release"
      end,
      default = "debug",
    },
    asan = {
      name = "Sanitizer",
      type = "boolean",
      optional = false,
      order = 2,
      default = false,
    },
  },
  builder = function(params)
    local function bool_to_num(value)
      return value == true and 1 or value == false and 0
    end
    local build_type = string.lower(params.build_type):gsub("^%l", string.upper)
    return {
      cmd = { vim.fs.root(".", ".git") .. "/src/scripts/gen_compile_commands.sh" },
      args = { build_type },
      cwd = vim.fs.root(".", ".git"),
      components = { { "on_output_quickfix", open = false }, "default" },
      env = {
        USE_ASAN = bool_to_num(params.asan),
      },
    }
  end,
}
