local statuscol_nvim_status_ok, statuscol_nvim = pcall(require, "statuscol")
if not statuscol_nvim_status_ok then
	return
end
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
	DapBreakpointRejected = false,
	DapBreakpoint = false,
	DapBreakpointCondition = false,
	DiagnosticSignError = false,
	DiagnosticSignHint = false,
	DiagnosticSignInfo = false,
	DiagnosticSignWarn = false,
	GitSignsTopdelete = false,
	GitSignsUntracked = false,
	GitSignsAdd = false,
	GitSignsChangedelete = false,
	GitSignsDelete = false,
})
