-- Enable relative line numbers
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
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs

-- Enable auto-indentation
vim.opt.autoindent = true

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
