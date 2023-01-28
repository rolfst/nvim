local statuscol_nvim_status_ok, statuscol_nvim = pcall(require, "statuscol")
if not statuscol_nvim_status_ok then
	return
end
local builtin = require("statuscol.builtin")
statuscol_nvim.setup({
	separator = " ",
	thousands = false,
	relculright = true,
	lnumfunc = nil,
	reeval = true,
	setopt = true,
	order = "FSNs",
	Lnum = false,
	FoldPlus = false,
	FoldMinus = false,
	FoldEmpty = false,
	-- click actions
	DapBreakpointRejected = false,
	DapBreakpoint = builtin.toggle_breakpoint,
	DapBreakpointCondition = builtin.toggle_breakpoint,
	DiagnosticSignError = builtin.diagnostic_click,
	DiagnosticSignHint = builtin.diagnostic_click,
	DiagnosticSignInfo = builtin.diagnostic_click,
	DiagnosticSignWarn = builtin.diagnostic_click,
	GitSignsTopdelete = false,
	GitSignsUntracked = false,
	GitSignsAdd = builtin.gitsigns_click,
	GitSignsChangedelete = false,
	GitSignsDelete = false,
})
