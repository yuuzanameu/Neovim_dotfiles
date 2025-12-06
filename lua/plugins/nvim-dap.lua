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
          "/home/vladi/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
    local vscode = require("dap.ext.vscode")
    vscode.type_to_filetypes["node"] = js_filetypes
    vscode.type_to_filetypes["pwa-node"] = js_filetypes

    for _, language in ipairs(js_filetypes) do
      if not dap.configurations[language] then
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end

    local setup = {
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      controls = {
        icons = {
          pause = "▷",
          play = "▶",
          step_into = "▷",
          step_over = "▶",
          step_out = "▷",
          step_back = "▶",
          run_last = "▶",
          terminate = "▷",
          disconnect = "▷",
        },
      }
    }
    require("dapui").setup()
  end,
}
