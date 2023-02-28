local M = {}

function M.setup()
	vim.keymap.set("n", "<S-m>", function()
		vim.cmd("MarkdownPreviewToggle")
	end, { noremap = true, silent = true, desc = "MarkdownPreviewToggle" })
end

return M
