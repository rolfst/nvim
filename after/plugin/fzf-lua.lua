local status_ok, fzf_lua = pcall(require, "fzf-lua")
if not status_ok then
    return false
end

local actions = require("fzf-lua.actions")
fzf_lua.setup({
    winopts = {
        height = 0.90,
        width = 0.65,
        row = 0.30,
        col = 0.70,
        hl = {
            border = "FloatBorder",
        },
        preview = {
            default = "head",
            vertical = "down:60%",
            layout = "vertical",
            scrollbar = "float",
        },
    },
    actions = {
        files = {
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-h"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-l"] = actions.file_sel_to_ll,
        },
        buffers = {
            ["default"] = actions.buf_edit,
            ["ctrl-h"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
        },
    },
    keymap = {
        builtin = {
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            ["<F10>"] = "toggle-preview",
            ["<F11>"] = "toggle-preview-ccw",
            ["<ctrl-d>"] = "preview-page-down",
            ["<ctrl-u>"] = "preview-page-up",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
        },
    },
    files = {
        prompt = "Files  > ",
        git_icons = false,
        cmd = table.concat({
            "find .",
            "-type f",
            '-not -path "*node_modules*"',
            '-not -path "*/.venv/*"',
            '-not -path "*/.git/*"',
            '-printf "%P\n"',
        }, " "),
    },
    git = {
        files = {
            prompt = " git  > ",
        },
        status = {
            prompt = "GitStatus  > ",
        },
        commits = {
            prompt = "Commits  > ",
        },
        bcommits = {
            prompt = "BufferCommits  > ",
        },
        branches = {
            prompt = "Branches  > ",
        },
    },
    grep = {
        prompt = "Search  > ",
        input_prompt = "Search  > ",
        -- git_icons = false,
        -- cmd = "rg --vimgrep",
        -- cmd = "git grep --line-number --column -I --ignore-case",
    },
    args = {
        prompt = "Args  > ",
    },
    buffers = {
        prompt = "Buffers  > ",
        sort_lastused = true,
        actions = {
            ["ctrl-x"] = { actions.buf_del, actions.resume },
        },
    },
    blines = {
        prompt = "BufferLines  > ",
    },
    colorschemes = {
        prompt = "Colorschemes  > ",
    },
    lsp = {
        prompt = "  > ",
    },
    helptags = { previewer = { _ctor = false } },
    manpages = { previewer = { _ctor = false } },
    previewers = {
        builtin = {
            extensions = {
                ["png"] = { "chafa" },
                ["jpg"] = { "chafa" },
                ["svg"] = { "chafa" },
            },
        },
    },
    previewer = {
        chafa = {
            cmd = "chafa",
            args = "",
            _new = function()
                return require("fzf_lua.previewer").cmd_async
            end,
        },
    },
})
local function media_files()
    fzf_lua.files({
        cwd = "./",
        fd_opt = ". -e png -e jpg, -e svg",
        prompt = "Media  > ",
    })
end

local status_tele_ok, telescope = pcall(require, "telescope")
if not status_tele_ok then
    return
end
telescope.setup()
-- telescope.setup({
--     defaults = {
--         prompt_prefix = "   ",
--         selection_caret = "  ",
--         entry_prefix = "  ",
--         initial_mode = "insert",
--         selection_strategy = "reset",
--         sorting_strategy = "ascending",
--         layout_strategy = "vertical",
--         layout_config = {
--             horizontal = {
--                 prompt_position = "top",
--                 preview_width = 0.5,
--                 results_width = 0.5,
--             },
--             vertical = {
--                 prompt_position = "top",
--                 preview_width = 0.5,
--                 results_width = 0.5,
--                 mirror = false,
--             },
--             width = 0.95,
--             height = 0.95,
--             preview_cutoff = 120,
--         },
--         vimgrep_arguments = {
--             "rg",
--             "--color=never",
--             "--no-heading",
--             "--with-filename",
--             "--line-number",
--             "--column",
--             "--smart-case",
--             "--hidden",
--         },
--         file_sorter = require("telescope.sorters").get_fuzzy_file,
--         file_ignore_patterns = {
--             "node_modules",
--             ".git",
--             "target",
--             "vendor",
--         },
--         generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
--         path_display = { shorten = 5 },
--         winblend = 0,
--         border = {},
--         borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
--         color_devicons = true,
--         set_env = { ["COLORTERM"] = "truecolor" },
--         file_previewer = require("telescope.previewers").vim_buffer_cat.new,
--         grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
--         qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
--         buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
--     },
--     preview = {
--         check_mime_type = false,
--     },
--     pickers = {
--         file_browser = {
--             hidden = true,
--         },
--         find_files = {
--             hidden = true,
--         },
--         live_grep = {
--             hidden = true,
--             only_sort_text = true,
--         },
--     },
--     extensions = {
--         fzf = {
--             fuzzy = true,
--             override_generic_sorter = false,
--             override_file_sorter = true,
--             case_mode = "smart_case",
--         },
--         file_browser = {},
--         media_files = {
--             find_cmd = "rg",
--         },
--     },
-- })

telescope.load_extension("manix")
-- telescope.load_extension("file_browser")
-- telescope.load_extension("tmux")
-- telescope.load_extension("media_files")
--
-- local tele_b = require("telescope.builtin")
vim.keymap.set("n", "<space>tf", function()
    fzf_lua.files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<space>to", function()
    fzf_lua.oldfiles()
end, { desc = "Find recent files" })
vim.keymap.set("n", "<space>tt", function()
    fzf_lua.tmux_buffers()
end, { desc = "List tmux buffers" })
vim.keymap.set("n", "<space>tw", function()
    fzf_lua.live_grep()
end, { desc = "Search word" })
vim.keymap.set("n", "<space>tg", function()
    fzf_lua.git_files()
end, { desc = "Find git files" })
vim.keymap.set("n", "<space>tgs", function()
    fzf_lua.git_status()
end, { desc = "Find git status" })
vim.keymap.set("n", "<space>tgb", function()
    fzf_lua.git_branches()
end, { desc = "Find git branches" })
vim.keymap.set("n", "<space>tgv", function()
    fzf_lua.git_stash()
end, { desc = "Find git stash" })
vim.keymap.set("n", "<space>tk", function()
    fzf_lua.keymaps()
end, { desc = "Find keymaps" })
vim.keymap.set("n", "<space>tb", function()
    fzf_lua.buffers()
end, { desc = "Show buffers" })
vim.keymap.set("n", "<space>tp", function()
    fzf_lua.grep_cword()
end, { desc = "search word under cursor" })
vim.keymap.set("n", "<space>tm", function()
    fzf_lua.marks()
end, { desc = "search marks" })
vim.keymap.set("n", "<space>tmn", function()
    fzf_lua.menu()
end, { desc = "search menu" })
vim.keymap.set("n", "<space>tc", function()
    fzf_lua.commands()
end, { desc = "search commands" })
vim.keymap.set("n", "<space>tcl", function()
    fzf_lua.colorschemes()
end, { desc = "search color schemes" })
vim.keymap.set("n", "<space>tj", function()
    fzf_lua.jumps()
end, { desc = "search jumps" })
vim.keymap.set("n", "<space>tmf", function()
    media_files()
end, { desc = "search jumps" })
vim.keymap.set(
    "n",
    "<leader>ts",
    "<cmd>Telescope symbols<cr>",
    { desc = "search symbols" }
)
vim.keymap.set(
    "i",
    "<C-t>s",
    "<cmd>Telescope symbols<cr>",
    { desc = "search symbols" }
)
