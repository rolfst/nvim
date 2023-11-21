local other_status_ok, other = pcall(require, "other-nvim")
if not other_status_ok then
    return
end

other.setup({
    mappings = {
        "angular",
        {
            pattern = "/src/main/java/(.*)/(.*).java$",
            target = "/src/test/java/%1/%2Test.java",
            context = "test",
        },
        {
            pattern = "/src/main/java/(.*)/(.*).java$",
            target = "/src/test/java/%1/%2Tests.java",
            context = "test",
        },
        {
            pattern = "/src/(.*)/(.*).py$",
            target = "/test/%1/%2.test.py",
            context = "test",
        },
    },
})

vim.keymap.set(
    "n",
    "<leader>ll",
    "<cmd>:Other<cr>",
    { desc = "open other files" }
)
vim.keymap.set(
    "n",
    "<leader>lv",
    "<cmd>:OtherVSplit<cr>",
    { desc = "open other files in other split" }
)
vim.keymap.set(
    "n",
    "<leader>lc",
    "<cmd>:OtherClear<cr>",
    { desc = "open other files in other split" }
)

vim.keymap.set(
    "n",
    "<leader>lt",
    "<cmd>:Other test<cr>",
    { desc = "open other testfile in other split" }
)
