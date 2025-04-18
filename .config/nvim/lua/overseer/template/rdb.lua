return {
  name = "rdb build",
  params = {
    tool_chain = {
      type = "string",
      name = "Tool chain",
      optional = false,
      order = 1,
      validate = function(value)
        return value == "gcc" or value == "clang"
      end,
    },
    build_type = {
      type = "string",
      name = "Build type",
      optional = false,
      order = 2,
      validate = function(value)
        local str = string.lower(value)
        return str == "debug" or str == "release"
      end,
    },
    rebuild = {
      type = "boolean",
      optional = false,
      default = true,
      order = 3,
    },
    asan = {
      name = "Sanitizer",
      type = "boolean",
      optional = false,
      default = false,
      order = 4,
    },
    unity = {
      name = "Use unity",
      type = "boolean",
      optional = false,
      default = true,
      order = 5,
    },
  },
  builder = function(params)
    local function bool_to_num(value)
      return value == true and 1 or value == false and 0
    end
    local build_type = string.lower(params.build_type):gsub("^%l", string.upper)
    local rebuild_val = bool_to_num(params.rebuild)
    return {
      cmd = { vim.fs.root(".", ".git") .. "/rebuild.sh" },
      args = { params.tool_chain, build_type, rebuild_val },
      cwd = vim.fs.root(".", ".git"),
      components = { { "on_output_quickfix", open = false }, "default" },
      env = {
        USE_ASAN = bool_to_num(params.asan),
        USE_UNITY = bool_to_num(params.unity),
      },
    }
  end,
}
