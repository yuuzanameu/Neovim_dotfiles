return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("bufferline").setup({
            options = {
                separator_style = "thin",  -- or any style you prefer
                offsets = {
                    {
                        filetype = "neo-tree",  -- Specify the filetype for nvim-tree
                        text = "File Explorer",   -- Text to display
                        highlight = "Directory",   -- Highlight group for the text
                        separator = true,          -- Show a separator
                        text_align = "left",       -- Align text to the left
                    },
                },
            },
        })
    end,
}
