local M = {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor.
    set({"n"}, "k", function() mc.lineAddCursor(-1) end)
    set({"n"}, "j", function() mc.lineAddCursor(1) end)
    set({"n"}, "<leader>k", function() mc.lineSkipCursor(-1) end)
    set({"n"}, "<leader>j", function() mc.lineSkipCursor(1) end)

    set("x", "<leader>M", mc.matchCursors)
    set("x", "<leader>S", mc.splitCursors)
    set({"n", "x"}, "<leader><c-q>", mc.duplicateCursors)
    -- Add or skip adding a new cursor by matching word/selection
    set({"n", "x"}, "<leader>n", function() mc.searchAddCursor(1) end)
    set({"n", "x"}, "<leader>N", function() mc.searchAddCursor(-1) end)
    set({"n", "x"}, "<leader>A", mc.searchAllAddCursors)

    set("n", "<leader>a", mc.alignCursors)

    -- Rotate the text contained in each visual selection between cursors.
    set("x", "t", function() mc.transposeCursors(1) end)
    set("x", "<leader>T", function() mc.transposeCursors(-1) end)

    -- Append/insert for each line of visual selections.
    -- Similar to block selection insertion.
    set("x", "I", mc.insertVisual)
    set("x", "A", mc.appendVisual)

    -- Disable and enable cursors.
    set({"n", "x"}, "<c-q>", mc.toggleCursor)

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)

      -- Select a different cursor as the main one.
      layerSet({"n", "x"}, "h", mc.prevCursor)
      layerSet({"n", "x"}, "l", mc.nextCursor)

      -- Delete the main cursor.
      layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

      -- Enable and clear cursors using escape.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn"})
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
  end
}

return M
