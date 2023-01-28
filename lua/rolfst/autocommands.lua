local group = vim.api.nvim_create_augroup("NvimIDE", {
	clear = true,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		-- require("rolfst.modules.lsp").setup()
	end,
	group = group,
})
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWinLeave" }, {
	callback = function()
		local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo.buftype)
		local filetype = vim.tbl_contains({
			"calendar",
			"Outline",
			"git",
			"dapui_scopes",
			"dapui_breakpoints",
			"dapui_stacks",
			"dapui_watches",
			"NeogitStatus",
			"octo",
			"toggleterm",
		}, vim.bo.filetype)
		if buftype or filetype then
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.opt_local.cursorcolumn = false
			vim.opt_local.colorcolumn = "0"
		end
	end,
	group = group,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"c",
		"cpp",
		"dart",
		"haskell",
		"objc",
		"objcpp",
		"ruby",
	},
	command = "setlocal ts=2 sw=2",
	group = group,
})
