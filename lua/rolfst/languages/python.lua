local global = require("rolfst.global")
local languages_setup = require("rolfst.utils")
local pyright_config = require("rolfst.languages._configs").without_formatting({ "python" }, "python")
local dap = require("dap")

local language_configs = {}

language_configs["dependencies"] = { "pyright", "debugpy", "flake8", "black" }

language_configs["lsp"] = function()
	return {
		["language"] = "python",
		["dap"] = { "debugpy" },
		["language-server"] = { "pyright", pyright_config },
		["dependencies"] = {
			"flake8",
			"black",
		},
	}
end

language_configs["dap"] = function()
	dap.adapters.python = {
		type = "executable",
		command = global.mason_path .. "/packages/debugpy/venv/bin/python",
		args = { "-m", "debugpy.adapter" },
	}
	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Debug",
			program = "${file}",
			pythonPath = function()
				local venv_path = os.getenv("VIRTUAL_ENV")
				if venv_path then
					return venv_path .. "/bin/python"
				end
				if vim.fn.executable(global.mason_path .. "/packages/debugpy/venv/" .. "bin/python") == 1 then
					return global.mason_path .. "/packages/debugpy/venv/" .. "bin/python"
				else
					return "python"
				end
			end,
		},
		{
			type = "python",
			request = "launch",
			name = "Launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			pythonPath = function()
				local venv_path = os.getenv("VIRTUAL_ENV")
				if venv_path then
					return venv_path .. "/bin/python"
				end
				if vim.fn.executable(global.mason_path .. "/packages/debugpy/venv/" .. "bin/python") == 1 then
					return global.mason_path .. "/packages/debugpy/venv/" .. "bin/python"
				else
					return "python"
				end
			end,
		},
	}
end

return language_configs
