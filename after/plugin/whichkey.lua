local status_ok, whichkey = pcall(require, "which-key")
if not status_ok then
    return
end

whichkey.add({
    { "<space>c", group = "Calendar" },
    { "<space>g", group = "Git" },
    { "<space>l", group = "Related (test)files" },
    { "<space>n", group = "test" },
    { "<space>s", group = "Snippets" },
    { "<space>t", group = "Find" },
}, { prefix = "<space>" })
