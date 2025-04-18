local function generate_keymaps()
  local keymaps = {}
  local asan = { [""] = { val = false, name = "" }, s = { val = true, name = "sanitizer" } }
  local tool_chain = { g = "gcc", c = "clang" }
  local build_type = { d = "debug", r = "release" }
  local wk = require("which-key")

  for asan_key, asan_val in pairs(asan) do
    local keymap = "<leader>b" .. asan_key
    if string.len(asan_key) > 0 then
      wk.add({ keymap, group = asan_val.name })
    end
    for tc_key, tc_val in pairs(tool_chain) do
      keymap = "<leader>b" .. asan_key .. tc_key
      wk.add({ keymap, group = tc_val })
      for bt_key, bt_val in pairs(build_type) do
        keymap = "<leader>b" .. asan_key .. tc_key .. bt_key
        local desc = ""
        if string.len(asan_key) > 0 then
          desc = "Build RDB " .. asan_val.name .. " " .. tc_val .. " " .. bt_val
        else
          desc = "Build RDB " .. tc_val .. " " .. bt_val
        end
        table.insert(keymaps, {
          keymap,
          function()
            local params = {
              tool_chain = tc_val,
              build_type = bt_val,
              asan = asan_val.val,
              unity = true,
              rebuild = false,
            }
            require("overseer").run_template({ name = "rdb build", params = params, prompt = "avoid" })
          end,
          desc = desc,
          mode = "n",
        })
      end
    end
  end

  local extra_keys = {
    {
      "<F6>",
      function()
        require("overseer").run_template({ name = "rdb build" })
      end,
      desc = "Build RDB",
    },
    {
      "<F2>",
      function()
        require("overseer").run_template({ name = "generate compile commands", prompt = "avoid" })
      end,
      desc = "Gen Debug compile commands",
    },
    {
      "<S-F2>",
      function()
        require("overseer").run_template({ name = "generate compile commands" })
      end,
      desc = "Gen compile commands",
    },
    {
      "<F7>",
      function()
        require("overseer").toggle()
      end,
      desc = "Toggle overseer output",
    },
    {
      "<F12>",
      function()
        require("overseer").run_template({ name = "rdb regression", prompt = "avoid" })
      end,
      desc = "RDB regression",
    },
  }
  table.move(extra_keys, 1, #extra_keys, #keymaps + 1, keymaps)
  return keymaps
end

return {
  "stevearc/overseer.nvim",
  opts = { templates = { "builtin", "rdb", "compile_commands" } },
  keys = generate_keymaps(),
}
