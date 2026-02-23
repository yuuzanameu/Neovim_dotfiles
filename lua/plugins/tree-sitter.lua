return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.string_interpolate = {
      install_info = {
        url = "~/coding/tree-sitter-string_interpolate",
        files = { "src/parser.c" }
      },
      -- filetype = "string_interpolate", -- if filetype does not agrees with parser name
      used_by = { "haskell" },       -- additional filetypes that use this parser
    }

    configs.setup({
      auto_install = true,
      ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript", "html", "haskell", "json", "jsdoc" },
      sync_install = false,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      additional_vim_regex_highlighting = false,
      ignore_install = {},
    })
  end,
}
