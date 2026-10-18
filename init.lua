-- Bootstrap lazy.nvim
if vim.g.vscode then
    require("config.vscode_neovim")
else
    require("config.init")
    -- vim.cmd('colorscheme retrobox')
    vim.cmd("colorscheme gruvbox-baby")
end
