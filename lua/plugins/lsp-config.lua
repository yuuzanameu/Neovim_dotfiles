return {
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls' }, -- Add your desired LSPs here
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = function()
            -- require('lspconfig').lua_ls.setup({})
        end,
    },
}
