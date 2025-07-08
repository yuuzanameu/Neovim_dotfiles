return {
    "FStarLang/VimFStar",
    ft = { "fstar" },
    config = function()
        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            pattern = { "*.fst", "*.fsti" },
            callback = function()
                vim.opt_local.filetype = "fstar"
                vim.cmd("syntax enable")
            end,
        })
    end,
}
