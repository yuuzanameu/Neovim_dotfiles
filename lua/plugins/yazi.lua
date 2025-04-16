return {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- Keymappings for Yazi
      {
        "<leader>zf",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>zz",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- Requires yazi version with toggle support
        '<leader>zs',
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    config = function()
      require("yazi").setup({
        -- Configuration options
        open_for_directories = false,
        keymaps = {
          show_help = '<f1>',
        },
      })
    end,
}
