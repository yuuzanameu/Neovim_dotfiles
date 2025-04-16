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
				vim.lsp.buf.format()
			end,
		})
	end

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>ia",
		"<Cmd>lua require('idris2.code_action').case_split()<CR>",
		{ noremap = true, silent = true }
	)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
	"ShinKage/idris2-nvim",
	lazy = false,
	dependencies = {
		"neovim/nvim-lspconfig",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local opts = {
			server = {
				on_attach = on_attach,
				capabilities = capabilities,
			},
			code_action_post_hook = function()
				vim.cmd("silent write")
			end,
		}
		require("idris2").setup(opts)
	end,
}
