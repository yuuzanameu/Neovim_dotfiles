local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- if client.supports_method("textDocument/formatting") then
	-- 	vim.api.nvim_create_autocmd("BufWritePre", {
	-- 		buffer = bufnr,
	-- 		callback = function()
	-- 			vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
	-- 		end,
	-- 	})
	-- end

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
	"gopls",
	"postgres_lsp",
    "svelte"
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

-- nim lsp
-- Nim Registration
vim.lsp.config(
	"nimlangserver",
	vim.tbl_deep_extend("force", base_config, {
		cmd = { "nimlangserver" }, -- Ensure this is in your $PATH
		filetypes = { "nim", "nims" },
		root_markers = { "*.nimble", "nim.cfg", "config.nims", ".git" },
		handlers = {
			["window/showMessage"] = function(_, result, ctx)
				-- Only show the message if it's an Error (1) or Warning (2)
				-- Info is (3), Log is (4)
				if result.type <= 2 then
					vim.lsp.handlers["window/showMessage"](_, result, ctx)
				end
			end,
			["window/logMessage"] = function(_, result, ctx)
				-- Silent by default for logs
				return
			end,
		},
		settings = {
			nim = {
				inlayHints = {
					typeHints = true,
					exceptionHints = true,
					parameterHints = true,
				},
			},
		},
	})
)

-- Replace vim.lsp.enable with this if you want zero prompts:
vim.lsp.enable("nimlangserver")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "nim", "nims", "nimble" },
	callback = function(args)
		vim.lsp.start("nimlangserver")
	end,
})
