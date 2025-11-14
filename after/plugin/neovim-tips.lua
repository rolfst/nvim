local status_ok, tips = pcall(require, "neovim-tips")
if not status_ok then
    return
end
local funcs = require("rolfst.funcs")
local global = require("rolfst.global")
tips.setup({
    -- Path to user tips file
    user_file = global.nvim_path .. "/neovim_tips/user_tips.md",

    -- Prefix added to user tip titles to prevent conflicts
    user_tip_prefix = "[User] ",

    -- Show warnings when user tips have conflicting titles with builtin tips
    warn_on_conflicts = true,
})

vim.keymap.set("n", "<leader>nto", ":NeovimTips<CR>", { desc = "Neovim tips" })
vim.keymap.set(
    "n",
    "<leader>ntr",
    ":NeovimTipsRandom<CR>",
    { desc = "Show random tip" }
)
vim.keymap.set(
    "n",
    "<leader>nte",
    ":NeovimTipsEdit<CR>",
    { desc = "Edit your tips" }
)
vim.keymap.set(
    "n",
    "<leader>nta",
    ":NeovimTipsAdd<CR>",
    { desc = "Add your tip" }
)
vim.keymap.set(
    "n",
    "<leader>ntp",
    ":NeovimTipsPdf<CR>",
    { desc = "Open tips PDF" }
)
