local glance = require("glance")
local actions = glance.actions
glance.setup({
    zindex = 20,
    border = {
        enable = true,
        top_char = " ",
        bottom_char = " ",
    },
    list = {
        width = 0.4,
    },
    theme = {
        enable = false,
    },
    indent_lines = {
        enable = true,
        icon = "▏",
    },
    mappings = {
        list = {
            ["j"] = actions.next,
            ["k"] = actions.previous,
            ["<Tab>"] = actions.next_location,
            ["<S-Tab>"] = actions.previous_location,
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["v"] = actions.jump_vsplit,
            ["s"] = actions.jump_split,
            ["t"] = actions.jump_tab,
            ["<CR>"] = actions.jump,
            ["o"] = actions.jump,
            ["<C-h>"] = actions.enter_win("preview"), -- Focus preview window
            ["<Esc>"] = actions.close,
            ["q"] = actions.close,
        },
        preview = {
            ["q"] = actions.close,
            ["<Tab>"] = actions.next_location,
            ["<S-Tab>"] = actions.previous_location,
            ["<C-l>"] = actions.enter_win("list"), -- Focus list window
        },
    },
    hooks = {
        before_open = function(results, open, jump, _)
            local uri = vim.uri_from_bufnr(0)
            if #results == 1 then
                local target_uri = results[1].uri or results[1].targetUri
                if target_uri == uri then
                    jump(results[1])
                else
                    open(results)
                end
            else
                open(results)
            end
        end,
    },
})
vim.keymap.set("n", "gpd", "<Cmd>Glance definitions<CR>")
vim.keymap.set("n", "gpr", "<Cmd>Glance references<CR>")
vim.keymap.set("n", "gpt", "<Cmd>Glance type_definitions<CR>")
vim.keymap.set("n", "gpi", "<Cmd>Glance implementations<CR>")
