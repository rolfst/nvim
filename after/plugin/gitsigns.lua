local gitsigns_status_ok, gitsigns = pcall(require, "gitsigns")
if not gitsigns_status_ok then
    return
end
gitsigns.setup({
    numhl = true,
    signcolumn = true,
    signs = {
        add = {
            hl = "GitSignsAdd",
            text = " ▎",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn",
        },
        change = {
            hl = "GitSignsChange",
            text = " ▎",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
        },
        delete = {
            hl = "GitSignsDelete",
            text = " ▎",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
        },
        topdelete = {
            hl = "GitSignsDelete",
            text = " ▎",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
        },
        changedelete = {
            hl = "GitSignsChange",
            text = " ▎",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
        },
    },
    linehl = false,
})

vim.api.nvim_create_user_command("GitSignsPreviewHunk", "lua require('gitsigns').preview_hunk()", {})
vim.api.nvim_create_user_command("GitSignsNextHunk", "lua require('gitsigns').next_hunk()", {})
vim.api.nvim_create_user_command("GitSignsPrevHunk", "lua require('gitsigns').prev_hunk()", {})
vim.api.nvim_create_user_command("GitSignsStageHunk", "lua require('gitsigns').stage_hunk()", {})
vim.api.nvim_create_user_command("GitSignsUndoStageHunk", "lua require('gitsigns').undo_stage_hunk()", {})
vim.api.nvim_create_user_command("GitSignsResetHunk", "lua require('gitsigns').reset_hunk()", {})
vim.api.nvim_create_user_command("GitSignsResetBuffer", "lua require('gitsigns').reset_buffer()", {})
vim.api.nvim_create_user_command("GitSignsBlameLine", "lua require('gitsigns').blame_line()", {})
vim.keymap.set("n", "<A-]>", function()
    vim.cmd("GitSignsNextHunk")
end, { noremap = true, silent = true, desc = "Git Next Hunk" })
vim.keymap.set("n", "<A-[>", function()
    vim.cmd("GitSignsPrevHunk")
end, { noremap = true, silent = true, desc = "Git Previous Hunk" })
vim.keymap.set("n", "<A-;>", function()
    vim.cmd("GitSignsPreviewHunk")
end, { noremap = true, silent = true, desc = "Git Preview Hunk" })
vim.keymap.set("n", "<space>gsa", function()
    vim.cmd("GitSignsStageHunk")
end, { noremap = true, silent = true, desc = "Git stage hunk" })
vim.keymap.set("n", "<space>gsr", function()
    vim.cmd("GitSignsResetBuffer")
end, { noremap = true, silent = true, desc = "Git reset buffer" })
vim.keymap.set("n", "<space>gsb", function()
    vim.cmd("GitSignsBlameLine")
end, { noremap = true, silent = true, desc = "Git blame line" })
