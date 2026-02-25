local M = {
	"ThePrimeagen/99",
	config = function()
		local _99 = require("99")

		local cwd = vim.uv.cwd()
		local basename = vim.fs.basename(cwd)
		_99.setup({
			provider = _99.Providers.ClaudeCodeProvider,
			-- model is optional, overrides the provider's default
			model = "claude-sonnet-4-5",
			logger = {
				level = _99.DEBUG,
				path = "/tmp/" .. basename .. ".99.debug",
				print_on_error = true,
			},
			tmp_dir = "./tmp",

			completion = {
				custom_rules = {
					"scratch/custom_rules/",
				},

				files = {
					-- enabled = true,
					max_file_size = 102400,
					max_files = 5000,
					exclude = { ".env", ".env.*", "node_modules", ".git" },
				},

				source = "cmp",
			},

			md_files = {
				"AGENT.md",
			},
		})

		vim.keymap.set("v", "<leader>9v", function()
			_99.visual()
		end)

		vim.keymap.set("n", "<leader>9x", function()
			_99.stop_all_requests()
		end)

		vim.keymap.set("n", "<leader>9s", function()
			_99.search()
		end)
	end,
}

return {}
