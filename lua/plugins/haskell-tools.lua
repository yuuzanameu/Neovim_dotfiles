return {
    'mrcjkb/haskell-tools.nvim',
    version = '^4',     -- Recommended
    lazy = false,       -- This plugin is already lazy
    config = function() -- Optional, see Advanced configuration
        vim.g.haskell_tools = {}
    end,
    -- load the plugin when opening one of the following file types
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
}
