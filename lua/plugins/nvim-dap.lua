return {
	"mfussenegger/nvim-dap",
	lazy = true,
	dependencies = {
		"theHamsta/nvim-dap-virtual-text",
		{
			"williamboman/mason.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				table.insert(opts.ensure_installed, "js-debug-adapter")
			end,
		},
	},
	config = function()
		local dap = require("dap")
		require("nvim-dap-virtual-text").setup({
			display_callback = function(variable)
				-- Hide anything longer than 100 characters
				if variable.value and #variable.value > 100 then
					return ""
				end
				return variable.value or ""
			end,
		})

		vim.keymap.set("n", "<leader>dd", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue Debugging" })
		vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step over" })
		vim.keymap.set("n", "<leader>dx", "<cmd>:DapTerminate<cr>", { desc = "Terminate" })
		vim.keymap.set("n", "<leader>dt", "<cmd>:DapToggleRepl<cr>", { desc = "Toggle DAP repl" })
		vim.keymap.set("n", "<leader>de", "<cmd>:DapClearBreakpoints<cr>", { desc = "Clear all breakpoints" })
		-- Adapter setup;
		if not dap.adapters["pwa-node"] then
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}
		end

		if not dap.adapters["node"] then
			dap.adapters["node"] = function(cb, config)
				if config.type == "node" then
					config.type = "pwa-node"
				end
				local nativeAdapter = dap.adapters["pwa-node"]
				if type(nativeAdapter) == "function" then
					nativeAdapter(cb, config)
				else
					cb(nativeAdapter)
				end
			end
		end

		local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

		local vscode = require("dap.ext.vscode")
		-- Allow comments in launch.json
		vscode.json_decode = function(str)
			return vim.json.decode(require("plenary.json").json_strip_comments(str))
		end

		-- Fallback configurations (used if no launch.json exists)
		for _, language in ipairs(js_filetypes) do
			if not dap.configurations[language] then
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end
		end
	end,
}
