return {
	"rmagatti/auto-session",
	lazy = false,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "/home/vladi", "~/coding", "~/Downloads", "/" },
		bypass_save_filetypes = { "snack_dashboard" },
		-- log_level = 'debug',
	},
}
