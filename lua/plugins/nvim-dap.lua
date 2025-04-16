-- print(require("mason-registry").get_package("chrome-debug-adapter"):get_install_path() .. "/out/src/chromeDebug.js")
--google-chrome-stable –ozone-platform-hint=auto --enable-features=TouchpadOverscrollHistoryNavigation
return {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
        {
            "<leader>d",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Toggle breakpoint",
        },
        {
            "<leader>g",
            function()
                require("dap").continue()
            end,
            desc = "Continue debugging",
        },
        {
            "<leader>,",
            function()
                require("dapui").eval(nil, { enter = true })
            end,
        },
    },
    config = function()
        local dap = require("dap")
        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                args = {
                    require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                    .. "js-debug/src/dapDebugServer.js",
                    "${port}",
                },
            },
        }

        dap.configurations.javascript = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
        }

        dap.adapters.chrome = {
            type = "executable",
            command = "node",
            args = {
                require("mason-registry").get_package("chrome-debug-adapter"):get_install_path()
                .. "/out/src/chromeDebug.js",
            },
        }

        dap.configurations.typescriptreact = {
            {
                type = "chrome",
                request = "launch",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222,
                webRoot = "${workspaceFolder}",
            },
        }

        require("dapui").setup()
    end,
}
