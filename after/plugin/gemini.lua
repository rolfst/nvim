local status_ok, gemini = pcall(require, "gemini-autocomplete")
if not status_ok then
    print("gemini not found!")
    return
end

gemini.setup({
    general = {
        make_statusline = require("gemini-autocomplete.external").make_mini_statusline,
    },
    model = {
        model_id = require("gemini-autocomplete.api").MODELS.GEMINI_2_5_PRO,
    },
    -- I like to have it disabled on startup and manually activate when needed (free tier user, quota matters)
    completion = { enabled = false },
})

require("gemini-autocomplete.external").make_mini_statusline() -- show gemini in statusline and indicate (en/dis)abled
vim.keymap.set(
    "n",
    "<leader>at",
    gemini.toggle_enabled,
    { desc = "[A]i [T]oggle Autocompletion" }
)
vim.keymap.set(
    "n",
    "<leader>ag",
    gemini.add_gitfiles,
    { desc = "[A]i add [G]itfiles" }
)
vim.keymap.set(
    "n",
    "<leader>ae",
    gemini.edit_context,
    { desc = "[A]i [E]dit Context" }
)
vim.keymap.set(
    "n",
    "<leader>ap",
    gemini.prompt_code,
    { desc = "[A]i [P]rompt Code" }
)
vim.keymap.set(
    "n",
    "<leader>aw",
    gemini.clear_context,
    { desc = "[A]i [w]ipe [C]ontext" }
)
vim.keymap.set(
    "n",
    "<leader>am",
    gemini.choose_model,
    { desc = "[A]i Choose [M]odel" }
)
