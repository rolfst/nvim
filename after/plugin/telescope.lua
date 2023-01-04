local telescope = require("telescope")
local builtins = require("telescope.builtin")
telescope.load_extension("file_browser")

telescope.setup({
    vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = {
        "node_modules",
        ".git",
        "target",
        "vendor",
    },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { shorten = 5 },
    winblend = 0,
    border = {},
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
})
local function search_current_word()
    local current_word = vim.call('expand', '<cword>')
    builtins.grep_string({ search = current_word });
end

vim.keymap.set("n", "<A-,>", function()
    vim.cmd("Telescope find_files")
end, { noremap = true, silent = true, desc = "Telescope find_files" })
vim.keymap.set("n", "<A-.>", function()
    vim.cmd("Telescope live_grep")
end, { noremap = true, silent = true, desc = "Telescope live_grep" })
vim.keymap.set("n", "<A-/>", function()
    vim.cmd("Telescope file_browser")
end, { noremap = true, silent = true, desc = "Telescope file_browser" })
vim.keymap.set("n", "<A-b>", function()
    vim.cmd("Telescope buffers")
end, { noremap = true, silent = true, desc = "Telescope buffers" })
vim.keymap.set('n', '<space>tf', builtins.find_files, { desc = "Find Files" })
vim.keymap.set('n', '<space>tw', builtins.live_grep, { desc = "Search word" })
vim.keymap.set('n', '<space>tg', builtins.git_files, { desc = "Find git files" })
vim.keymap.set('n', '<space>tk', builtins.keymaps, { desc = "Find keymaps" })
vim.keymap.set('n', '<space>tp', function()
    search_current_word()
end, { desc = "search word under cursor" })
