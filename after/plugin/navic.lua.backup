local icons = require("rolfst.icons")
local nvim_navic_status_ok, nvim_navic = pcall(require, "nvim-navic")
if not nvim_navic_status_ok then
    return
end
nvim_navic.setup({
    icons = icons.lsp,
    highlight = true,
    separator = " ➤ ",
})
vim.g.navic_silence = true
