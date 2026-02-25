local M = {
  "isovector/cornelis",
  name = "cornelis",
  ft = "agda",
  build = "stack install",
  dependencies = { "neovimhaskell/nvim-hs.vim", "kana/vim-textobj-user" },
  version = "*",
  config = function()
    local function CornelisLoadWrapper()
      if vim.fn.exists(":CornelisLoad") == 2 then
        vim.cmd("CornelisLoad")
      end
    end

    vim.api.nvim_create_autocmd({ "BufReadPre", "BufWritePost" }, {
      pattern = { "*.agda", "*.lagda*" },
      callback = CornelisLoadWrapper,
    })
  end,
}

return {}
