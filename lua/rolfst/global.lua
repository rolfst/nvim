local funcs = require("rolfst.funcs")
local home = os.getenv("HOME")
local os_name = vim.loop.os_uname().sysname

local global = {}

local os
if os_name == "Darwin" then
    os = "mac"
elseif os_name == "Linux" then
    os = "linux"
elseif os_name == "Windows" then
    os = "unsuported"
else
    os = "other"
end

function global:load_variables()
    self.os = os
    self.nvim_path = home .. "/.config/nvim"
    self.cache_path = home .. "/.cache/nvim"
    self.plugin_path = home .. "/.local/share/nvim/lazy"
    self.snapshot_path = home .. "/.config/nvim/.snapshots"
    self.modules_path = home .. "/.config/nvim/lua/rolfst/modules"
    self.snippets_path = home .. "/.config/nvim/snippets"
    self.global_config = home .. "/.config/nvim/lua/config/global"
    self.custom_config = home .. "/.config/nvim/lua/config/custom"
    self.languages = {}
    self.home = home
    self.mason_path = home .. "/.local/share/nvim/mason"
    self.bin_path = "/run/current-system/sw/bin"
end

global:load_variables()

return global
