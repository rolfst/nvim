local bqf_status_ok, bqf = pcall(require, "bqf")
if not bqf_status_ok then
    return
end
bqf.setup({
    preview = {
        border_chars = { "│", "│", "─", "─", "┌", "┐", "└", "┘", "█" },
    },
})
