vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { noremap = true, silent = true, desc = "Toggle NeoTree" })
vim.keymap.set("n", "<leader>c", "<cmd>bd<cr>", {
    noremap = true,
    silent = true,
    nowait = true,
    desc = "Close buffer",
})
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true })

--vim.keymap.del("n", "c") -- Normal mode
--vim.keymap.del("i", "c") -- Insert mode
--vim.keymap.del("v", "c") -- Visual mode
-- In your keymaps.lua or directly in the Comment.nvim config
vim.api.nvim_set_keymap(
    "n",
    "<leader>/",
    "<Plug>(comment_toggle_linewise_current)",
    { noremap = true, silent = true, desc = "Toggle comment" }
)
vim.api.nvim_set_keymap(
    "v",
    "<leader>/",
    "<Plug>(comment_toggle_linewise_visual)",
    { noremap = true, silent = true, desc = "Toggle comment" }
)

-- Remap <LocalLeader>c-c to <LocalLeader>c-v for Vlime lisp server
-- vim.api.nvim_set_keymap('n', '<LocalLeader>lv', '<LocalLeader>cc',
--     { noremap = true, silent = true, desc = 'Connect to Vlime' })

-- Unmap keys in normal mode
local default_opts = { noremap = true, silent = true }

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

local normal_keymaps = {
    ["<A-Up>"] = ":m .-2<CR>==",
    ["<A-Down>"] = ":m .+1<CR>==",
    ["<A-Left>"] = "<C-w>h",
    ["<A-Right>"] = "<C-w>l",
    ["<C-s>"] = ":w<CR>",
    ["]b"] = ":bnext<CR>",
    ["[b"] = ":bprevious<CR>",
    -- ['<C-h>'] = '<C-w>h',
    -- ['<C-l>'] = '<C-w>l',
    ["<leader>h"] = ":noh<CR>",
    ["<C-/>"] = toggle_neogit,
}

local insert_keymaps = {
    ["<A-Up>"] = "<Esc>:m .-2<CR>==gi",
    ["<A-Down>"] = "<Esc>:m .+1<CR>==gi",
    ["<A-Left>"] = "<Esc><C-w>h",
    ["<A-Right>"] = "<Esc><C-w>l",
    ["<C-s>"] = "<Esc>:w<CR>",
}

local visual_keymaps = {
    ["<C-s>"] = "Esc:w<CR>",
}

local function set_keymaps(mode_table, mode)
    for key, command in pairs(mode_table) do
        vim.keymap.set(mode, key, command, default_opts)
    end
end

set_keymaps(normal_keymaps, "n")
set_keymaps(insert_keymaps, "i")
set_keymaps(visual_keymaps, "v")
