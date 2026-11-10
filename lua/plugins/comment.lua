local M = {
  "numToStr/Comment.nvim",
  config = function()
    local ft = require("Comment.ft")
    -- Make sure these are always plain "# " comments
    ft.set("fish", "#%s").set("nu", "#%s")

    require("Comment").setup({
      -- Neovim 0.12's vim.treesitter.get_parser() returns nil (no error) when a
      -- parser is missing, which breaks Comment.nvim's pcall fallback. So when there
      -- is no parser for the buffer, use the filetype-based commentstring directly.
      pre_hook = function(ctx)
        local ok, parser = pcall(vim.treesitter.get_parser, 0)
        if not ok or not parser then
          return ft.get(vim.bo.filetype, ctx.ctype) or vim.bo.commentstring
        end
        return ft.calculate(ctx)
      end,
    })
  end,
}

return M
