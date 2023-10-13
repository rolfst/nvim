vim.g.mapleader = " "
vim.keymap.set("n", "<S-x>", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", '"_dP')

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to clipboard" })

vim.keymap.set("n", "<leader>D", '"_d', { desc = "Permanently delete" })
vim.keymap.set("v", "<leader>D", '"_d', { desc = "Permanently delete" })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tsession<CR>")

vim.keymap.set(
    "n",
    "<C-k>",
    "<cmd>cnext<CR>zz",
    { desc = "Previous in quicklist" }
)
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Next in quicklist" })
vim.keymap.set(
    "n",
    "<leader>k",
    "<cmd>lnext<CR>zz",
    { desc = "Previous in Loclist" }
)
vim.keymap.set(
    "n",
    "<leader>j",
    "<cmd>lprev<CR>zz",
    { desc = "Next in Loclist" }
)

vim.keymap.set(
    "n",
    "<C-s>",
    ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>"
)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
