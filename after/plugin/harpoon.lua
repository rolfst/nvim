local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<space>ea", mark.add_file, { desc = "Att harpoon marker" })
vim.keymap.set("n", "<space>e", ui.toggle_quick_menu, { desc = "Toggle harpoon listing" })

vim.keymap.set("n", "<space>en", function()
    ui.nav_next()
end, { desc = "harpoon next" })
vim.keymap.set("n", "<space>ep", function()
    ui.nav_prev()
end, { desc = "harpoon previous" })
