local default_opts = { noremap = true, silent = true }

local function set_keymaps(mode_table, mode)
    for key, command in pairs(mode_table) do
        vim.keymap.set(mode, key, command, default_opts)
    end
end

local normal_keymaps = {
    ["<A-Left>"] = "<C-w>h",
    ["<A-Right>"] = "<C-w>l",
    ["<C-s>"] = ":w<CR>",
    ["<Space>h"] = ":noh<CR>",
    ["<C-Up>"] = "{",
    ["<C-Down>"] = "}",
    ["<S-Down>"] = "<C-f>",
    ["<S-Up>"] = "<C-b>",
}

local visual_keymaps = {
    ["<C-s>"] = "Esc:w<CR>",
}

set_keymaps(normal_keymaps, "n")
set_keymaps(visual_keymaps, "v")
