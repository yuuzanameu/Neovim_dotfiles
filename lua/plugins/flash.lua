return {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
        require("flash").setup({
            -- Disable the default keymaps for f, F, t, and T
            modes = {
                char = {
                    enabled = false, -- Disable f, F, t, and T motions
                },
            },
        })

        -- Define the key mappings
        vim.keymap.set({ "n", "x", "o" }, "f", function() require("flash").jump() end, { desc = "Flash" })
        vim.keymap.set({ "n", "x", "o" }, "F", function() require("flash").treesitter() end,
            { desc = "Flash Treesitter" })
    end,
}
