-- Get the current buffer number
local bufnr = vim.api.nvim_get_current_buf()

-- Keymap to open Minty's color shades picker, specific to the current buffer
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hs', '<cmd>lua require("minty.shades").open()<CR>',
    { noremap = true, silent = true, desc = "Open color shades" })

-- Keymap to open Minty's color picker with a border, specific to the current buffer
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hh', '<cmd>lua require("minty.huefy").open({ border = true })<CR>',
    { noremap = true, silent = true, desc = "Open color picker" })

