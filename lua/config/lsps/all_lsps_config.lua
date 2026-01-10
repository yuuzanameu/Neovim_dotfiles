local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "gr", function()
		require("telescope.builtin").lsp_references()
	end, { desc = "Goto definition" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Lsp Hover" })

	-- Enable formatting on save
	-- if client.server_capabilities.documentFormattingProvider then
	-- 	vim.api.nvim_create_autocmd("BufWritePre", {
	-- 		group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
	-- 		buffer = bufnr,
	-- 		callback = function()
	-- 			vim.lsp.buf.format({})
	-- 		end,
	-- 	})
	-- end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function setup_lsps(lsp_names)
	for _, lsp_name in ipairs(lsp_names) do
		local status, err = pcall(function()
			require("lspconfig")[lsp_name].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end)
		if not status then
			print("Error setting up LSP:", lsp_name, "->", err)
		end
	end
end

local lsp_names = {
	"cssls",
	"tailwindcss",
	"html",
	"clangd",
	"jsonls",
	"ts_ls",
	"pyright",
	"purescriptls",
	"ada_ls",
	"ols",
	"roslyn",
}

setup_lsps(lsp_names)

require("lspconfig").elixirls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "/home/vladi/.local/share/nvim/mason/bin/elixir-ls" },
	-- cmd = {"/home/vladi/.local/share/nvim/mason/packages/elixir-ls/language_server.sh"},
	settings = {
		elixirLS = {
			dialyzerEnabled = false, -- Enable Dialyzer (optional, can be slow)
			fetchDeps = false, -- Don't fetch deps automatically
			suggestSpecs = true, -- Enable function spec suggestions
			signatureAfterComplete = true,
			dialyzerFormat = "dialyxir_short",
			enableTestLenses = true, -- Enables live diagnostics updates
		},
	},
})

require("lspconfig").ocamllsp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
	cmd = { "/home/vladi/.opam/4.14.2/bin/ocamllsp" },
})

-- require("lspconfig").jdtls.setup({})

vim.g.rustaceanvim = {
	server = {
		on_attach = on_attach,
	},
}

vim.g.rustfmt_autosave = 2

local cmp = require("cmp")

cmp.setup.filetype({ "sql" }, {
	sources = {
		{ name = "vim-dadbod-completion" },
		{ name = "buffer" },
	},
})
