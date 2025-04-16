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
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
	"Julian/lean.nvim",
	event = { "BufReadPre *.lean", "BufNewFile *.lean" },

	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
	},

	---@type lean.Config
	opts = {
		mappings = true,
	},

	config = function()
		require("lean").setup({
			lsp = {
				on_attach = on_attach,
				capabilities = capabilities,
			},
			mappings = true,
		})
	end,
}
