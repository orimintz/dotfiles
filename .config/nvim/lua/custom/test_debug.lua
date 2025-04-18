local M = {}

function M.get_test_name()
  local current_line = vim.fn.line(".")
  local fixture, test, prev_test

  for i = current_line, 1, -1 do
    local line = vim.fn.getline(i)
    if prev_test then
      fixture = line:match("TEST[_FIBER]*_[FP]*%((%w+),%s*")
      if fixture then
        test = prev_test
        break
      end
    end
    fixture, test = line:match("TEST[_FIBER]*_[FP]*%((%w+),%s*(%w+)%)")
    if fixture and (test or prev_test) then
      break
    end
    prev_test = line:match("%s*(%w+)%)")
  end

  return fixture, test
end

function M.run_test_with_gdb(build, tool_chain, filter)
  M.last_filter = filter
  M.last_build_type = build
  M.last_tool_chain = tool_chain

  local root_dir = vim.fs.root(".", ".git")
  local build_type = string.lower(build):gsub("^%l", string.upper)
  local executable = root_dir .. "/" .. build_type .. "/" .. tool_chain .. "/test/gtest_all/gtest_all"
  local cmd = string.format(":GdbStart gdb --cd=%s --args %s --gtest_filter=%s", root_dir, executable, filter)
  vim.cmd(cmd)
end

function M.run_cur_test_with_gdb(build, tool_chain)
  local fixture, test = M.get_test_name()

  if fixture and test then
    local filter = string.format("*%s.%s*", fixture, test)
    M.run_test_with_gdb(build, tool_chain, filter)
  else
    print("Not inside a test function")
  end
end

function M.run_last_test_with_gdb()
  if M.last_filter and M.last_build_type and M.last_tool_chain then
    M.run_test_with_gdb(M.last_build_type, M.last_tool_chain, M.last_filter)
  else
    print("No last test")
  end
end

function M.prompt_and_run()
  vim.ui.input({ prompt = "Tool chain" }, function(tool_chain)
    if tool_chain then
      vim.ui.input({ prompt = "Build type" }, function(build_type)
        if build_type then
          vim.ui.input({ prompt = "Test filter" }, function(filter)
            if filter then
              M.run_test_with_gdb(build_type, tool_chain, filter)
            end
          end)
        end
      end)
    end
  end)
end

return M
