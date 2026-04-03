-- ┌──────────────────────────────────────────┐
-- │        Neovim 0.12 Diff Tooling          │
-- └──────────────────────────────────────────┘

-- ── DiffTool (built-in 0.12 directory diff) ─────────────────────
local ok = pcall(vim.cmd, "packadd nvim.difftool")
if not ok then
    vim.notify(
        "nvim.difftool not available — requires Neovim 0.12+",
        vim.log.levels.WARN
    )
end

-- ── Inline diff mode cycling ────────────────────────────────────
local inline_modes =
{ "inline:word", "inline:char", "inline:simple", "inline:none" }
local current_inline = 1

local function cycle_inline_diff()
    for _, mode in ipairs(inline_modes) do
        vim.opt.diffopt:remove(mode)
    end
    current_inline = (current_inline % #inline_modes) + 1
    local next_mode = inline_modes[current_inline]
    vim.opt.diffopt:append(next_mode)
    vim.notify("Diff inline: " .. next_mode, vim.log.levels.INFO)
end

-- ── Diff against git HEAD ───────────────────────────────────────
local function diff_against_head()
    local filepath = vim.fn.expand("%:p")
    if filepath == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
    end
    local git_content = vim.fn.systemlist(
        "git show HEAD:" .. vim.fn.shellescape(vim.fn.expand("%:."))
    )
    if vim.v.shell_error ~= 0 then
        vim.notify("Not a git-tracked file or git error", vim.log.levels.WARN)
        return
    end
    vim.cmd("vsplit")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, git_content)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = vim.bo.filetype
    local filename = vim.fn.expand("%:t")
    vim.api.nvim_buf_set_name(buf, "HEAD:" .. filename)
    vim.cmd("diffthis")
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
end

-- ── Diff against a specific branch/ref ──────────────────────────
local function diff_against_ref()
    local ref = vim.fn.input("Git ref: ", "main")
    if ref == "" then
        return
    end
    local filepath = vim.fn.expand("%:.")
    if filepath == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
    end
    local git_content = vim.fn.systemlist(
        "git show "
        .. vim.fn.shellescape(ref)
        .. ":"
        .. vim.fn.shellescape(filepath)
    )
    if vim.v.shell_error ~= 0 then
        vim.notify(
            "Cannot read " .. ref .. ":" .. filepath,
            vim.log.levels.WARN
        )
        return
    end
    vim.cmd("vsplit")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, git_content)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = vim.bo.filetype
    local filename = vim.fn.expand("%:t")
    vim.api.nvim_buf_set_name(buf, ref .. ":" .. filename)
    vim.cmd("diffthis")
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
end

-- ── Diff current buffer against clipboard ───────────────────────
local function diff_against_clipboard()
    local clip_content = vim.fn.getreg("+")
    if clip_content == "" then
        vim.notify("Clipboard is empty", vim.log.levels.WARN)
        return
    end
    vim.cmd("vsplit")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(clip_content, "\n"))
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = vim.bo.filetype
    vim.api.nvim_buf_set_name(buf, "[clipboard]")
    vim.cmd("diffthis")
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
end

-- ── Set diff anchors from visual selection ──────────────────────
local function set_anchors_from_selection()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    vim.opt_local.diffanchors = start_line .. "," .. end_line
    vim.notify(
        "Diff anchors set: lines " .. start_line .. "-" .. end_line,
        vim.log.levels.INFO
    )
end

-- ── Quick diffthis/diffoff toggle ───────────────────────────────
local function toggle_diff()
    if vim.wo.diff then
        vim.cmd("diffoff!")
        vim.notify("Diff mode OFF", vim.log.levels.INFO)
    else
        vim.cmd("windo diffthis")
        vim.notify("Diff mode ON for all windows", vim.log.levels.INFO)
    end
end

-- ── Keymaps ─────────────────────────────────────────────────────
-- All under <leader>df prefix

local opts = { noremap = true, silent = true }

local function map(mode, lhs, rhs, desc)
    vim.keymap.set(
        mode,
        lhs,
        rhs,
        vim.tbl_extend("force", opts, { desc = desc })
    )
end

map("n", "<leader>dfm", toggle_diff, "Dif mode toggle")
map(
    "n",
    "<leader>dfi",
    cycle_inline_diff,
    "Dif inline cycle (word/char/simple/none)"
)

map("n", "<leader>dfh", diff_against_head, "Dif against git HEAD")
map("n", "<leader>dfr", diff_against_ref, "Dif against git ref")
map("n", "<leader>dfc", diff_against_clipboard, "Dif against clipboard")

-- ── Snacks picker-based DiffTool path selection ─────────────────
local function pick_difftool_paths()
    local snacks_ok, Snacks = pcall(require, "snacks")
    if not snacks_ok then
        vim.notify("snacks.nvim not available", vim.log.levels.WARN)
        return
    end

    local explorer_confirm = require("snacks.explorer.actions").actions.confirm
    local state = { left = nil, right = nil }

    local function short(path)
        return path and vim.fn.fnamemodify(path, ":~:.") or "…"
    end

    local function refresh_title(picker)
        picker.title = "L: " .. short(state.left) .. "  R: " .. short(state.right)
        picker:update_titles()
    end

    Snacks.picker.explorer({
        title = "L: …  R: …",
        tree = true,
        hidden = true,
        follow_file = false,
        layout = {
            hidden = { "preview" },
            layout = {
                box = "vertical",
                border = true,
                title = "{title}",
                title_pos = "center",
                footer = {
                    { " C-l ", "SnacksPickerInputKey" },
                    { " left ", "SnacksPickerInputBorder" },
                    { " C-r ", "SnacksPickerInputKey" },
                    { " right ", "SnacksPickerInputBorder" },
                    { " S-CR ", "SnacksPickerInputKey" },
                    { " diff ", "SnacksPickerInputBorder" },
                    { " CR ", "SnacksPickerInputKey" },
                    { " expand ", "SnacksPickerInputBorder" },
                },
                footer_pos = "center",
                width = 0.4,
                min_width = 60,
                height = 0.6,
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
            },
        },
        actions = {
            confirm = function(picker, item, action)
                if not item then
                    return
                end
                if item.dir then
                    explorer_confirm(picker, item, action)
                end
            end,
            set_left = function(picker, item)
                if not item or not item.file then
                    return
                end
                state.left = item.file
                refresh_title(picker)
            end,
            set_right = function(picker, item)
                if not item or not item.file then
                    return
                end
                state.right = item.file
                refresh_title(picker)
            end,
            run_diff = function(picker)
                if not state.left or not state.right then
                    vim.notify(
                        "Select both paths first (l=left, r=right)",
                        vim.log.levels.WARN
                    )
                    return
                end
                picker:close()
                vim.schedule(function()
                    vim.cmd(
                        "DiffTool "
                        .. vim.fn.fnameescape(state.left)
                        .. " "
                        .. vim.fn.fnameescape(state.right)
                    )
                end)
            end,
        },
        win = {
            input = {
                keys = {
                    ["<C-l>"] = { "set_left", mode = { "n", "i" }, desc = "set left path" },
                    ["<C-r>"] = { "set_right", mode = { "n", "i" }, desc = "set right path" },
                    ["<CR>"] = { "run_diff", mode = { "n", "i" }, desc = "run DiffTool" },
                },
            },
            list = {
                keys = {
                    ["<C-l>"] = { "set_left", mode = { "n" }, desc = "set left path" },
                    ["<C-r>"] = { "set_right", mode = { "n" }, desc = "set right path" },
                    ["<CR>"] = { "confirm", mode = { "n" }, desc = "expand dir" },
                    ["<S-CR>"] = { "run_diff", mode = { "n" }, desc = "run DiffTool" },
                    ["a"] = false,
                    ["d"] = false,
                    ["r"] = false,
                    ["c"] = false,
                    ["m"] = false,
                    ["o"] = false,
                    ["p"] = false,
                    ["y"] = false,
                    ["u"] = false,
                    ["<c-c>"] = false,
                    ["<c-t>"] = false,
                    ["<leader>/"] = false,
                },
            },
        },
    })
end

map("n", "<leader>dft", pick_difftool_paths, "Dif tool: compare paths")

map(
    "v",
    "<leader>dfa",
    set_anchors_from_selection,
    "Dif anchors set from selection"
)
map("n", "<leader>dfA", function()
    vim.opt_local.diffanchors = ""
    vim.notify("Diff anchors cleared", vim.log.levels.INFO)
end, "Dif anchors clear")

map("n", "]c", "]c", "Next diff hunk")
map("n", "[c", "[c", "Previous diff hunk")

map("n", "<leader>dfp", "<cmd>diffput<CR>", "Dif put")
map("n", "<leader>dfo", "<cmd>diffget<CR>", "Dif obtain (get)")
map("v", "<leader>dfp", ":diffput<CR>", "Dif put selection")
map("v", "<leader>dfo", ":diffget<CR>", "Dif obtain selection")

-- ── User commands ───────────────────────────────────────────────
vim.api.nvim_create_user_command(
    "DiffHead",
    diff_against_head,
    { desc = "Diff current file against git HEAD" }
)
vim.api.nvim_create_user_command(
    "DiffRef",
    diff_against_ref,
    { desc = "Diff current file against a git ref" }
)
vim.api.nvim_create_user_command(
    "DiffClipboard",
    diff_against_clipboard,
    { desc = "Diff current buffer against clipboard" }
)
vim.api.nvim_create_user_command(
    "DiffToggle",
    toggle_diff,
    { desc = "Toggle diff mode for all windows" }
)
vim.api.nvim_create_user_command(
    "DiffInlineCycle",
    cycle_inline_diff,
    { desc = "Cycle inline diff mode" }
)
