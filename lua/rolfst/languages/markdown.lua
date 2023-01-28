local languages_setup = require("rolfst.utils")
local marksman_config = require("rolfst.languages._configs").without_formatting({ "markdown" }, "markdown")

local language_configs = {}

language_configs["dependencies"] = { "marksman", "prettierd", "cbfmt" }

language_configs["lsp"] = function()
	return {
		["language"] = "markdown",
		["language-server"] = { "marksman", marksman_config },
		["dependencies"] = {
			"prettierd",
			"cbfmt",
		},
	}
end

return language_configs
