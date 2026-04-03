vim.cmd("packadd nvim.undotree")

vim.keymap.set(
    "n",
    "<leader>u",
    "<cmd>Undotree<cr>",
    { desc = "Undo tree toggle" }
)
