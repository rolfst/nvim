local nvim_autopairs_status_ok, nvim_autopairs = pcall(require, "nvim-autopairs")
if not nvim_autopairs_status_ok then
    return
end
nvim_autopairs.setup({
    check_ts = true,
    ts_config = {
        lua = {
            "string",
        },
        javascript = {
            "template_string",
        },
        java = false,
    },
})
