local structural = require("config.folds.folds")

vim.keymap.set("n", "zm", structural.fold_direct_children, {
	noremap = true,
	desc = "Fold direct children (structural)",
})
