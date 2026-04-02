local opencode_status, opencode = pcall(require, "opencode")
if not opencode_status then
    return
end

-- opencode.setup()

vim.o.autoread = true

vim.keymap.set({ "n", "x" }, "<C-a>", function()
    opencode.ask("@this: ", { submit = true })
end, { desc = "Ask opencode..." })
vim.keymap.set({ "n", "x" }, "<C-x>", function()
    opencode.select()
end, { desc = "Execute opencode action" })
vim.keymap.set({ "n", "x" }, "<C-.>", function()
    opencode.toggle()
end, { desc = "Toggle opencode" })

vim.keymap.set({ "n", "x" }, "go", function()
    return opencode.operator("@this ")
end, { desc = "Add range to opencode", expr = true })
vim.keymap.set("n", "goo", function()
    return opencode.operator("@this ") .. "_"
end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<S-C-u>", function()
    opencode.command("session.half.page.up")
end, { desc = "Scroll opencode up" })
vim.keymap.set("n", "<S-C-d>", function()
    opencode.command("session.half.page.down")
end, { desc = "Scroll opencode down" })
