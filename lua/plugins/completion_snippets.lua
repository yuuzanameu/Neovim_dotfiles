return {

    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    { 'saadparwaiz1/cmp_luasnip' },
    "rafamadriz/friendly-snippets"
}
