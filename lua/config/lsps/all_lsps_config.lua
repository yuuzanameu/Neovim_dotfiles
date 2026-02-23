local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "gr", function()
		require("telescope.builtin").lsp_references()
	end, { desc = "Goto references", buffer = bufnr })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Lsp Hover", buffer = bufnr })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Base configuration shared across servers
local base_config = {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Servers without special configuration
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

for _, name in ipairs(lsp_names) do
	vim.lsp.config(name, base_config)
	vim.lsp.enable(name)
end

-- Elixir
vim.lsp.config(
	"elixirls",
	vim.tbl_deep_extend("force", base_config, {
		cmd = { "/home/vladi/.local/share/nvim/mason/bin/elixir-ls" },
		settings = {
			elixirLS = {
				dialyzerEnabled = false,
				fetchDeps = false,
				suggestSpecs = true,
				signatureAfterComplete = true,
				dialyzerFormat = "dialyxir_short",
				enableTestLenses = true,
			},
		},
	})
)
vim.lsp.enable("elixirls")

-- OCaml
vim.lsp.config(
	"ocamllsp",
	vim.tbl_deep_extend("force", base_config, {
		cmd = { "/home/vladi/.opam/4.14.2/bin/ocamllsp" },
		filetypes = {
			"ocaml",
			"ocaml.menhir",
			"ocaml.interface",
			"ocaml.ocamllex",
			"reason",
			"dune",
		},
	})
)
vim.lsp.enable("ocamllsp")

-- Uiua
vim.lsp.config(
	"uiua",
	vim.tbl_deep_extend("force", base_config, {
		cmd = { "uiua", "lsp" },
		filetypes = { "uiua" },
		root_markers = { "main.ua", ".fmt.ua", ".git" },
	})
)
vim.lsp.enable("uiua")

-- Rust (rustaceanvim handles rust-analyzer internally)
vim.g.rustaceanvim = {
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
}

vim.g.rustfmt_autosave = 2

-- nvim-cmp SQL setup
local cmp = require("cmp")

cmp.setup.filetype({ "sql" }, {
	sources = {
		{ name = "vim-dadbod-completion" },
		{ name = "buffer" },
	},
})
