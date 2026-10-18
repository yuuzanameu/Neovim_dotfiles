local M = {}

-- each op takes a list of lines and returns a new list of lines
M.ops = {
  number = function(lines)
    return vim.iter(lines):enumerate():map(function(i, l) return i .. ". " .. l end):totable()
  end,
  bullet = function(lines)
    return vim.iter(lines):map(function(l) return "- " .. l end):totable()
  end,
  trim = function(lines)
    return vim.iter(lines):map(vim.trim):totable()
  end,
  sort = function(lines)
    local out = vim.deepcopy(lines)
    table.sort(out)
    return out
  end,
  reverse = function(lines)
    return vim.iter(lines):rev():totable()
  end,
  unique = function(lines)
    local seen, out = {}, {}
    for _, l in ipairs(lines) do
      if not seen[l] then
        seen[l] = true; out[#out + 1] = l
      end
    end
    return out
  end,
}

vim.api.nvim_create_user_command("Tx", function(o)
  local op = M.ops[o.args]
  if not op then
    vim.notify("Tx: unknown op '" .. o.args .. "'", vim.log.levels.ERROR)
    return
  end
  local lines = vim.api.nvim_buf_get_lines(0, o.line1 - 1, o.line2, false)
  vim.api.nvim_buf_set_lines(0, o.line1 - 1, o.line2, false, op(lines))
end, {
  nargs = 1,
  range = true,
  complete = function()
    local names = vim.tbl_keys(M.ops)
    table.sort(names)
    return names
  end,
})

return M
