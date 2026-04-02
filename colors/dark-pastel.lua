vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end

vim.g.colors_name = "dark-pastel"
vim.o.termguicolors = true
vim.o.background = "dark"

package.loaded["rolfst.dark-pastel"] = nil
require("rolfst.dark-pastel")
