return {
  "nvimdev/guard.nvim",
  dependencies = "nvimdev/guard-collection",
  event = "BufReadPre",
  config = function()
    local ft = require("guard.filetype")

    ft("c,cpp"):fmt({
      cmd = "clang-format",
      args = { "--style={IndentWidth: 4}" },
      stdin = true,
    })

    ft("json,jsonc"):fmt("prettierd")
    ft("typescript,javascript,typescriptreact"):fmt("prettierd")

    ft("haskell"):fmt({
      cmd = "/usr/bin/fourmolu",
      args = { "--stdin-input-file", "$FILENAME" },
      stdin = true,
      ignore_error = true,
      no_append_cr = true,  -- Don't append carriage return
      try_fallback = false, -- Don't try fallback formatters
    })

    -- ft("ocaml"):fmt({
    --   cmd = "ocamlformat",
    --   args = {
    --     "--enable-outside-detected-project",
    --     "--profile=janestreet",
    --     "--let-binding-indent=4",
    --     "--if-then-else=fit-or-vertical",
    --     "--name",
    --     "dummy.ml",
    --     "-",
    --   },
    --   stdin = true,
    -- })

    ft("purescript"):fmt({
      cmd = "/home/vladi/.nvm/versions/node/v22.11.0/bin/purs-tidy",
      args = { "format" },
      stdin = true,
    })

    ft("lua"):fmt("stylua")

    ft("python"):fmt("isort")

    ft("rust"):fmt({
      cmd = "/home/vladi/.cargo/bin/rustfmt",
      ignore_error = true,
      no_append_cr = true,  -- Don't append carriage return
      try_fallback = false, -- Don't try fallback formatters
    })

    ft("odin"):fmt({
      cmd = "odinfmt",
      ignore_error = true,
      no_append_cr = true,
      try_fallback = false,
      stdin = true,
      args = { "-stdin" },
    })

    vim.g.guard_config = {
      fmt_on_save = false,
      -- use lsp if no formatter was defined for this filetype
      lsp_as_default_formatter = false,
      save_on_fmt = false,
      auto_lint = false,
      lint_interval = 500,
    }
  end,
}
