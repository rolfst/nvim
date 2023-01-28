local languages_setup = require("rolfst.utils")
local yamlls_config = require("rolfst.languages._configs").without_formatting({ "yaml" }, "yaml")

local language_configs = {}

language_configs["dependencies"] = { "yaml-language-server", "yamllint" }

language_configs["lsp"] = function()
	return {
		["language"] = "yaml",
		["language-server"] = { "yamlls", yamlls_config },
		["dependencies"] = {
			"yamllint",
		},
	}
end

return language_configs
