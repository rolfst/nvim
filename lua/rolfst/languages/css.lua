local languages_setup = require("rolfst.utils")
local cssls_config = require("rolfst.languages._configs").without_formatting({ "css", "scss", "less", "sass" }, "css")

local language_configs = {}

language_configs["dependencies"] = { "css-lsp", "prettierd" }

language_configs["lsp"] = function()
	return {
		["language"] = "css",
		["language-server"] = { "cssls", cssls_config },
		["dependencies"] = {
			"prettierd",
		},
	}
end

return language_configs
