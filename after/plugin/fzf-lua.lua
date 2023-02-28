local status_ok, fzf_lua = pcall(require, "fzf-lua")
if not status_ok then
	return false
end

local actions = require("fzf-lua.actions")
fzf_lua.setup({
	winopts = {
		height = 0.90,
		width = 0.65,
		row = 0.30,
		col = 0.70,
		hl = {
			border = "FloatBorder",
		},
		preview = {
			default = "head",
			vertical = "down:60%",
			layout = "vertical",
			scrollbar = "float",
		},
	},
	actions = {
		files = {
			["default"] = actions.file_edit_or_qf,
			["ctrl-h"] = actions.file_split,
			["ctrl-v"] = actions.file_vsplit,
			["alt-q"] = actions.file_sel_to_qf,
			["alt-l"] = actions.file_sel_to_ll,
		},
		buffers = {
			["default"] = actions.buf_edit,
			["ctrl-h"] = actions.buf_split,
			["ctrl-v"] = actions.buf_vsplit,
		},
	},
	keymap = {
		builtin = {
			["<F1>"] = "toggle-help",
			["<F2>"] = "toggle-fullscreen",
			["<F10>"] = "toggle-preview",
			["<F11>"] = "toggle-preview-ccw",
			["<ctrl-d>"] = "preview-page-down",
			["<ctrl-u>"] = "preview-page-up",
		},
		fzf = {
			["ctrl-a"] = "toggle-all",
			["ctrl-f"] = "half-page-down",
			["ctrl-b"] = "half-page-up",
		},
	},
	files = {
		prompt = "Files> ",
		git_icons = false,
		cmd = table.concat({
			"find .",
			"-type f",
			'-not -path "*node_modules*"',
			'-not -path "*/.git/*"',
			'-printf "%P\n"',
		}, " "),
	},
	git = {
		files = {
			prompt = "> ",
		},
		status = {
			prompt = "GitStatus> ",
		},
		commits = {
			prompt = "Commits> ",
		},
		bcommits = {
			prompt = "BufferCommits> ",
		},
		branches = {
			prompt = "Branches> ",
		},
	},
	grep = {
		prompt = "Grep> ",
		input_prompt = "Grep> ",
		git_icons = false,
		cmd = "rg --vimgrep",
		-- cmd = "git grep --line-number --column -I --ignore-case",
	},
	args = {
		prompt = "Args> ",
	},
	oldfiles = {
		prompt = "OldFiles> ",
	},
	buffers = {
		prompt = "Buffers> ",
		sort_lastused = true,
		actions = {
			["ctrl-x"] = { actions.buf_del, actions.resume },
		},
	},
	blines = {
		prompt = "BufferLines> ",
	},
	colorschemes = {
		prompt = "Colorschemes> ",
	},
	lsp = {
		prompt = "> ",
	},
	helptags = { previewer = { _ctor = false } },
	manpages = { previewer = { _ctor = false } },
})

vim.keymap.set("n", "<A-b>", function()
	vim.cmd("FzfLua buffers")
end, { noremap = true, silent = true, desc = "Buffers" })
vim.keymap.set("n", "<space>tf", function()
	fzf_lua.files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<space>to", function()
	fzf_lua.oldfiles()
end, { desc = "Find recent files" })
vim.keymap.set("n", "<space>tt", function()
	fzf_lua.tmux_buffers()
end, { desc = "List tmux buffers" })
vim.keymap.set("n", "<space>tw", function()
	fzf_lua.live_grep()
end, { desc = "Search word" })
vim.keymap.set("n", "<space>tg", function()
	fzf_lua.git_files()
end, { desc = "Find git files" })
vim.keymap.set("n", "<space>tgs", function()
	fzf_lua.git_status()
end, { desc = "Find git status" })
vim.keymap.set("n", "<space>tgb", function()
	fzf_lua.git_branches()
end, { desc = "Find git branches" })
vim.keymap.set("n", "<space>tgv", function()
	fzf_lua.git_stash()
end, { desc = "Find git stash" })
vim.keymap.set("n", "<space>tk", function()
	fzf_lua.keymaps()
end, { desc = "Find keymaps" })
vim.keymap.set("n", "<space>tb", function()
	fzf_lua.buffers()
end, { desc = "Show buffers" })
vim.keymap.set("n", "<space>tp", function()
	fzf_lua.grep_cword()
end, { desc = "search word under cursor" })
vim.keymap.set("n", "<space>tm", function()
	fzf_lua.marks()
end, { desc = "search marks" })
vim.keymap.set("n", "<space>tmn", function()
	fzf_lua.menu()
end, { desc = "search menu" })
vim.keymap.set("n", "<space>tc", function()
	fzf_lua.commands()
end, { desc = "search commands" })
vim.keymap.set("n", "<space>tcl", function()
	fzf_lua.colorschemes()
end, { desc = "search color schemes" })
vim.keymap.set("n", "<space>tj", function()
	fzf_lua.jumps()
end, { desc = "search jumps" })
