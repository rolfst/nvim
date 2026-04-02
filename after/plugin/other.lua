local other_status_ok, other = pcall(require, "other-nvim")
if not other_status_ok then
    return
end

other.setup({
    mappings = {
        {
            pattern = "/src/main/java/(.*).java$",
            target = "/src/test/java/%1Test.java",
            context = "test",
        },
        {
            pattern = "/src/test/java/(.*)Test.java$",
            target = "/src/main/java/%1.java",
            context = "implementation",
        },
        {
            pattern = "/src/main/java/(.*).java$",
            target = "/src/test/java/%1Tests.java",
            context = "tests",
        },
        {
            pattern = "/src/(.*).py$",
            target = "/test/%1.test.py",
            context = "test",
        },
        {
            pattern = "/src/(.*).ts$",
            target = {
                {
                    target = "/src/%1.component.scss",
                    context = "scss",
                },
                {
                    target = "/src/%1.component.html",
                    context = "view",
                },
                {
                    target = "/test/%1.spec.ts",
                    context = "spec",
                },
                {
                    target = "/test/%1.component.spec.ts",
                    context = "component-spec",
                },
                {
                    target = "/test/%1.test.ts",
                    context = "test",
                },
            },
        },
        {
            pattern = "/test/(.*).test.ts$",
            target = {
                {
                    target = "/src/%1.ts",
                    context = "implementation",
                },
            },
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
