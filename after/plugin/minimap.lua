local global = require("rolfst.global")
local nm = require("neo-minimap")

nm.setup_defaults({
    -- height_toggle = { 12, 25 },
    height_toggle = { 20, 25 },
    hl_group = "DiagnosticWarn",
})
nm.source_on_save(global.modules_path .. "/neo-minimap/")
