-- Enable relative line numbers
vim.o.shell = "/usr/bin/fish"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.undofile = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.showmatch = true

vim.opt.mouse = "a"

-- Highlight the current line
vim.opt.cursorline = true

-- Enable syntax highlighting
vim.cmd("syntax on") -- This is still valid in Lua

-- Set the clipboard to use the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Enable incremental search
vim.opt.incsearch = true

-- Highlight search results
vim.opt.hlsearch = true

-- Set tab width and indentation

-- Enable auto-indentation
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2   -- Number of spaces to use for each step of (auto)indent
vim.opt.tabstop = 4      -- Number of spaces that a <Tab> counts for

-- Set the default file encoding
-- vim.opt.encoding = 'utf-8'

-- Enable line wrapping
vim.opt.wrap = true

-- Set the default theme (optional)
vim.opt.termguicolors = true -- Enable 24-bit RGB colors

-- vim.opt.filetype = "on"
vim.opt.hidden = true

-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- dadbod config
vim.g.db_ui_winwidth = 31
vim.g.db_ui_table_helpers = {
  postgresql = {
    Count = 'select % from "{table};"',
  },
}
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_win_position = "right"
vim.g.db_ui_disable_info_notifications = 1

-- to find more options: https://github.com/kristijanhusak/vim-dadbod-ui/blob/master/plugin/db_ui.vim
-- dadbod config ends

-- vim.g.dbs = {
-- 	{ name = "editor_userdata", url = "postgres://postgres:1772@localhost:5432/editor_userdata" },
-- 	{ name = "latest_qa_db", url = "postgres://postgres:1772@localhost:5432/latest_qa_db" },
-- 	{
-- 		name = "production",
-- 		url = function()
-- 			return vim.fn.system("get-prod-url")
-- 		end,
-- 	},
-- }

vim.g.cornelis_agda_prefix = "<Tab>"

-- vim.g.autoformat = false

vim.opt.fixeol = false

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.g.cornelis_split_location = "bottom"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
