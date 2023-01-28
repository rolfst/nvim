local languages_setup = require("rolfst.utils")
local taplo_config = require("rolfst.languages._configs").default_config({ "toml" }, "toml")

local language_configs = {}

language_configs["dependencies"] = { "taplo" }

language_configs["lsp"] = function()
	return {
		["language"] = "toml",
		["language-server"] = { "taplo", taplo_config },
	}
end

return language_configs
