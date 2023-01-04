vim.g.any_jump_disable_default_keybindings = 1
vim.g.any_jump_list_numbers = 1
vim.keymap.set("n", "<A-u>", ":AnyJump<CR>", { noremap = true, silent = true, desc = "AnyJump" })
vim.keymap.set("v", "<A-u>", ":AnyJumpVisual<CR>", { noremap = true, silent = true, desc = "AnyJumpVisual" })
