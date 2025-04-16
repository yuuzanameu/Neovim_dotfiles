local on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code actions' })

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
    -- vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Information' })
    -- Enable formatting on save
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end
end


local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false, -- Disable telemetry
            },
        },
    },
})
