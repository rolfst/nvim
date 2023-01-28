local languages_setup = require("rolfst.utils")
local graphql_config = require("rolfst.languages._configs").default_config({ "graphql" }, "graphql")

local language_configs = {}

language_configs["dependencies"] = { "graphql-language-service-cli" }

language_configs["lsp"] = function()
	return {
		["language"] = "graphql",
		["language-server"] = { "graphql", graphql_config },
	}
end

return language_configs
