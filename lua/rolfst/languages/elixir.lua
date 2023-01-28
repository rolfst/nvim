local global = require("rolfst.global")
local languages_setup = require("rolfst.utils")
local elixirls_config = require("rolfst.languages._configs").elixir_config({ "elixir", "eelixir" }, "elixir")
local dap = require("dap")

local language_configs = {}

language_configs["dependencies"] = { "elixir-ls" }

language_configs["lsp"] = function()
	return {
		["language"] = "elixir",
		["language-server"] = { "elixirls", elixirls_config },
	}
end

language_configs["dap"] = function()
	dap.adapters.mix_task = {
		type = "executable",
		command = global.mason_path .. "/bin/elixir-ls-debugger",
		args = {},
	}
	dap.configurations.elixir = {
		{
			type = "mix_task",
			name = "mix test",
			task = "test",
			taskArgs = { "--trace" },
			request = "launch",
			startApps = true,
			projectDir = "${workspaceFolder}",
			requireFiles = {
				"test/**/test_helper.exs",
				"test/**/*_test.exs",
			},
		},
	}
end

return language_configs
