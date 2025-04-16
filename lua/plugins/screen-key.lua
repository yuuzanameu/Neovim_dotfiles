return {
	"NStefan002/screenkey.nvim",
	lazy = true,
	version = "*",
	config = function()
		require("screenkey").setup({
			disable = {
				filetypes = { "toggleterm" },
			},
		})
	end,
}
