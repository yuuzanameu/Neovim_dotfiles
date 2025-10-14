local wk = require("which-key")

wk.add({
	{
		"<C-x>",
		group = "Agda",
		mode = { "i", "n" },
		{ "<C-x><C-l>", "<Esc><cmd>CornelisLoad<cr>", desc = "Load and type-check buffer" },
		{ "<C-x><C-d>", "<Esc><cmd>CornelisTypeInfer<cr>", desc = "Show inferred type of hole contents" },
		{ "<C-x><C-n>", "<Esc><cmd>CornelisNormalize<cr>", desc = "Show inferred type of hole contents" },
	},
})
