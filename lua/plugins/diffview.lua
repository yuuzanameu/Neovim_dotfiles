return {
	"sindrets/diffview.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		require("diffview").setup({
			view = {
				default = {
					layout = "diff2_vertical",
				},
			},
		})
	end,
}
