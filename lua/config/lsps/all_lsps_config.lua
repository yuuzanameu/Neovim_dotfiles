local on_attach = function(client, bufnr)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition", noremap = true, silent = true })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Goto implementation" })
	vim.keymap.set("n", "gr", function()
		require("telescope.builtin").lsp_references()
	end, { desc = "Goto definition" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Lsp Hover" })

	-- Enable formatting on save
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({})
			end,
		})
	end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function setup_lsps(lsp_names)
	for _, lsp_name in ipairs(lsp_names) do
		local setup_code = string.format(
			[[
            require('lspconfig').%s.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        ]],
			lsp_name
		)

		local status, err = pcall(load(setup_code))
		if not status then
			print("Error setting up LSP:", lsp_name, "->", err)
		end
	end
end

local lsp_names = { "cssls", "tailwindcss", "html", "clangd", "jsonls", "ts_ls", "pyright" }
setup_lsps(lsp_names)
