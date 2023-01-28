local toggleterm_terminal_status_ok, toggleterm_terminal = pcall(require, "toggleterm.terminal")
if not toggleterm_terminal_status_ok then
	return
end
local terminal_one = toggleterm_terminal.Terminal:new({
	count = 1,
	direction = "horizontal",
	on_open = function(term)
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(
			term.bufnr,
			"t",
			"<Esc>",
			"<c-\\><c-n><cmd>close<cr><c-w><c-p>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-x>", "<c-\\><c-n>", { noremap = true, silent = true })
		vim.wo.cursorcolumn = false
		vim.wo.cursorline = false
		vim.cmd("startinsert!")
		vim.api.nvim_exec([[exe "normal \<C-W>\="]], true)
	end,
	on_close = function()
		vim.cmd("quit!")
	end,
})
local terminal_two = toggleterm_terminal.Terminal:new({
	count = 2,
	direction = "horizontal",
	on_open = function(term)
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(
			term.bufnr,
			"t",
			"<Esc>",
			"<c-\\><c-n><cmd>close<cr><c-w><c-p>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-x>", "<c-\\><c-n>", { noremap = true, silent = true })
		vim.wo.cursorcolumn = false
		vim.wo.cursorline = false
		vim.cmd("startinsert!")
		vim.api.nvim_exec([[exe "normal \<C-W>\="]], true)
	end,
	on_close = function()
		vim.cmd("quit!")
	end,
})
local terminal_three = toggleterm_terminal.Terminal:new({
	count = 3,
	direction = "horizontal",
	on_open = function(term)
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(
			term.bufnr,
			"t",
			"<Esc>",
			"<c-\\><c-n><cmd>close<cr><c-w><c-p>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-x>", "<c-\\><c-n>", { noremap = true, silent = true })
		vim.wo.cursorcolumn = false
		vim.wo.cursorline = false
		vim.cmd("startinsert!")
		vim.api.nvim_exec([[exe "normal \<C-W>\="]], true)
	end,
	on_close = function()
		vim.cmd("quit!")
	end,
})
local terminal_float = toggleterm_terminal.Terminal:new({
	count = 4,
	direction = "float",
	float_opts = {
		border = { " ", " ", " ", " ", " ", " ", " ", " " },
		winblend = 0,
		width = vim.o.columns - 20,
		height = vim.o.lines - 9,
		highlights = {
			border = "FloatBorder",
			background = "NormalFloat",
		},
	},
	on_open = function(term)
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<c-\\><c-n><cmd>close<cr><c-w><c-p>", { noremap = true })
		vim.wo.cursorcolumn = false
		vim.wo.cursorline = false
		vim.cmd("startinsert!")
	end,
	on_close = function()
		vim.cmd("quit!")
	end,
})
local lazygit = toggleterm_terminal.Terminal:new({
	cmd = "lazygit",
	hidden = true,
	count = 4,
	direction = "float",
	float_opts = {
		border = { " ", " ", " ", " ", " ", " ", " ", " " },
		winblend = 0,
		width = vim.o.columns - 20,
		height = vim.o.lines - 9,
		highlights = {
			border = "FloatBorder",
			background = "NormalFloat",
		},
	},
})

local function _lazygit_toggle()
	lazygit:toggle()
end
vim.api.nvim_create_user_command("TermOne", function()
	terminal_one:toggle()
end, {})
vim.api.nvim_create_user_command("TermTwo", function()
	terminal_two:toggle()
end, {})
vim.api.nvim_create_user_command("TermThree", function()
	terminal_three:toggle()
end, {})
vim.api.nvim_create_user_command("TermFloat", function()
	terminal_float:toggle()
end, {})
vim.keymap.set("n", "<F1>", function()
	terminal_one:toggle()
end, { noremap = true, silent = true, desc = "Terminal One" })
vim.keymap.set("n", "<F2>", function()
	terminal_two:toggle()
end, { noremap = true, silent = true, desc = "Terminal Two" })
vim.keymap.set("n", "<F3>", function()
	terminal_three:toggle()
end, { noremap = true, silent = true, desc = "Terminal Three" })
vim.keymap.set("n", "<F4>", ":TermFloat<cr>", { noremap = true, silent = true, desc = "Terminal Float" })

vim.api.nvim_create_user_command("LazyGit", function()
	_lazygit_toggle()
end, {})
vim.keymap.set("n", "<space>gl", ":LazyGit<cr>", { desc = "Lazygit" })
