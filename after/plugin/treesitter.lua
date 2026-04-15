local languages = {
    "vimdoc",
    "typescript",
    "lua",
    "rust",
    "python",
    "javascript",
    "haskell",
    "markdown",
}

local installed = require("nvim-treesitter.config").get_installed()
local missing = vim.tbl_filter(function(lang)
    return not vim.tbl_contains(installed, lang)
end, languages)

if #missing > 0 then
    require("nvim-treesitter.install").install(missing)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = languages,
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
