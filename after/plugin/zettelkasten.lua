local status_ok, zettelkasten = pcall(require, "telekasten")
if not status_ok then
    return
end
local home = vim.fn.expand("~/notes")
zettelkasten.setup({
    home = home,
    filename_space_subst = "_",
    command_palette_theme = "window",
    show_tags_theme = "window",
    media_previewer = "viu-previewer",
    dailies = home .. "/" .. "dailies",
    weeklies = home .. "/" .. "weeklies",
    templates = home .. "/" .. "templates", -- path to templates
    template_new_note = home .. "/templates/new_note.md",
    template_new_daily = home .. "/templates/daily.md",
    template_new_weekly = home .. "/templates/weekly.md",
})
-- Launch panel if nothing is typed after <leader>z
vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>", { desc = "zettelkasten" })

-- Most used functions
vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>", { desc = "find notes" })
vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>", { desc = "search notes" })
vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>", { desc = "go to todays note" })
vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>", { desc = "follow link" })
vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>", { desc = "new note" })
vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>", { desc = "show calendar" })
vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", { desc = "show backlink" })
vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>", { desc = "insert image" })

-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>", { desc = "insert link" })
