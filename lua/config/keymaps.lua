vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { noremap = true, silent = true, desc = 'Toggle NeoTree' })
vim.keymap.set('n', '<leader>c', '<cmd>bd<cr>', {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Close buffer'
})
vim.keymap.set('i', '<C-BS>', '<C-w>', { noremap = true })

--vim.keymap.del("n", "c") -- Normal mode
--vim.keymap.del("i", "c") -- Insert mode
--vim.keymap.del("v", "c") -- Visual mode
-- In your keymaps.lua or directly in the Comment.nvim config
vim.api.nvim_set_keymap('n', '<leader>/', '<Plug>(comment_toggle_linewise_current)',
    { noremap = true, silent = true, desc = 'Toggle comment' })
vim.api.nvim_set_keymap('v', '<leader>/', '<Plug>(comment_toggle_linewise_visual)',
    { noremap = true, silent = true, desc = 'Toggle comment' });

-- Remap <LocalLeader>c-c to <LocalLeader>c-v for Vlime lisp server
-- vim.api.nvim_set_keymap('n', '<LocalLeader>lv', '<LocalLeader>cc',
--     { noremap = true, silent = true, desc = 'Connect to Vlime' })

-- Unmap keys in normal mode
local default_opts = { noremap = true, silent = true }

local normal_keymaps = {
    ['<A-Up>'] = ':m .-2<CR>==',
    ['<A-Down>'] = ":m .+1<CR>==",
    ["<A-Left>"] = "<C-w>h",
    ["<A-Right>"] = "<C-w>l",
    ['<C-s>'] = ':w<CR>',
    [']b'] = ':bnext<CR>',
    ['[b'] = ':bprevious<CR>',
    -- ['<C-h>'] = '<C-w>h',
    -- ['<C-l>'] = '<C-w>l',
    ['<leader>h'] = ':noh<CR>',
}

local insert_keymaps = {
    ["<A-Up>"] = "<Esc>:m .-2<CR>==gi",
    ["<A-Down>"] = "<Esc>:m .+1<CR>==gi",
    ["<A-Left>"] = "<Esc><C-w>h",
    ["<A-Right>"] = "<Esc><C-w>l",
    ["<C-s>"] = "<Esc>:w<CR>",
}

local visual_keymaps = {
    ['<C-s>'] = 'Esc:w<CR>',
}

local function set_keymaps(mode_table, mode)
    for key, command in pairs(mode_table) do
        vim.keymap.set(mode, key, command, default_opts)
    end
end

set_keymaps(normal_keymaps, 'n')
set_keymaps(insert_keymaps, 'i')
set_keymaps(visual_keymaps, 'v')
