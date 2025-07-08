local M = {
    {
        dir = "~/coding/llmchat.nvim",
        name = "llm.nvim",
        lazy = false, -- or true if you want it to load on specific events
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("llmchat").setup() -- assuming your plugin exposes a setup function
        end,
    },
}

return {}
