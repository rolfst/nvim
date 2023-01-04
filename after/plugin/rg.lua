local rg_status_ok, rg = pcall(require, "rg")
if not rg_status_ok then
    return
end
rg.setup({
    default_keybindings = {
        enable = true,
        modes = { "v" },
        binding = "tr",
    },
})
