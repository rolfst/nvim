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

map("n", "<leader>dft", function()
    local left = vim.fn.input("Left path: ", vim.fn.getcwd() .. "/", "file")
    if left == "" then
        return
    end
    local right = vim.fn.input("Right path: ", vim.fn.getcwd() .. "/", "file")
    if right == "" then
        return
    end
    vim.cmd(
        "DiffTool "
        .. vim.fn.fnameescape(left)
        .. " "
        .. vim.fn.fnameescape(right)
    )
end, "Dif tool: compare paths")

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
