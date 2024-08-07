require("trouble").setup({
    position = "bottom", -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    -- icons = true, -- use devicons for filenames
    mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    action_keys = {
        -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q",                   -- close the list
        cancel = "<esc>",              -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r",                 -- manually refresh
        jump = { "<cr>", "<tab>" },    -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" },      -- open buffer in new split
        open_vsplit = { "<c-v>" },     -- open buffer in new vsplit
        open_tab = { "<c-t>" },        -- open buffer in new tab
        jump_close = { "o" },          -- jump to the diagnostic and close the list
        toggle_mode = "m",             -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P",          -- toggle auto_preview
        hover = "H",                   -- opens a small popup with the full multiline message
        preview = "p",                 -- preview the diagnostic location
        close_folds = { "zM", "zm" },  -- close all folds
        open_folds = { "zR", "zr" },   -- open all folds
        toggle_fold = { "zA", "za" },  -- toggle fold of current file
        previous = "k",                -- previous item
        next = "j",                    -- next item
    },
    indent_lines = true,               -- add an indent guide below the fold icons
    auto_open = false,                 -- automatically open the list when you have diagnostics
    auto_close = false,                -- automatically close the list when you have no diagnostics
    auto_preview = true,               -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false,                 -- automatically fold a file trouble list at creation
    auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠",
    },
    use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
})

local funcs = require("rolfst.funcs")

local opts = { buffer = bufnr, remap = false }
local describe = funcs.describe(opts)

vim.keymap.set("n", "<leader>d", function()
    vim.cmd("Trouble")
end, describe("Trouble toggle"))
vim.keymap.set(
    "n",
    "<leader>dd",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    describe("document diagnostic")
)
vim.keymap.set(
    "n",
    "<leader>dq",
    "<cmd>Trouble quickfix toggle<cr>",
    describe("Trouble quickfix")
)
vim.keymap.set(
    "n",
    "<leader>dl",
    "<cmd>Trouble loclist toggle<cr>",
    describe("Trouble loclist")
)
vim.keymap.set(
    "n",
    "<leader>gr",
    "<cmd>Trouble lsp_references toggl <cr>",
    describe("References")
)
vim.keymap.set(
    "n",
    "<leader>dt",
    "<cmd>TodoTrouble<cr>",
    { desc = "Todo list" }
)
vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
end, { desc = "next todo item" })
vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "previous todo item" })
