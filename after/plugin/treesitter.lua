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

local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
    ensure_installed = languages,
    highlight = { enable = true },
    additional_vim_regex_highlighting = false,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = languages,
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
