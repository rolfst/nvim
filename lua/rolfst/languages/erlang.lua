local languages_setup = require("rolfst.utils")
local erlangls_config = require("rolfst.languages._configs").default_config({ "erlang" }, "erlang")

local language_configs = {}

language_configs["dependencies"] = { "erlang-ls" }

language_configs["lsp"] = function()
	return {
		["language"] = "erlang",
		["language-server"] = { "erlangls", erlangls_config },
	}
end

return language_configs
