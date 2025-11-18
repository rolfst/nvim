local global = require("rolfst.global")

if global == "unsuported" then
    print("Your OS is not supported!")
else
    local funcs = require("rolfst.funcs")
    local vim = vim
    global["diagnostics"] = {}
    global["diagnostics"]["path"] = vim.fn.getcwd()
    global["diagnostics"]["method"] = "global"
    _G.NVIM_SETTINGS =
        funcs.read_file(global.nvim_path .. "/config/config.json")
end
require("rolfst.options")
require("rolfst.remap")
require("rolfst.plugins")
require("rolfst.autocommands")

local status_ok, Snacks = pcall(require, "snacks")
if not status_ok then
    return
end
_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function()
    Snacks.debug.backtrace()
end
if vim.fn.has("nvim-0.11") == 1 then
    vim._print = function(_, ...)
        dd(...)
    end
else
    vim.print = dd
end
