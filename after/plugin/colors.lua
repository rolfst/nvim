-- local lush = require("lush")
-- local nvim_treeclimber_status_ok, nvim_treeclimber =
--     pcall(require, "nvim-treeclimber")
-- if not nvim_treeclimber_status_ok then
--     return
-- end
-- -- Change if you don't have Lush installed
-- --
-- local theme_colors =
--     _G.NVIM_SETTINGS.colorschemes.colors[_G.NVIM_SETTINGS.colorschemes.theme]
-- local color = require("nvim-treeclimber.hi")
-- -- print(vim.inspect(color))
-- local bg = lush.hsl(theme_colors.bg_01)
-- local fg = lush.hsl(theme_colors.fg_01)
-- local dim = bg.mix(fg, 20)
--
-- vim.api.nvim_set_hl(0, "TreeClimberHighlight", { background = dim.hex })
--
-- vim.api.nvim_set_hl(
--     0,
--     "TreeClimberSiblingBoundary",
--     { background = color.terminal_color_5.hex }
-- )
--
-- vim.api.nvim_set_hl(
--     0,
--     "TreeClimberSibling",
--     { background = color.terminal_color_5.mix(bg, 40).hex, bold = true }
-- )
--
-- vim.api.nvim_set_hl(0, "TreeClimberParent", { background = bg.mix(fg, 2).hex })
--
-- vim.api.nvim_set_hl(
--     0,
--     "TreeClimberParentStart",
--     { background = color.terminal_color_4.mix(bg, 10).hex, bold = true }
-- )
--
-- nvim_treeclimber.setup()

function ColorScheme(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorScheme()
--------------
-- colorizer
local status_colorizer, colorizer = pcall(require, "colorizer")
if status_colorizer then
    colorizer.setup()
end
