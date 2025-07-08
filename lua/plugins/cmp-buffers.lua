return {
	"hrsh7th/cmp-buffer",
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			sources = {
				{ name = "buffer" },
			},
		})
	end,
}

-- postgres://postgres:1772@localhost:5432/editor_userdata
