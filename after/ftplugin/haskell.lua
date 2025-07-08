-- print("Haskell ftplugin loaded!")
-- Define highlight for quasiquote body - nice green color

-- vim.api.nvim_set_hl(0, "@quasiquote_body.haskell", { fg = "#00FF00" })

-- vim.treesitter.query.set("haskell", "highlights", "(quasiquote_body) @keyword.haskell")


vim.treesitter.query.set(
    "haskell",
    "injections",
    [[;extends
        (quasiquote
            (quoter) @_name
            (#any-of? @_name "i" "iii" "__i")
            (quasiquote_body) @injection.content
            (#set! injection.language "string_interpolate"))
    ]]
)

-- @punctuation.special
-- @keyword-directive
