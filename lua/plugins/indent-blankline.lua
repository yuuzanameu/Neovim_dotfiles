return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {},
	config = function()
		require("ibl").setup({
            exclude = {
                filetypes = {"dashboard", "terminal"}
            }
        })
	end,
}
