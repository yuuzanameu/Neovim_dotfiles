local M = {
    "isovector/cornelis",
    name = "cornelis",
    ft = "agda",
    build = "stack install",
    dependencies = { "neovimhaskell/nvim-hs.vim", "kana/vim-textobj-user" },
    version = "*",
}

return M
