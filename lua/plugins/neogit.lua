local function toggle_neogit()
	-- Check if a Neogit buffer is open
	local neogit_open = false
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
			if filetype == "NeogitStatus" then
				neogit_open = true
				-- Get the window displaying this buffer
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_buf(win) == buf then
						-- Close the window
						vim.api.nvim_win_close(win, true)
						return
					end
				end
			end
		end
	end

	-- If no Neogit buffer is open, open Neogit in floating mode
	if not neogit_open then
		vim.cmd("Neogit kind=floating")
	end
end

return {
	"NeogitOrg/neogit",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed.
		"nvim-telescope/telescope.nvim", -- optional
	},
	keys = {
		{ "<C-/>", toggle_neogit, desc = "Toggle neogit" },
	},
	config = true,
}
