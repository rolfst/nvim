local languages_setup = require("rolfst.utils")
local elmls_config = require("rolfst.languages._configs").default_config({ "elm" }, "elm")

local language_configs = {}

language_configs["dependencies"] = { "elm-language-server" }

language_configs["lsp"] = function()
	return {
		["language"] = "elm",
		["language-server"] = { "elmls", elmls_config },
	}
end

return language_configs
