return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		-- config = function()
		-- 	require("mason").setup()
		-- end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"cssls",
					"html",
					"jsonls",
					"pyright",
					"elixirls",
					"rust_analyzer",
					"tailwindcss",
					"ts_ls",
				}, -- Add your desired LSPs here
				automatic_enable = {},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			-- require('lspconfig').lua_ls.setup({})
		end,
	},
}
