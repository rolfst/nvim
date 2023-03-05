
	vim.keymap.set("n", "<S-m>", function()
		vim.cmd("MarkdownPreviewToggle")
	end, { noremap = true, silent = true, desc = "MarkdownPreviewToggle" })

