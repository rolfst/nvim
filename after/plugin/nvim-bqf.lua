local bqf_status_ok, bqf = pcall(require, "bqf")
-- if not bqf_status_ok then
--     return
-- end
-- bqf.setup({
--     preview = {
--         border_chars = {
--             "│",
--             "│",
--             "─",
--             "─",
--             "┌",
--             "┐",
--             "└",
--             "┘",
--             "█",
--         },
--     },
-- })
local status_ok, quicker = pcall(require, "quicker")
if not status_ok then
    return
end
quicker.setup()
vim.keymap.set("n", "<leader>q", function()
    quicker.toggle()
end, {
    desc = "Toggle quickfix",
})
vim.keymap.set("n", "<leader>l", function()
    quicker.toggle({ loclist = true })
end, {
    desc = "Toggle loclist",
})
