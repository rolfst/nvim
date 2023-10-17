local oil_status_ok, oil = pcall(require, "oil")
if not oil_status_ok then
    return
end
oil.setup({})
vim.keymap.set(
    "n",
    "-",
    "<CMD>Oil --float<CR>",
    { noremap = true, desc = "file browser", silent = true }
)
