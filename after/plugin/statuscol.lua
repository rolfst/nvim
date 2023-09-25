local statuscol_nvim_status_ok, statuscol_nvim = pcall(require, "statuscol")
if not statuscol_nvim_status_ok then
    return
end
statuscol_nvim.setup({
    separator = " ",
    setopt = true,
    segment = "SNsFs",
})

-- vim.o.statuscolumn = [[%@v:lua.ScFa@%C%T%@v:lua.ScSa@%s%T@v:lua.ScLa@%=%l%T]]
