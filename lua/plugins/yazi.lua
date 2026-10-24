-- ~/.config/nvim/lua/plugins/yazi.lua
--
-- yazi.nvim, with image previews drawn by image.nvim.
--
-- Neovim's :terminal speaks no graphics protocol, so yazi can't draw images
-- itself in the float. Instead yazi tells us which file is hovered (the
-- `User YaziDDSHover` event, data.url) and image.nvim draws it over yazi's
-- preview column.
--
-- Companion piece, already in place:
--   ~/.config/yazi/plugins/nvim-aware-image.yazi/main.lua  (no-op when $NVIM)
--   yazi.toml -> [plugin] prepend_previewers = [{ mime = "image/*", run = "nvim-aware-image" }]
--
-- Tuning: :YaziImageDebug prints the rectangle being used.

---------------------------------------------------------------------------
-- image preview bridge
---------------------------------------------------------------------------

local preview = {}

preview.opts = {
  -- must match `[mgr] ratio` in yazi.toml -- parent / current / preview
  ratio = { 1, 4, 3 },

  -- rows yazi reserves for its header and status bar
  header_rows = 1,
  footer_rows = 1,

  -- nudge the rectangle, in terminal cells, if the image sits wrong
  pad = { left = 0, top = 0, right = 0, bottom = 0 },

  -- wait this long after the last hover before drawing, so holding `j`
  -- through a folder of images doesn't render every one of them
  debounce_ms = 50,

  extensions = {
    "png", "jpg", "jpeg", "gif", "webp", "bmp",
    "avif", "tif", "tiff", "ico", "heic",
  },
}

local state = { buf = nil, img = nil, seq = 0, path = nil }

local function is_image(path)
  local ext = path and path:match("%.([%w]+)$")
  if not ext then
    return false
  end
  ext = ext:lower()
  for _, e in ipairs(preview.opts.extensions) do
    if e == ext then
      return true
    end
  end
  return false
end

function preview.clear()
  -- bumping seq invalidates any render still sitting in a timer
  state.seq = state.seq + 1
  if state.img then
    local img = state.img
    state.img = nil
    pcall(function()
      img:clear()
    end)
  end
end

--- The screen rectangle of yazi's preview column, in absolute terminal cells.
function preview.rect()
  if not state.buf then
    return nil
  end
  local win = vim.fn.bufwinid(state.buf)
  if win == -1 then
    return nil
  end

  local pos = vim.api.nvim_win_get_position(win)
  local row, col = pos[1], pos[2]
  local w = vim.api.nvim_win_get_width(win)
  local h = vim.api.nvim_win_get_height(win)

  local o = preview.opts
  local r = o.ratio
  local split = math.floor(w * (r[1] + r[2]) / (r[1] + r[2] + r[3]))

  return {
    x = col + split + o.pad.left,
    y = row + o.header_rows + o.pad.top,
    width = w - split - o.pad.left - o.pad.right,
    height = h - o.header_rows - o.footer_rows - o.pad.top - o.pad.bottom,
  }
end

function preview.show(path)
  preview.clear()
  state.path = path
  if not is_image(path) then
    return
  end

  local seq = state.seq
  vim.defer_fn(function()
    if seq ~= state.seq or not state.buf then
      return
    end

    local ok, api = pcall(require, "image")
    if not ok then
      return
    end

    local rect = preview.rect()
    if not rect or rect.width < 2 or rect.height < 2 then
      return
    end

    -- No `window` key on purpose: these are absolute screen coordinates, so
    -- the image isn't clipped to (or hidden by) the terminal buffer under it.
    local made, img = pcall(api.from_file, path, rect)
    if not made or not img then
      return
    end
    pcall(function()
      img:render(rect)
    end)

    if seq ~= state.seq then
      pcall(function()
        img:clear()
      end)
      return
    end
    state.img = img
  end, preview.opts.debounce_ms)
end

--- Called with yazi's terminal buffer each time yazi opens.
function preview.attach(buf)
  state.buf = buf
  state.path = nil
  preview.clear()

  local group = vim.api.nvim_create_augroup("YaziImageBuffer", { clear = true })

  vim.api.nvim_create_autocmd({ "BufHidden", "BufWipeout", "TermClose" }, {
    group = group,
    buffer = buf,
    callback = function()
      preview.clear()
      state.buf = nil
    end,
  })

  vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
    group = group,
    callback = function()
      if state.buf and state.path then
        preview.show(state.path)
      end
    end,
  })
end

function preview.setup()
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("YaziImage", { clear = true }),
    pattern = "YaziDDSHover",
    callback = function(args)
      if not state.buf then
        return
      end
      preview.show(args.data and args.data.url or nil)
    end,
  })

  vim.api.nvim_create_user_command("YaziImageDebug", function()
    print(vim.inspect({
      buf = state.buf,
      path = state.path,
      rect = preview.rect(),
      has_image_nvim = pcall(require, "image"),
    }))
  end, { desc = "Show the rectangle yazi.nvim image previews are drawn into" })
end

---------------------------------------------------------------------------
-- plugin spec
---------------------------------------------------------------------------

return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  -- image.nvim is required for previews; uncomment if it isn't already
  -- declared somewhere else in your config
  -- dependencies = { "3rd/image.nvim" },
  keys = {
    {
      "<leader>zf",
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "<leader>zz",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<leader>zs",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  config = function()
    preview.setup()

    require("yazi").setup({
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },

      -- Full screen and borderless keeps the float's origin at (0,0), which
      -- makes the preview rectangle above easy to get right. Shrink it later
      -- if you want; the math follows the window either way.
      -- floating_window_scaling_factor = 1,
      -- yazi_floating_window_border = "none",

      hooks = {
        yazi_opened = function(_preselected_path, buffer, _config)
          preview.attach(buffer)
        end,
        yazi_closed_successfully = function()
          preview.clear()
        end,
      },
    })
  end,
}
