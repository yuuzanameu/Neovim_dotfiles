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

	-- Bubble up to the nearest valid parent
	while node and not target_types[node:type()] do
		node = node:parent()
	end

	if not node then
		return
	end

	local parent_start, _, _, _ = node:range()

	-- 1. Check if we should even proceed.
	-- We look for the first child that COULD be folded.
	-- If it's already folded, we stop.
	local already_folded = false
	for child in node:iter_children() do
		if child:named() then
			local s_row, _, e_row, _ = child:range()
			if s_row ~= e_row then
				-- Check if the first multi-line child is already closed
				if vim.fn.foldclosed(s_row + 1) ~= -1 then
					already_folded = true
				end
				break -- Only need to check the first foldable child
			end
		end
	end

	if already_folded then
		return
	end

	-- 2. Apply the folds
	for child in node:iter_children() do
		if child:named() then
			local start_row, _, end_row, _ = child:range()
			-- Only fold multi-line children
			if start_row ~= end_row then
				local line_num = start_row + 1
				pcall(function()
					vim.cmd(line_num .. "foldclose")
				end)
			end
		end
	end

	-- Return cursor to parent start
	vim.api.nvim_win_set_cursor(0, { parent_start + 1, 0 })
end

return M
