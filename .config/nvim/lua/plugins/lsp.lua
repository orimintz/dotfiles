return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--header-insertion=never",
            "--all-scopes-completion",
            "--background-index",
            "--pch-storage=disk",
            "--completion-style=detailed",
            "--enable-config", -- clangd 11+ supports reading from .clangd configuration file
            "--clang-tidy",
            "--offset-encoding=utf-16",
            "--function-arg-placeholders=1",
            "-j=8",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          filetypes = { "cc", "cpp", "c", "h", "hpp" },
          root_dir = require("lspconfig").util.root_pattern(".git", "compile_commands.json"),
          single_file_support = true,
        },
        harper_ls = {
          settings = {
            ["harper-ls"] = {
              linters = {
                SpellCheck = true,
                SpelledNumbers = false,
                AnA = true,
                SentenceCapitalization = false,
                UnclosedQuotes = true,
                WrongQuotes = false,
                LongSentences = false,
                RepeatedWords = true,
                Spaces = true,
                Matcher = false,
                CorrectNumberSuffix = true,
              },
              diagnosticSeverity = "hint",
            },
          },
        },
      },
    },
  },
}
