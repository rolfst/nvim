vim.keymap.set("n", "<S-m>", function()
	vim.cmd("MarkdownPreviewToggle")
end, { noremap = true, silent = true, desc = "MarkdownPreviewToggle" })

vim.keymap.set("n", "<S-m>n", function()
	vim.fn["NerdSlides#next"]()
end)
vim.cmd([[
let g:presenting_font_large = 'pagga'
]])
vim.keymap.set("n", "<S-m>s", function()
	vim.cmd("PresentingStart")
end, { noremap = true, silent = true, desc = "Start Presenting markdown" })
vim.keymap.set("n", "<S-m>q", function()
	vim.cmd("PresentingExit")
end, { noremap = true, silent = true, desc = "Stop Presenting markdown" })
