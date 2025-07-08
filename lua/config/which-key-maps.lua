local wk = require("which-key")
wk.add({
    -- core basic keymaps
    { "<C-\\>",          "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Float Terminal" },
    { "<leader><Space>", "<cmd>Telescope buffers<cr>",          desc = "Find Open Buffers" },
    { "<leader>.",       "<cmd>Telescope oldfiles<cr>",         desc = "Recent files" },

    {
        "<leader>f",
        group = "Telescope",
        mode = { "n" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>",                                 desc = "Find File in cwd" },
        { "<leader>fb", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File browser" },
        { "<leader>fc", "<cmd>Telescope colorscheme<cr>",                                desc = "Select Colorscheme" },
        {
            "<leader>fz",
            "<cmd>Telescope current_buffer_fuzzy_find<cr>",
            desc = "Find string in Buffer",
        },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find string in CWD" },
        { "<leader>fk", "<cmd>Telescope keymaps<cr>",   desc = "Keymaps" },
    },

    {
        "<leader>b",
        group = "buffers",
        mode = { "n" },
        { "<leader>bf", "<cmd>Telescope buffers<cr>", desc = "Find Open Buffers" },
    },

    {
        "<leader>l",
        group = "LSP",
        mode = { "n" },
        { "<leader>ls", vim.lsp.buf.code_action, desc = "Simple Code actions" },
        { "<leader>li", ":LspInfo<CR>",          desc = "LSP Info" },
        { "<leader>ll", vim.lsp.codelens.run,    desc = "Code lens" },
        { "<leader>lr", vim.lsp.buf.rename,      desc = "Rename" },
        {
            "<leader>la",
            function()
                require("tiny-code-action").code_action()
            end,
            desc = "Tiny Code Actions Plugin",
        },
    },
})
-- "<localleader>",
-- mode = { "n" },
-- {
-- 	"i",
-- 	function()
-- 		vim.cmd("call cornelis#prompt_input()")
-- 	end,
-- 	desc = "Prompt Input for agda",
-- },
