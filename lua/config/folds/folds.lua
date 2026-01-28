local M = {}

local target_types = {
	element = true,
	jsx_element = true,
}

function M.fold_direct_children()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local node = ts_utils.get_node_at_cursor()
	if not node then
		return
	end

	while node and not target_types[node:type()] do
		node = node:parent()
	end

	if not node then
		return
	end

	local parent_start, _, _, _ = node:range()

	for child in node:iter_children() do
		if child:named() then
			local start_row, _, end_row, _ = child:range()
			if start_row ~= end_row then
				local line_num = start_row + 1
				pcall(function()
					vim.cmd(line_num .. "foldclose")
				end)
			end
		end
	end

	vim.api.nvim_win_set_cursor(0, { parent_start + 1, 0 })
end

return M
