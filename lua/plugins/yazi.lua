-- ~/.config/nvim/lua/plugins/yazi.lua
--
-- yazi.nvim, with image / video / pdf previews drawn by image.nvim.
--
-- Neovim's :terminal speaks no graphics protocol, so yazi can't draw in the
-- float. Instead yazi tells us which file is hovered (`User YaziDDSHover`,
-- data.url); for images we render the file directly, and for video and pdf we
-- generate a thumbnail with the same tools yazi uses (ffmpeg, pdftoppm) and
-- render that.
--
-- Companion pieces, in ~/.config/yazi/plugins/:
--   nvim-aware-image.yazi/main.lua
--   nvim-aware-video.yazi/main.lua
--   nvim-aware-pdf.yazi/main.lua
-- each a no-op when $NVIM is set, plus the prepend_previewers rules in yazi.toml.
--
-- Tuning: :YaziImageDebug

---------------------------------------------------------------------------
-- preview bridge
---------------------------------------------------------------------------

local uv = vim.uv or vim.loop

local preview = {}

preview.opts = {
  -- must match `[mgr] ratio` in yazi.toml -- parent / current / preview
  ratio = { 1, 4, 3 },

  -- rows yazi reserves for its header and status bar
  header_rows = 1,
  footer_rows = 1,

  -- nudge the rectangle, in terminal cells, if the preview sits wrong
  pad = { left = 0, top = 0, right = 0, bottom = 0 },

  -- wait this long after the last hover before doing any work, so holding `j`
  -- through a folder doesn't render -- or thumbnail -- every single file
  debounce_ms = 50,

  -- false: never blow a preview up past its natural pixel size
  upscale = false,

  -- false: top-left of the preview column, the way yazi does it
  center = false,

  images = {
    "png", "jpg", "jpeg", "gif", "webp", "bmp",
    "avif", "tif", "tiff", "ico", "heic",
  },
  videos = {
    "mp4", "mkv", "webm", "mov", "avi", "m4v",
    "flv", "wmv", "mpg", "mpeg", "ts", "m2ts",
  },
  docs = { "pdf" },

  -- how far into a video to grab the still (falls back to frame 0)
  video_seek = "00:00:01",

  -- pixel width of generated thumbnails
  thumb_width = 1200,

  -- generated thumbnails live here; safe to delete at any time
  cache_dir = vim.fn.stdpath("cache") .. "/yazi-preview",
}

local state = { buf = nil, img = nil, seq = 0, path = nil }

---------------------------------------------------------------------------
-- what kind of file is this
---------------------------------------------------------------------------

local function kind_of(path)
  local ext = path and path:match("%.([%w]+)$")
  if not ext then
    return nil
  end
  ext = ext:lower()

  local function listed(list)
    for _, e in ipairs(list) do
      if e == ext then
        return true
      end
    end
    return false
  end

  if listed(preview.opts.images) then
    return "image"
  elseif listed(preview.opts.videos) then
    return "video"
  elseif listed(preview.opts.docs) then
    return "pdf"
  end
  return nil
end

---------------------------------------------------------------------------
-- thumbnails for the things image.nvim can't open directly
---------------------------------------------------------------------------

--- Cache path for this file's thumbnail, keyed on path + mtime + size so an
--- edited file gets a fresh one.
local function thumb_path(path)
  local st = uv.fs_stat(path)
  if not st then
    return nil
  end
  local key = vim.fn.sha256(
    table.concat({ path, tostring(st.mtime.sec), tostring(st.size) }, ":")
  )
  return preview.opts.cache_dir .. "/" .. key .. ".png"
end

local function spawn(cmd, done)
  if vim.system then
    vim.system(cmd, { text = false }, function(res)
      vim.schedule(function()
        done(res.code == 0)
      end)
    end)
  else
    vim.fn.jobstart(cmd, {
      on_exit = function(_, code)
        done(code == 0)
      end,
    })
  end
end

local function video_cmd(path, out, seek)
  return {
    "ffmpeg", "-v", "error", "-y",
    "-ss", seek,
    "-i", path,
    "-vframes", "1",
    "-vf", "scale=" .. preview.opts.thumb_width .. ":-2",
    out,
  }
end

local function pdf_cmd(path, out)
  -- -singlefile makes pdftoppm write exactly <prefix>.png
  return {
    "pdftoppm", "-png", "-singlefile",
    "-f", "1", "-l", "1",
    "-scale-to-x", tostring(preview.opts.thumb_width),
    "-scale-to-y", "-1",
    path, (out:gsub("%.png$", "")),
  }
end

--- Produce a thumbnail for `path`, reusing a cached one when possible.
--- Calls done(thumbnail_path_or_nil).
local function ensure_thumb(path, kind, done)
  local out = thumb_path(path)
  if not out then
    return done(nil)
  end
  if uv.fs_stat(out) then
    return done(out)
  end

  vim.fn.mkdir(preview.opts.cache_dir, "p")

  if kind == "pdf" then
    return spawn(pdf_cmd(path, out), function(ok)
      done(ok and out or nil)
    end)
  end

  spawn(video_cmd(path, out, preview.opts.video_seek), function(ok)
    if ok then
      return done(out)
    end
    -- clip shorter than the seek point: take the very first frame instead
    spawn(video_cmd(path, out, "00:00:00"), function(ok2)
      done(ok2 and out or nil)
    end)
  end)
end

---------------------------------------------------------------------------
-- geometry
---------------------------------------------------------------------------

function preview.clear()
  -- bumping seq invalidates any render still in flight
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

--- Terminal cell size in pixels, as image.nvim measured it.
local function cell_size()
  local ok, term = pcall(require, "image.utils.term")
  if not ok or type(term.get_size) ~= "function" then
    return nil
  end
  local size = term.get_size()
  if not size or not size.cell_width or not size.cell_height then
    return nil
  end
  if size.cell_width <= 0 or size.cell_height <= 0 then
    return nil
  end
  return size
end

--- Shrink the preview rectangle down to the image's natural size, so a 64x64
--- icon is drawn 64x64 instead of being stretched across the whole column.
--- Anything bigger than the column is left alone and gets scaled down to fit.
function preview.fit(img, rect)
  local geom = { x = rect.x, y = rect.y, width = rect.width, height = rect.height }
  if preview.opts.upscale then
    return geom
  end

  local size = cell_size()
  local pw, ph = img.image_width, img.image_height
  if not size or not pw or not ph then
    return geom
  end

  geom.width = math.min(geom.width, math.ceil(pw / size.cell_width))
  geom.height = math.min(geom.height, math.ceil(ph / size.cell_height))

  if preview.opts.center then
    geom.x = rect.x + math.floor((rect.width - geom.width) / 2)
    geom.y = rect.y + math.floor((rect.height - geom.height) / 2)
  end

  return geom
end

---------------------------------------------------------------------------
-- rendering
---------------------------------------------------------------------------

local function render(src, seq)
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

  -- No `window` key on purpose: these are absolute screen coordinates, so the
  -- image isn't clipped to (or hidden by) the terminal buffer under it.
  local made, img = pcall(api.from_file, src, rect)
  if not made or not img then
    return
  end

  local geom = preview.fit(img, rect)
  pcall(function()
    img:render(geom)
  end)

  if seq ~= state.seq then
    pcall(function()
      img:clear()
    end)
    return
  end
  state.img = img
end

function preview.show(path)
  preview.clear()
  state.path = path

  local kind = kind_of(path)
  if not kind then
    return
  end

  local seq = state.seq
  vim.defer_fn(function()
    if seq ~= state.seq or not state.buf then
      return
    end

    if kind == "image" then
      render(path, seq)
    else
      ensure_thumb(path, kind, function(thumb)
        if thumb then
          render(thumb, seq)
        end
      end)
    end
  end, preview.opts.debounce_ms)
end

---------------------------------------------------------------------------
-- wiring
---------------------------------------------------------------------------

--- Called with yazi's terminal buffer each time yazi opens.
function preview.attach(buf)
  state.buf = buf
  state.path = nil
  preview.clear()

  local group = vim.api.nvim_create_augroup("YaziPreviewBuffer", { clear = true })

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
    group = vim.api.nvim_create_augroup("YaziPreview", { clear = true }),
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
      kind = state.path and kind_of(state.path) or nil,
      thumb = state.path and thumb_path(state.path) or nil,
      rect = preview.rect(),
      cell = cell_size(),
      has_image_nvim = pcall(require, "image"),
    }))
  end, { desc = "Inspect the yazi.nvim preview bridge" })
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
