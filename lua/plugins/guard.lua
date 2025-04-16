return {
    "nvimdev/guard.nvim",
    dependencies = "nvimdev/guard-collection",
    event = "BufReadPre",
    config = function()
        local ft = require("guard.filetype")

        ft('c,cpp'):fmt({
            cmd = "clang-format",
            args = { "--style={IndentWidth: 4}" },
            stdin = true,
        })

        ft('json,jsonc,typescript,javascript,typescriptreact'):fmt('prettierd')
        -- ft('haskell'):fmt({
        --     cmd = "/usr/bin/fourmolu",
        --     args = { "--stdin-input-file", "$FILENAME" },
        --     stdin = true,
        -- })

        ft('haskell'):fmt({
            cmd = "/usr/bin/fourmolu",
            args = { "--stdin-input-file", "$FILENAME" },
            stdin = true,
            ignore_error = true,
            no_append_cr = true, -- Don't append carriage return
            try_fallback = false -- Don't try fallback formatters
        })
        ft("lua"):fmt("stylua")

        vim.g.guard_config = {
            fmt_on_save = true,
            -- use lsp if no formatter was defined for this filetype
            lsp_as_default_formatter = false,
            save_on_fmt = true,
            auto_lint = false,
            lint_interval = 500
        }
    end
}
