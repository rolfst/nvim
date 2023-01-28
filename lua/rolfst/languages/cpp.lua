local global = require("rolfst.global")
local languages_setup = require("rolfst.utils")
local clangd_config = require("rolfst.languages._configs").cpp_config({ "c", "cpp", "objc", "objcpp" }, "cpp")
local dap = require("dap")

local language_configs = {}

language_configs["dependencies"] = { "clangd", "cpptools", "cpplint" }

language_configs["lsp"] = function()
	return {
		["language"] = "cpp",
		["dap"] = { "cpptools" },
		["language-server"] = { "clangd", clangd_config },
		["dependencies"] = {
			"cpplint",
		},
	}
end

language_configs["dap"] = function()
	dap.adapters.cppdbg = {
		id = "cppdbg",
		type = "executable",
		command = global.mason_path .. "/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
	}
	dap.configurations.cpp = {
		{
			name = "Launch file",
			type = "cppdbg",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = true,
		},
		{
			name = "Attach to gdbserver :1234",
			type = "cppdbg",
			request = "launch",
			MIMode = "gdb",
			miDebuggerServerAddress = "localhost:1234",
			miDebuggerPath = "/usr/bin/gdb",
			cwd = "${workspaceFolder}",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
		},
	}
end

return language_configs
