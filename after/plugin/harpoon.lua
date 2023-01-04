local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<leader>a', mark.add_file, {desc = "Att harpoon marker"})
vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, {desc = "Toggle harpoon listing"})

vim.keymap.set('n', '<C-e>n', function() ui.nav_next() end)
vim.keymap.set('n', '<C-e>p', function() ui.nav_prev() end)
