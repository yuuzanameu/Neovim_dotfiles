return {
  {
    "nvim-neorg/neorg",
    lazy = false, 
    build = ":Neorg sync-parsers", -- Build parsers for Neorg
    version = '*',
    dependencies = {
      "nvim-lua/plenary.nvim", 
      "nvim-treesitter/nvim-treesitter", 
      "nvim-neorg/neorg-telescope", 
      "hrsh7th/nvim-cmp", 
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {}, -- Load default settings
          ["core.concealer"] = { -- Enable concealers for icons
            config = {
              icon_preset = "diamond", -- Use "diamond", "varied", or "basic" for different icon styles
              icons = {
                code_block = {
                  conceal = true, -- Conceal code block markers
                  width = "content", -- Adjust width to content
                },
                heading = {
                  level_1 = {
                    icon = "◉", -- Custom icon for level 1 headings
                  },
                  level_2 = {
                    icon = "○", -- Custom icon for level 2 headings
                  },
                  level_3 = {
                    icon = "✸", -- Custom icon for level 3 headings
                  },
                },
              },
            },
          },
          ["core.keybinds"] = { -- Configure keybinds
            config = {
              default_keybinds = true, -- Enable default keybinds
              neorg_leader = "<Leader>n", -- Set the Neorg leader key
            },
          },
          ["core.completion"] = { -- Enable autocompletion
            config = {
              engine = "nvim-cmp", -- Use nvim-cmp for autocompletion
            },
          },
          ["core.integrations.treesitter"] = {}, -- Enable Treesitter integration
          ["core.export"] = {}, -- Enable exporting to other formats
          ["core.export.markdown"] = { -- Enable Markdown export
            config = {
              extensions = "all", -- Export all extensions
            },
          },
        },
      })
    end,
  },
}
