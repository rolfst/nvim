local languages = {
    "c",
    "vimdoc",
    "typescript",
    "lua",
    "rust",
    "python",
    "javascript",
    "haskell",
}

require("nvim-treesitter").install(languages)

vim.api.nvim_create_autocmd("FileType", {
    pattern = languages,
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
