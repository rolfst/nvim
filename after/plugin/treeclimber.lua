local nvim_treeclimber_status_ok, nvim_treeclimber = pcall(require, "nvim-treeclimber")
if not nvim_treeclimber_status_ok then
	return
end
vim.api.nvim_set_hl(
	0,
	"TreeClimberHighlight",
	{ background = _G.LVIM_SETTINGS.colorschemes.colors[_G.LVIM_SETTINGS.colorschemes.theme].bg_05 }
)
vim.api.nvim_set_hl(
	0,
	"TreeClimberSiblingBoundary",
	{ background = _G.LVIM_SETTINGS.colorschemes.colors[_G.LVIM_SETTINGS.colorschemes.theme].bg }
)
vim.api.nvim_set_hl(0, "TreeClimberSibling", {
	background = _G.LVIM_SETTINGS.colorschemes.colors[_G.LVIM_SETTINGS.colorschemes.theme].bg_04,
	bold = true,
})
vim.api.nvim_set_hl(
	0,
	"TreeClimberParent",
	{ background = _G.LVIM_SETTINGS.colorschemes.colors[_G.LVIM_SETTINGS.colorschemes.theme].orange_01 }
)
vim.api.nvim_set_hl(
	0,
	"TreeClimberParentStart",
	{ background = _G.LVIM_SETTINGS.colorschemes.colors[_G.LVIM_SETTINGS.colorschemes.theme].teal_01, bold = true }
)
vim.keymap.set("n", "<leader>k", nvim_treeclimber.show_control_flow, {})
vim.keymap.set({ "x", "o" }, "i.", nvim_treeclimber.select_current_node, { desc = "select current node" })
vim.keymap.set({ "x", "o" }, "a.", nvim_treeclimber.select_expand, { desc = "select parent node" })
vim.keymap.set(
	{ "n", "x", "o" },
	"tle",
	nvim_treeclimber.select_forward_end,
	{ desc = "select and move to the end of the node, or the end of the next node" }
)
vim.keymap.set(
	{ "n", "x", "o" },
	"tlb",
	nvim_treeclimber.select_backward,
	{ desc = "select and move to the begining of the node, or the beginning of the next node" }
)
vim.keymap.set({ "n", "x", "o" }, "tl[", nvim_treeclimber.select_siblings_backward, {})
vim.keymap.set({ "n", "x", "o" }, "tl]", nvim_treeclimber.select_siblings_forward, {})
vim.keymap.set(
	{ "n", "x", "o" },
	"tlg",
	nvim_treeclimber.select_top_level,
	{ desc = "select the top level node from the current position" }
)
vim.keymap.set({ "n", "x", "o" }, "tlh", nvim_treeclimber.select_backward, { desc = "select previous node" })
vim.keymap.set({ "n", "x", "o" }, "tlj", nvim_treeclimber.select_shrink, { desc = "select child node" })
vim.keymap.set({ "n", "x", "o" }, "tlk", nvim_treeclimber.select_expand, { desc = "select parent node" })
vim.keymap.set({ "n", "x", "o" }, "tll", nvim_treeclimber.select_forward, { desc = "select the next node" })
vim.keymap.set(
	{ "n", "x", "o" },
	"tlL",
	nvim_treeclimber.select_grow_forward,
	{ desc = "Add the next node to the selection" }
)
vim.keymap.set(
	{ "n", "x", "o" },
	"tlH",
	nvim_treeclimber.select_grow_backward,
	{ desc = "Add the next node to the selection" }
)
