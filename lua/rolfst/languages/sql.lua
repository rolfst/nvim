local languages_setup = require("rolfst.utils")
local sqls_config = require("rolfst.languages._configs").default_config({ "sql", "mysql" }, "sql")

local language_configs = {}

language_configs["dependencies"] = { "sqls" }

language_configs["lsp"] = function()
	return {
		["language"] = "sql",
		["language-server"] = { "sqls", sqls_config },
	}
end

return language_configs
