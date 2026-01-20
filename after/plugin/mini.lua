local mini_move_ok, mini_move = pcall(require, "mini.move")
if mini_move_ok then
    mini_move.setup()
end
local mini_ai_ok, mini_ai = pcall(require, "mini.ai")
if mini_ai_ok then
    mini_ai.setup()
end
local mini_diff_ok, mini_diff = pcall(require, "mini.diff")
if mini_diff_ok then
    mini_diff.setup({
        -- Disabled by default
        source = mini_diff.gen_source.none(),
    })
end
local mini_session_ok, mini_session = pcall(require, "mini.sessions")
if mini_session_ok then
    mini_session.setup({ autoread = true })
    vim.keymap.set("n", "<leader>ps", function()
        mini_session.write(vim.fn.fnamemodify(vim.loop.cwd(), ":t"))
    end, { desc = "Session save" })
    vim.keymap.set("n", "<leader>pd", function()
        mini_session.delete(nil, { force = true })
    end, { desc = "Session delete" })
end
