local thing = {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.fourmolu,
                null_ls.builtins.formatting.prettierd,
                null_ls.builtins.formatting.stylua,
                -- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    local format_on_save = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = format_on_save,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                async = false,
                                bufnr = bufnr,
                                filter = function(_client)
                                    return _client.name == "null-ls"
                                end
                            })
                        end,
                    })
                end
            end
        })
    end
}

return {}
