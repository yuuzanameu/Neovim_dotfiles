require('config.lazy');
require('config.dashboard');
require('config.cmp_snippets');
require('config.which-key-maps');


-- config/init.lua
local config_path = vim.fn.stdpath('config')
local lsp_files = vim.fn.glob(config_path .. "/lua/config/lsps/*.lua", 0, 1)


local function get_module_name(file_path)
    local module_name = file_path:gsub(config_path .. "/lua/", "")
    module_name = module_name:gsub("/", ".")
    module_name = module_name:gsub("%.lua$", "")
    return module_name
end

for _, file in ipairs(lsp_files) do
    local module_name = get_module_name(file)
    require(module_name)
end
