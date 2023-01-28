local global = require("rolfst.global")
local languages_setup = require("rolfst.utils")
local nvim_lsp_util = require("lspconfig/util")
local navic = require("nvim-navic")
local default_debouce_time = 150
local dap = require("dap")

local language_configs = {}

local function start_server_tools()
	local typescript = require("typescript")
	typescript.setup({
		disable_commands = false, -- prevent the plugin from creating Vim commands
		debug = false, -- enable debug logging for commands
		go_to_source_definition = {
			fallback = true, -- fall back to standard LSP definition on failure
		},
		server = {
			flags = {
				debounce_text_changes = default_debouce_time,
			},
			autostart = true,
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			on_attach = function(client, bufnr)
				-- languages_setup.keymaps(client, bufnr)
				languages_setup.omni(client, bufnr)
				languages_setup.tag(client, bufnr)
				languages_setup.document_highlight(client, bufnr)
				navic.attach(client, bufnr)
			end,
			capabilities = languages_setup.get_capabilities(),
			root_dir = function(fname)
				return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
			end,
		},
	})
	vim.cmd("LspStart tsserver")
end

language_configs["dependencies"] = { "typescript-language-server", "js-debug-adapter", "prettierd" }

language_configs["lsp"] = function()
	return {
		["language"] = "jsts",
		["dap"] = { "js-debug-adapter" },
		["dependencies"] = {
			"prettierd",
		},
		["callback"] = start_server_tools,
	}
end

language_configs["dap"] = function()
	dap.configurations.javascript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
			trace = true,
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Mocha Tests",
			trace = true,
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/mocha/bin/mocha.js",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
	}
	dap.configurations.typescript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
			trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Mocha Tests",
			trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/mocha/bin/mocha.js",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
	}
end

return language_configs
