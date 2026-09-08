-- tsc.lua
local M = {
	"dmmulroy/tsc.nvim",
	config = function()
		require("tsc").setup({
			-- use_trouble_qflist = true,
			use_diagnostics = false,
			bin_name = "tsc",
			enable_progress_notifications = true,
			enable_error_notifications = false,
			flags = {
				noEmit = true,
				project = function()
					return utils.find_nearest_tsconfig()
				end,
				watch = true,
			},
		})
	end,
}

return {}
