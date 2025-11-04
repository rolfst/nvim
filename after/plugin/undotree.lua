local status_ok, atone = pcall(require, "atone")
if not status_ok then
    return
end
atone.setup()
vim.keymap.set(
    "n",
    "<leader>u",
    "<cmd>Atone toggle<cr>",
    { desc = "Undo tree toggle" }
)
