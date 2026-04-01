local icons = require("rolfst.icons")
local symbols_outline_status_ok, symbols_outline = pcall(require, "symbols-outline")
if not symbols_outline_status_ok then
    return
end
symbols_outline.setup({
    symbols = icons.outline,
    highlight_hovered_item = true,
    show_guides = true,
})
vim.keymap.set("n", "<A-v>", function()
    vim.cmd("SymbolsOutline")
end, { noremap = true, silent = true, desc = "SymbolsOutline" })
