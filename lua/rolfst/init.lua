local global = require("rolfst.global")



if global == "unsuported" then
    print("Your OS is not supported!")
else
    local funcs = require("rolfst.funcs")
    local vim = vim
    global["diagnostics"] = {}
    global["diagnostics"]["path"] = vim.fn.getcwd()
    global["diagnostics"]["method"] = "global"
    _G.LVIM_SETTINGS = funcs.read_file(global.nvim_path .. "/config/config.json")
end
require("rolfst.options")
require("rolfst.remap")
require("rolfst.plugins")
require("rolfst.autocommands")
