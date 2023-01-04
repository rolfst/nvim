local tabby_status_ok, tabby = pcall(require, "tabby")
if not tabby_status_ok then
    return
end
local tabby_util_status_ok, tabby_util = pcall(require, "tabby.util")
if not tabby_util_status_ok then
    return
end
local tabby_filename_status_ok, tabby_filename = pcall(require, "tabby.filename")
if not tabby_filename_status_ok then
    return
end
local theme = _G.LVIM_SETTINGS.colorschemes.theme
local hl_tabline = {
    color_01 = _G.LVIM_SETTINGS.colorschemes.colors[theme].bg_01,
    color_02 = _G.LVIM_SETTINGS.colorschemes.colors[theme].bg_03,
    color_03 = _G.LVIM_SETTINGS.colorschemes.colors[theme].green_01,
    color_04 = _G.LVIM_SETTINGS.colorschemes.colors[theme].green_02,
}
local get_tab_label = function(tab_number)
    local s, v = pcall(function()
        return vim.api.nvim_eval("ctrlspace#util#Gettabvar(" .. tab_number .. ", 'CtrlSpaceLabel')")
    end)
    if s then
        if v == "" then
            return tab_number
        else
            return tab_number .. ": " .. v
        end
    else
        return tab_number .. ": " .. v
    end
end
local components = function()
    local exclude = {
        "ctrlspace",
        "ctrlspace_help",
        "packer",
        "undotree",
        "diff",
        "Outline",
        "LvimHelper",
        "floaterm",
        "toggleterm",
        "dashboard",
        "vista",
        "spectre_panel",
        "DiffviewFiles",
        "flutterToolsOutline",
        "log",
        "qf",
        "dapui_scopes",
        "dapui_breakpoints",
        "dapui_stacks",
        "dapui_watches",
        "calendar",
        "octo",
        "neo-tree",
        "neo-tree-popup",
    }
    local comps = {
        {
            type = "text",
            text = {
                "    ",
                hl = {
                    bg = hl_tabline.color_04,
                    fg = hl_tabline.color_01,
                    style = "bold",
                },
            },
        },
    }
    local tabs = vim.api.nvim_list_tabpages()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local name_of_buf
    local wins = tabby_util.tabpage_list_wins(current_tab)
    local top_win = vim.api.nvim_tabpage_get_win(current_tab)
    local hl
    local win_name
    for _, win_id in ipairs(wins) do
        local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win_id), "filetype")
        win_name = tabby_filename.unique(win_id)
        if not vim.tbl_contains(exclude, ft) then
            if win_id == top_win then
                hl = { bg = hl_tabline.color_03, fg = hl_tabline.color_02, style = "bold" }
            else
                hl = { bg = hl_tabline.color_02, fg = hl_tabline.color_03, style = "bold" }
            end
            table.insert(comps, {
                type = "win",
                winid = win_id,
                label = {
                    "  " .. win_name .. "  ",
                    hl = hl,
                },
                right_sep = { "", hl = { bg = hl_tabline.color_01, fg = hl_tabline.color_01 } },
            })
        end
    end
    table.insert(comps, {
        type = "text",
        text = { "%=" },
        hl = { bg = hl_tabline.color_01, fg = hl_tabline.color_01 },
    })
    for _, tab_id in ipairs(tabs) do
        local tab_number = vim.api.nvim_tabpage_get_number(tab_id)
        name_of_buf = get_tab_label(tab_number)
        if tab_id == current_tab then
            hl = { bg = hl_tabline.color_03, fg = hl_tabline.color_02, style = "bold" }
        else
            hl = { bg = hl_tabline.color_02, fg = hl_tabline.color_03, style = "bold" }
        end
        table.insert(comps, {
            type = "tab",
            tabid = tab_id,
            label = {
                "  " .. name_of_buf .. "  ",
                hl = hl,
            },
        })
    end
    return comps
end
tabby.setup({
    components = components,
})
