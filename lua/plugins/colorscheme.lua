return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({})
        end
    },
    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        config = function()
            -- Optionally configure and load the colorscheme
            -- directly inside the plugin declaration.
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_enable_italic = 1
            -- vim.cmd.colorscheme('gruvbox-material')
        end
    }
}
