return {
	{ "projekt0n/github-nvim-theme", name = "github-theme" },
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_enable_italic = 1
			-- vim.cmd.colorscheme('gruvbox-material')
		end,
	},
	{
		"luisiacc/gruvbox-baby",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_baby_keyword_style = "italic"
		end,
	},
}
