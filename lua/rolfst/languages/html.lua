local languages_setup = require("rolfst.utils")
local html_config = require("rolfst.languages._configs").without_formatting({ "html" }, "html")

local language_configs = {}

language_configs["dependencies"] = { "html-lsp", "prettierd" }

language_configs["lsp"] = function()
	return {
		["language"] = "html",
		["language-server"] = { "html", html_config },
		["dependencies"] = {
			"prettierd",
		},
	}
end

return language_configs
