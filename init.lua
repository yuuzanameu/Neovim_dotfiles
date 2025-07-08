-- Bootstrap lazy.nvim
if vim.g.vscode then
	require("config.vscode_neovim")
else
	require("config.basic_settings")
	require("config.keymaps")

	require("config.init")

	-- vim.cmd('colorscheme retrobox')
	vim.cmd("colorscheme gruvbox-material")
end
