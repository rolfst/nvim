local global = require("rolfst.global")
local languages_setup = require("rolfst.utils")
local omnisharp_config = require("rolfst.languages._configs").omnisharp_config({ "cs", "vb" }, "cs")
local dap = require("dap")

local language_configs = {}

language_configs["dependencies"] = { "omnisharp", "netcoredbg" }

language_configs["lsp"] = function()
	return {
		["language"] = "cs",
		["dap"] = { "netcoredbg" },
		["language-server"] = { "omnisharp", omnisharp_config },
	}
end

language_configs["dap"] = function()
	dap.adapters.netcoredbg = {
		type = "executable",
		command = global.mason_path .. "/packages/netcoredbg/netcoredbg",
		args = { "--interpreter=vscode" },
	}
	dap.configurations.cs = {
		{
			type = "netcoredbg",
			request = "launch",
			name = "Launch",
			program = function()
				return vim.fn.input(
					global.mason_path .. "/packages/netcoredbg/build/ManagedPart.dll",
					vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				)
			end,
		},
	}
end

return language_configs
