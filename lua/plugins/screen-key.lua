local M = {
  "NStefan002/screenkey.nvim",
  lazy = false,
  version = "*",
  config = function()
    require("screenkey").setup({
      disable = {
        filetypes = { "toggleterm" },
      },
    })
  end,
}
return M
