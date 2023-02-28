local languages_setup = require("rolfst.utils")
local sumneko_lua_config = require("rolfst.languages._configs").lua({ "lua" }, "lua")
local dap = require("dap")

local language_configs = {}

language_configs["dependencies"] = { "lua-language-server", "stylua", "luacheck" }

language_configs["lsp"] = function()
	return {
		["language"] = "lua",
		["language-server"] = { "lua_ls", sumneko_lua_config },
	}
end

language_configs["dap"] = function()
	dap.adapters.nlua = function(callback, config)
		callback({ type = "server", host = config.host, port = config.port })
	end
	dap.configurations.lua = {
		{
			type = "nlua",
			request = "attach",
			name = "Attach to running Neovim instance",
			host = function()
				local value = vim.fn.input("Host [127.0.0.1]: ")
				if value ~= "" then
					return value
				end
				return "127.0.0.1"
			end,
			port = function()
				local value = tonumber(vim.fn.input("Port: "))
				assert(value, "Please provide a port number")
				if value ~= "" then
					return value
				end
				return 8086
			end,
		},
	}
end

return language_configs
