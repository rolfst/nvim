local languages_setup = require("rolfst.utils")
local jsonls_config = require("rolfst.languages._configs").default_config({ "json" }, "json")

local language_configs = {}

language_configs["dependencies"] = { "json-lsp" }

language_configs["lsp"] = function()
	return {
		["language"] = "json",
		["language-server"] = { "jsonls", jsonls_config },
	}
end

return language_configs
